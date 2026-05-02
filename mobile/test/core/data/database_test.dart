import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:involt/core/data/database.dart';
import 'package:involt/core/data/repositories/drift_reading_repository.dart';

void main() {
  late AppDatabase database;
  late DriftReadingRepository repository;

  setUp(() {
    // Use an in-memory database for testing
    database = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftReadingRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should save and retrieve a reading correctly', () async {
    // 1. Setup metadata
    final community = CommunitiesCompanion.insert(id: 'com-1', name: 'Chetilla');
    await database.into(database.communities).insert(community);

    final sector = SectorsCompanion.insert(id: 'sec-A', communityId: 'com-1', name: 'Sector A');
    await database.into(database.sectors).insert(sector);

    final customer = CustomersCompanion.insert(
      id: 'cust-1',
      code: 'ACH001',
      name: 'Juan Perez',
      communityId: 'com-1',
      sectorId: 'sec-A',
      connectionType: 1,
      tariff: 0.25,
      meterNumber: 'M-123',
    );
    await database.into(database.customers).insert(customer);

    // 2. Create a reading
    final reading = Reading(
      id: 'read-1',
      customerId: 'cust-1',
      period: '2026-04',
      previousValue: 100.0,
      currentValue: 150.0,
      consumptionKwh: 50.0,
      timestamp: DateTime.now(),
      latitude: -7.0,
      longitude: -78.0,
      cargoFijo: 6.0,
      alumbradoPublico: 1.0,
      saldoRedondeo: 0.0,
      totalToPay: 7.0,
      isSynced: false,
    );

    // 3. Save
    await repository.saveReading(reading);

    // 4. Verify
    final results = await repository.getReadingsForCustomer('cust-1');
    
    expect(results.length, 1);
    expect(results.first.id, 'read-1');
    expect(results.first.consumptionKwh, 50.0);
  });
}
