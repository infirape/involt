import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Communities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Sectors extends Table {
  TextColumn get id => text()();
  TextColumn get communityId => text().references(Communities, #id)();
  TextColumn get name => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()(); // e.g., ACH001
  TextColumn get name => text()();
  TextColumn get communityId => text().references(Communities, #id)();
  TextColumn get sectorId => text().references(Sectors, #id)();
  IntColumn get connectionType => integer()(); // 1: Monofasica, 2: Trifasica
  RealColumn get tariff => real()();
  TextColumn get meterNumber => text()();
  RealColumn get latitude => real().withDefault(const Constant(0.0))();
  RealColumn get longitude => real().withDefault(const Constant(0.0))();
  RealColumn get lastReadingValue => real().withDefault(const Constant(0.0))();
  RealColumn get initialReading => real().withDefault(const Constant(0.0))();
  @override
  Set<Column> get primaryKey => {id};
}

class Readings extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get period => text().withDefault(const Constant(''))(); // Added default for migration safety
  RealColumn get previousValue => real()();
  RealColumn get currentValue => real()();
  RealColumn get consumptionKwh => real()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  
  // Financial data captured at reading time
  RealColumn get cargoFijo => real()();
  RealColumn get alumbradoPublico => real()();
  RealColumn get saldoRedondeo => real()();
  RealColumn get totalToPay => real()();
  
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  TextColumn get comment => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Communities, Sectors, Customers, Readings, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withExecutor(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      print('🚀 Database Upgrade: from $from to $to');
      if (from < 2) {
        await m.addColumn(customers, customers.latitude);
        await m.addColumn(customers, customers.longitude);
      }
      if (from < 3) {
        await m.addColumn(customers, customers.lastReadingValue);
      }
      if (from < 4) {
        await m.createTable(settings);
      }
      if (from < 5) {
        // Use raw SQL to ensure NOT NULL column has a DEFAULT value during migration
        await this.customStatement('ALTER TABLE readings ADD COLUMN period TEXT NOT NULL DEFAULT ""');
      }
      if (from < 6) {
        await m.addColumn(readings, readings.comment);
      }
      if (from < 7) {
        await m.addColumn(customers, customers.initialReading);
      }
    },
    beforeOpen: (details) async {
      print('📂 Database opened. Version: ${details.versionBefore} -> ${details.versionNow}');
      if (details.wasCreated) {
        print('✨ Database created for the first time');
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'involt.sqlite'));
    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}
