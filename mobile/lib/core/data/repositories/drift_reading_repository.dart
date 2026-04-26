import 'package:drift/drift.dart';
import '../../domain/repositories/reading_repository.dart';
import '../database.dart';

class DriftReadingRepository implements ReadingRepository {
  final AppDatabase db;

  DriftReadingRepository(this.db);

  @override
  Future<void> saveReading(Reading reading) async {
    await db.into(db.readings).insert(
          reading.toCompanion(true),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<List<Reading>> getReadingsForCustomer(String customerId) {
    return (db.select(db.readings)..where((t) => t.customerId.equals(customerId))).get();
  }

  @override
  Future<List<Reading>> getUnsyncedReadings() {
    return (db.select(db.readings)..where((t) => t.isSynced.equals(false))).get();
  }

  @override
  Future<void> markAsSynced(String readingId) async {
    await (db.update(db.readings)..where((t) => t.id.equals(readingId)))
        .write(const ReadingsCompanion(isSynced: Value(true)));
  }
}
