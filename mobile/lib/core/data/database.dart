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
  @override
  Set<Column> get primaryKey => {id};
}

class Readings extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();
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

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Communities, Sectors, Customers, Readings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withExecutor(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'involt.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
