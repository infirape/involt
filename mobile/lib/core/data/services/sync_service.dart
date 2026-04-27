import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'package:connectrpc/connect.dart' hide Transport;
import 'package:connectrpc/io.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:drift/drift.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import '../../gen/proto/involt/v1/sync.pb.dart' as pb;
import '../../gen/proto/involt/v1/models.pb.dart' as models;
import '../database.dart';

import '../../config/app_config.dart';

class SyncService {
  final AppDatabase db;
  final String baseUrl;

  SyncService({required this.db, this.baseUrl = AppConfig.baseUrl});

  Future<void> pullMetadata() async {
    // Instantiate the concrete Connect Transport with an IO client
    final transport = protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(io.HttpClient()),
    );

    try {
      // Manual Unary Call using the correct Spec class and factories
      final response = await transport.unary<pb.PullMetadataRequest, pb.PullMetadataResponse>(
        Spec(
          '/involt.v1.SyncService/PullMetadata',
          StreamType.unary,
          () => pb.PullMetadataRequest(),
          () => pb.PullMetadataResponse(),
        ),
        pb.PullMetadataRequest(),
      );

      print('✅ Sync: Received ${response.message.sectors.length} sectors and ${response.message.communities.length} communities');

      // Update local database
      await db.batch((batch) {
        // 1. Communities
        for (final comm in response.message.communities) {
          batch.insert(
            db.communities,
            CommunitiesCompanion.insert(
              id: comm.id,
              name: comm.name,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 2. Sectors
        for (final sector in response.message.sectors) {
          batch.insert(
            db.sectors,
            SectorsCompanion.insert(
              id: sector.id,
              communityId: sector.communityId,
              name: sector.name,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 3. Customers
        for (final cust in response.message.customers) {
          batch.insert(
            db.customers,
            CustomersCompanion.insert(
              id: cust.id,
              code: cust.code,
              name: cust.name,
              communityId: cust.communityId,
              sectorId: cust.sectorId,
              connectionType: cust.connectionType.value,
              tariff: cust.tariff,
              meterNumber: cust.meterNumber,
              latitude: Value(cust.latitude),
              longitude: Value(cust.longitude),
              lastReadingValue: Value(cust.lastReadingValue),
              initialReading: Value(cust.initialReading),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 4. Config
        if (response.message.hasConfig()) {
          final config = response.message.config;
          batch.insert(
            db.settings,
            SettingsCompanion.insert(
              key: 'map_url_template',
              value: config.mapUrlTemplate,
            ),
            mode: InsertMode.insertOrReplace,
          );
          batch.insert(
            db.settings,
            SettingsCompanion.insert(
              key: 'map_user_agent',
              value: config.mapUserAgent,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
      print('✅ Sync: Metadata updated (including config)');
    } catch (e) {
      print('❌ Sync Error (Pull): $e');
      rethrow;
    }
  }

  Future<void> hardReset() async {
    print('🚨 Sync: Performing HARD RESET...');
    await db.transaction(() async {
      await db.delete(db.readings).go();
      await db.delete(db.customers).go();
      await db.delete(db.sectors).go();
      await db.delete(db.communities).go();
    });
    print('✅ Sync: Local database cleared.');
  }

  Future<String?> uploadPhoto(io.File photo) async {
    final transport = protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(io.HttpClient()),
    );

    try {
      final bytes = await photo.readAsBytes();
      final response = await transport.unary<pb.UploadPhotoRequest, pb.UploadPhotoResponse>(
        Spec(
          '/involt.v1.SyncService/UploadPhoto',
          StreamType.unary,
          () => pb.UploadPhotoRequest(),
          () => pb.UploadPhotoResponse(),
        ),
        pb.UploadPhotoRequest(
          fileName: p.basename(photo.path),
          data: bytes,
        ),
      );
      return response.message.url;
    } catch (e) {
      print('❌ Sync Error (Photo Upload): $e');
      return null;
    }
  }

  Future<void> pushReadings() async {
    final transport = protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(io.HttpClient()),
    );

    try {
      // 1. Get unsynced readings
      final unsynced = await (db.select(db.readings)..where((r) => r.isSynced.equals(false))).get();
      if (unsynced.isEmpty) {
        print('ℹ️ Sync: No new readings to push');
        return;
      }

      print('📤 Sync: Pushing ${unsynced.length} readings...');

      // 2. Prepare Protobuf request
      final request = pb.PushReadingsRequest();
      for (final r in unsynced) {
        String? remotePhotoUrl = r.photoUrl;
        
        // If it's a local file path, upload it first
        if (r.photoUrl != null && r.photoUrl!.startsWith('/') && io.File(r.photoUrl!).existsSync()) {
          print('📸 Sync: Uploading photo for reading ${r.id}...');
          remotePhotoUrl = await uploadPhoto(io.File(r.photoUrl!));
        }

        request.readings.add(models.Reading(
          id: r.id,
          customerId: r.customerId,
          previousValue: r.previousValue,
          currentValue: r.currentValue,
          consumptionKwh: r.consumptionKwh,
          photoUrl: remotePhotoUrl ?? '',
          timestamp: fixnum.Int64(r.timestamp.millisecondsSinceEpoch ~/ 1000),
          latitude: r.latitude,
          longitude: r.longitude,
          cargoFijo: r.cargoFijo,
          alumbradoPublico: r.alumbradoPublico,
          saldoRedondeo: r.saldoRedondeo,
          totalToPay: r.totalToPay,
        ));
      }

      // 3. Call RPC
      final response = await transport.unary<pb.PushReadingsRequest, pb.PushReadingsResponse>(
        Spec(
          '/involt.v1.SyncService/PushReadings',
          StreamType.unary,
          () => pb.PushReadingsRequest(),
          () => pb.PushReadingsResponse(),
        ),
        request,
      );

      if (response.message.success) {
        print('✅ Sync: Successfully pushed ${response.message.syncedCount} readings');
        
        // 4. Mark as synced in local DB
        await db.batch((batch) {
          for (final r in unsynced) {
            batch.update(
              db.readings,
              ReadingsCompanion(isSynced: const Value(true)),
              where: (tbl) => tbl.id.equals(r.id),
            );
          }
        });
      } else {
        print('⚠️ Sync: Server reported failure during push');
      }
    } catch (e) {
      print('❌ Sync Error (Push): $e');
      rethrow;
    }
  }

  Future<Uint8List?> downloadReceipt(String readingId) async {
    final transport = protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(io.HttpClient()),
    );

    try {
      final response = await transport.unary<pb.DownloadReceiptRequest, pb.DownloadReceiptResponse>(
        Spec(
          '/involt.v1.SyncService/DownloadReceipt',
          StreamType.unary,
          () => pb.DownloadReceiptRequest(),
          () => pb.DownloadReceiptResponse(),
        ),
        pb.DownloadReceiptRequest(readingId: readingId),
      );
      return Uint8List.fromList(response.message.pdfData);
    } catch (e) {
      print('❌ Sync Error (Download Receipt): $e');
      return null;
    }
  }
}
