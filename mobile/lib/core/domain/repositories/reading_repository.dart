import '../../data/database.dart';

abstract class ReadingRepository {
  Future<void> saveReading(Reading reading);
  Future<List<Reading>> getReadingsForCustomer(String customerId);
  Future<List<Reading>> getUnsyncedReadings();
  Future<void> markAsSynced(String readingId);
}
