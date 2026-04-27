// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CommunitiesTable extends Communities
    with TableInfo<$CommunitiesTable, Community> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'communities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Community> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Community map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Community(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CommunitiesTable createAlias(String alias) {
    return $CommunitiesTable(attachedDatabase, alias);
  }
}

class Community extends DataClass implements Insertable<Community> {
  final String id;
  final String name;
  const Community({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CommunitiesCompanion toCompanion(bool nullToAbsent) {
    return CommunitiesCompanion(id: Value(id), name: Value(name));
  }

  factory Community.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Community(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Community copyWith({String? id, String? name}) =>
      Community(id: id ?? this.id, name: name ?? this.name);
  Community copyWithCompanion(CommunitiesCompanion data) {
    return Community(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Community(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Community && other.id == this.id && other.name == this.name);
}

class CommunitiesCompanion extends UpdateCompanion<Community> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CommunitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommunitiesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Community> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommunitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CommunitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectorsTable extends Sectors with TableInfo<$SectorsTable, Sector> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _communityIdMeta = const VerificationMeta(
    'communityId',
  );
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
    'community_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES communities (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, communityId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sectors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sector> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
        _communityIdMeta,
        communityId.isAcceptableOrUnknown(
          data['community_id']!,
          _communityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_communityIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sector map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sector(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      communityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}community_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $SectorsTable createAlias(String alias) {
    return $SectorsTable(attachedDatabase, alias);
  }
}

class Sector extends DataClass implements Insertable<Sector> {
  final String id;
  final String communityId;
  final String name;
  const Sector({
    required this.id,
    required this.communityId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['community_id'] = Variable<String>(communityId);
    map['name'] = Variable<String>(name);
    return map;
  }

  SectorsCompanion toCompanion(bool nullToAbsent) {
    return SectorsCompanion(
      id: Value(id),
      communityId: Value(communityId),
      name: Value(name),
    );
  }

  factory Sector.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sector(
      id: serializer.fromJson<String>(json['id']),
      communityId: serializer.fromJson<String>(json['communityId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'communityId': serializer.toJson<String>(communityId),
      'name': serializer.toJson<String>(name),
    };
  }

  Sector copyWith({String? id, String? communityId, String? name}) => Sector(
    id: id ?? this.id,
    communityId: communityId ?? this.communityId,
    name: name ?? this.name,
  );
  Sector copyWithCompanion(SectorsCompanion data) {
    return Sector(
      id: data.id.present ? data.id.value : this.id,
      communityId: data.communityId.present
          ? data.communityId.value
          : this.communityId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sector(')
          ..write('id: $id, ')
          ..write('communityId: $communityId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, communityId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sector &&
          other.id == this.id &&
          other.communityId == this.communityId &&
          other.name == this.name);
}

class SectorsCompanion extends UpdateCompanion<Sector> {
  final Value<String> id;
  final Value<String> communityId;
  final Value<String> name;
  final Value<int> rowid;
  const SectorsCompanion({
    this.id = const Value.absent(),
    this.communityId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectorsCompanion.insert({
    required String id,
    required String communityId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       communityId = Value(communityId),
       name = Value(name);
  static Insertable<Sector> custom({
    Expression<String>? id,
    Expression<String>? communityId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (communityId != null) 'community_id': communityId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectorsCompanion copyWith({
    Value<String>? id,
    Value<String>? communityId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return SectorsCompanion(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectorsCompanion(')
          ..write('id: $id, ')
          ..write('communityId: $communityId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _communityIdMeta = const VerificationMeta(
    'communityId',
  );
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
    'community_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES communities (id)',
    ),
  );
  static const VerificationMeta _sectorIdMeta = const VerificationMeta(
    'sectorId',
  );
  @override
  late final GeneratedColumn<String> sectorId = GeneratedColumn<String>(
    'sector_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sectors (id)',
    ),
  );
  static const VerificationMeta _connectionTypeMeta = const VerificationMeta(
    'connectionType',
  );
  @override
  late final GeneratedColumn<int> connectionType = GeneratedColumn<int>(
    'connection_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tariffMeta = const VerificationMeta('tariff');
  @override
  late final GeneratedColumn<double> tariff = GeneratedColumn<double>(
    'tariff',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meterNumberMeta = const VerificationMeta(
    'meterNumber',
  );
  @override
  late final GeneratedColumn<String> meterNumber = GeneratedColumn<String>(
    'meter_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lastReadingValueMeta = const VerificationMeta(
    'lastReadingValue',
  );
  @override
  late final GeneratedColumn<double> lastReadingValue = GeneratedColumn<double>(
    'last_reading_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _initialReadingMeta = const VerificationMeta(
    'initialReading',
  );
  @override
  late final GeneratedColumn<double> initialReading = GeneratedColumn<double>(
    'initial_reading',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    communityId,
    sectorId,
    connectionType,
    tariff,
    meterNumber,
    latitude,
    longitude,
    lastReadingValue,
    initialReading,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
        _communityIdMeta,
        communityId.isAcceptableOrUnknown(
          data['community_id']!,
          _communityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_communityIdMeta);
    }
    if (data.containsKey('sector_id')) {
      context.handle(
        _sectorIdMeta,
        sectorId.isAcceptableOrUnknown(data['sector_id']!, _sectorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectorIdMeta);
    }
    if (data.containsKey('connection_type')) {
      context.handle(
        _connectionTypeMeta,
        connectionType.isAcceptableOrUnknown(
          data['connection_type']!,
          _connectionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionTypeMeta);
    }
    if (data.containsKey('tariff')) {
      context.handle(
        _tariffMeta,
        tariff.isAcceptableOrUnknown(data['tariff']!, _tariffMeta),
      );
    } else if (isInserting) {
      context.missing(_tariffMeta);
    }
    if (data.containsKey('meter_number')) {
      context.handle(
        _meterNumberMeta,
        meterNumber.isAcceptableOrUnknown(
          data['meter_number']!,
          _meterNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_meterNumberMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('last_reading_value')) {
      context.handle(
        _lastReadingValueMeta,
        lastReadingValue.isAcceptableOrUnknown(
          data['last_reading_value']!,
          _lastReadingValueMeta,
        ),
      );
    }
    if (data.containsKey('initial_reading')) {
      context.handle(
        _initialReadingMeta,
        initialReading.isAcceptableOrUnknown(
          data['initial_reading']!,
          _initialReadingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      communityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}community_id'],
      )!,
      sectorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector_id'],
      )!,
      connectionType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}connection_type'],
      )!,
      tariff: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tariff'],
      )!,
      meterNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meter_number'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      lastReadingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_reading_value'],
      )!,
      initialReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_reading'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String code;
  final String name;
  final String communityId;
  final String sectorId;
  final int connectionType;
  final double tariff;
  final String meterNumber;
  final double latitude;
  final double longitude;
  final double lastReadingValue;
  final double initialReading;
  const Customer({
    required this.id,
    required this.code,
    required this.name,
    required this.communityId,
    required this.sectorId,
    required this.connectionType,
    required this.tariff,
    required this.meterNumber,
    required this.latitude,
    required this.longitude,
    required this.lastReadingValue,
    required this.initialReading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['community_id'] = Variable<String>(communityId);
    map['sector_id'] = Variable<String>(sectorId);
    map['connection_type'] = Variable<int>(connectionType);
    map['tariff'] = Variable<double>(tariff);
    map['meter_number'] = Variable<String>(meterNumber);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['last_reading_value'] = Variable<double>(lastReadingValue);
    map['initial_reading'] = Variable<double>(initialReading);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      communityId: Value(communityId),
      sectorId: Value(sectorId),
      connectionType: Value(connectionType),
      tariff: Value(tariff),
      meterNumber: Value(meterNumber),
      latitude: Value(latitude),
      longitude: Value(longitude),
      lastReadingValue: Value(lastReadingValue),
      initialReading: Value(initialReading),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      communityId: serializer.fromJson<String>(json['communityId']),
      sectorId: serializer.fromJson<String>(json['sectorId']),
      connectionType: serializer.fromJson<int>(json['connectionType']),
      tariff: serializer.fromJson<double>(json['tariff']),
      meterNumber: serializer.fromJson<String>(json['meterNumber']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      lastReadingValue: serializer.fromJson<double>(json['lastReadingValue']),
      initialReading: serializer.fromJson<double>(json['initialReading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'communityId': serializer.toJson<String>(communityId),
      'sectorId': serializer.toJson<String>(sectorId),
      'connectionType': serializer.toJson<int>(connectionType),
      'tariff': serializer.toJson<double>(tariff),
      'meterNumber': serializer.toJson<String>(meterNumber),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'lastReadingValue': serializer.toJson<double>(lastReadingValue),
      'initialReading': serializer.toJson<double>(initialReading),
    };
  }

  Customer copyWith({
    String? id,
    String? code,
    String? name,
    String? communityId,
    String? sectorId,
    int? connectionType,
    double? tariff,
    String? meterNumber,
    double? latitude,
    double? longitude,
    double? lastReadingValue,
    double? initialReading,
  }) => Customer(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    communityId: communityId ?? this.communityId,
    sectorId: sectorId ?? this.sectorId,
    connectionType: connectionType ?? this.connectionType,
    tariff: tariff ?? this.tariff,
    meterNumber: meterNumber ?? this.meterNumber,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    lastReadingValue: lastReadingValue ?? this.lastReadingValue,
    initialReading: initialReading ?? this.initialReading,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      communityId: data.communityId.present
          ? data.communityId.value
          : this.communityId,
      sectorId: data.sectorId.present ? data.sectorId.value : this.sectorId,
      connectionType: data.connectionType.present
          ? data.connectionType.value
          : this.connectionType,
      tariff: data.tariff.present ? data.tariff.value : this.tariff,
      meterNumber: data.meterNumber.present
          ? data.meterNumber.value
          : this.meterNumber,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      lastReadingValue: data.lastReadingValue.present
          ? data.lastReadingValue.value
          : this.lastReadingValue,
      initialReading: data.initialReading.present
          ? data.initialReading.value
          : this.initialReading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('communityId: $communityId, ')
          ..write('sectorId: $sectorId, ')
          ..write('connectionType: $connectionType, ')
          ..write('tariff: $tariff, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('lastReadingValue: $lastReadingValue, ')
          ..write('initialReading: $initialReading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    communityId,
    sectorId,
    connectionType,
    tariff,
    meterNumber,
    latitude,
    longitude,
    lastReadingValue,
    initialReading,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.communityId == this.communityId &&
          other.sectorId == this.sectorId &&
          other.connectionType == this.connectionType &&
          other.tariff == this.tariff &&
          other.meterNumber == this.meterNumber &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.lastReadingValue == this.lastReadingValue &&
          other.initialReading == this.initialReading);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> communityId;
  final Value<String> sectorId;
  final Value<int> connectionType;
  final Value<double> tariff;
  final Value<String> meterNumber;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> lastReadingValue;
  final Value<double> initialReading;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.communityId = const Value.absent(),
    this.sectorId = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.tariff = const Value.absent(),
    this.meterNumber = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.lastReadingValue = const Value.absent(),
    this.initialReading = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String communityId,
    required String sectorId,
    required int connectionType,
    required double tariff,
    required String meterNumber,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.lastReadingValue = const Value.absent(),
    this.initialReading = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       communityId = Value(communityId),
       sectorId = Value(sectorId),
       connectionType = Value(connectionType),
       tariff = Value(tariff),
       meterNumber = Value(meterNumber);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? communityId,
    Expression<String>? sectorId,
    Expression<int>? connectionType,
    Expression<double>? tariff,
    Expression<String>? meterNumber,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? lastReadingValue,
    Expression<double>? initialReading,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (communityId != null) 'community_id': communityId,
      if (sectorId != null) 'sector_id': sectorId,
      if (connectionType != null) 'connection_type': connectionType,
      if (tariff != null) 'tariff': tariff,
      if (meterNumber != null) 'meter_number': meterNumber,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (lastReadingValue != null) 'last_reading_value': lastReadingValue,
      if (initialReading != null) 'initial_reading': initialReading,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? communityId,
    Value<String>? sectorId,
    Value<int>? connectionType,
    Value<double>? tariff,
    Value<String>? meterNumber,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? lastReadingValue,
    Value<double>? initialReading,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      communityId: communityId ?? this.communityId,
      sectorId: sectorId ?? this.sectorId,
      connectionType: connectionType ?? this.connectionType,
      tariff: tariff ?? this.tariff,
      meterNumber: meterNumber ?? this.meterNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastReadingValue: lastReadingValue ?? this.lastReadingValue,
      initialReading: initialReading ?? this.initialReading,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (sectorId.present) {
      map['sector_id'] = Variable<String>(sectorId.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<int>(connectionType.value);
    }
    if (tariff.present) {
      map['tariff'] = Variable<double>(tariff.value);
    }
    if (meterNumber.present) {
      map['meter_number'] = Variable<String>(meterNumber.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (lastReadingValue.present) {
      map['last_reading_value'] = Variable<double>(lastReadingValue.value);
    }
    if (initialReading.present) {
      map['initial_reading'] = Variable<double>(initialReading.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('communityId: $communityId, ')
          ..write('sectorId: $sectorId, ')
          ..write('connectionType: $connectionType, ')
          ..write('tariff: $tariff, ')
          ..write('meterNumber: $meterNumber, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('lastReadingValue: $lastReadingValue, ')
          ..write('initialReading: $initialReading, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _previousValueMeta = const VerificationMeta(
    'previousValue',
  );
  @override
  late final GeneratedColumn<double> previousValue = GeneratedColumn<double>(
    'previous_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumptionKwhMeta = const VerificationMeta(
    'consumptionKwh',
  );
  @override
  late final GeneratedColumn<double> consumptionKwh = GeneratedColumn<double>(
    'consumption_kwh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoFijoMeta = const VerificationMeta(
    'cargoFijo',
  );
  @override
  late final GeneratedColumn<double> cargoFijo = GeneratedColumn<double>(
    'cargo_fijo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alumbradoPublicoMeta = const VerificationMeta(
    'alumbradoPublico',
  );
  @override
  late final GeneratedColumn<double> alumbradoPublico = GeneratedColumn<double>(
    'alumbrado_publico',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoRedondeoMeta = const VerificationMeta(
    'saldoRedondeo',
  );
  @override
  late final GeneratedColumn<double> saldoRedondeo = GeneratedColumn<double>(
    'saldo_redondeo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalToPayMeta = const VerificationMeta(
    'totalToPay',
  );
  @override
  late final GeneratedColumn<double> totalToPay = GeneratedColumn<double>(
    'total_to_pay',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    period,
    previousValue,
    currentValue,
    consumptionKwh,
    photoUrl,
    timestamp,
    latitude,
    longitude,
    cargoFijo,
    alumbradoPublico,
    saldoRedondeo,
    totalToPay,
    isSynced,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('previous_value')) {
      context.handle(
        _previousValueMeta,
        previousValue.isAcceptableOrUnknown(
          data['previous_value']!,
          _previousValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('consumption_kwh')) {
      context.handle(
        _consumptionKwhMeta,
        consumptionKwh.isAcceptableOrUnknown(
          data['consumption_kwh']!,
          _consumptionKwhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consumptionKwhMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('cargo_fijo')) {
      context.handle(
        _cargoFijoMeta,
        cargoFijo.isAcceptableOrUnknown(data['cargo_fijo']!, _cargoFijoMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoFijoMeta);
    }
    if (data.containsKey('alumbrado_publico')) {
      context.handle(
        _alumbradoPublicoMeta,
        alumbradoPublico.isAcceptableOrUnknown(
          data['alumbrado_publico']!,
          _alumbradoPublicoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_alumbradoPublicoMeta);
    }
    if (data.containsKey('saldo_redondeo')) {
      context.handle(
        _saldoRedondeoMeta,
        saldoRedondeo.isAcceptableOrUnknown(
          data['saldo_redondeo']!,
          _saldoRedondeoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoRedondeoMeta);
    }
    if (data.containsKey('total_to_pay')) {
      context.handle(
        _totalToPayMeta,
        totalToPay.isAcceptableOrUnknown(
          data['total_to_pay']!,
          _totalToPayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalToPayMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      previousValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_value'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      consumptionKwh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consumption_kwh'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      cargoFijo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cargo_fijo'],
      )!,
      alumbradoPublico: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alumbrado_publico'],
      )!,
      saldoRedondeo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_redondeo'],
      )!,
      totalToPay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_to_pay'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }
}

class Reading extends DataClass implements Insertable<Reading> {
  final String id;
  final String customerId;
  final String period;
  final double previousValue;
  final double currentValue;
  final double consumptionKwh;
  final String? photoUrl;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double cargoFijo;
  final double alumbradoPublico;
  final double saldoRedondeo;
  final double totalToPay;
  final bool isSynced;
  final String? comment;
  const Reading({
    required this.id,
    required this.customerId,
    required this.period,
    required this.previousValue,
    required this.currentValue,
    required this.consumptionKwh,
    this.photoUrl,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.cargoFijo,
    required this.alumbradoPublico,
    required this.saldoRedondeo,
    required this.totalToPay,
    required this.isSynced,
    this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['period'] = Variable<String>(period);
    map['previous_value'] = Variable<double>(previousValue);
    map['current_value'] = Variable<double>(currentValue);
    map['consumption_kwh'] = Variable<double>(consumptionKwh);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['cargo_fijo'] = Variable<double>(cargoFijo);
    map['alumbrado_publico'] = Variable<double>(alumbradoPublico);
    map['saldo_redondeo'] = Variable<double>(saldoRedondeo);
    map['total_to_pay'] = Variable<double>(totalToPay);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      period: Value(period),
      previousValue: Value(previousValue),
      currentValue: Value(currentValue),
      consumptionKwh: Value(consumptionKwh),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      timestamp: Value(timestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      cargoFijo: Value(cargoFijo),
      alumbradoPublico: Value(alumbradoPublico),
      saldoRedondeo: Value(saldoRedondeo),
      totalToPay: Value(totalToPay),
      isSynced: Value(isSynced),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      period: serializer.fromJson<String>(json['period']),
      previousValue: serializer.fromJson<double>(json['previousValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      consumptionKwh: serializer.fromJson<double>(json['consumptionKwh']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      cargoFijo: serializer.fromJson<double>(json['cargoFijo']),
      alumbradoPublico: serializer.fromJson<double>(json['alumbradoPublico']),
      saldoRedondeo: serializer.fromJson<double>(json['saldoRedondeo']),
      totalToPay: serializer.fromJson<double>(json['totalToPay']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'period': serializer.toJson<String>(period),
      'previousValue': serializer.toJson<double>(previousValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'consumptionKwh': serializer.toJson<double>(consumptionKwh),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'cargoFijo': serializer.toJson<double>(cargoFijo),
      'alumbradoPublico': serializer.toJson<double>(alumbradoPublico),
      'saldoRedondeo': serializer.toJson<double>(saldoRedondeo),
      'totalToPay': serializer.toJson<double>(totalToPay),
      'isSynced': serializer.toJson<bool>(isSynced),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  Reading copyWith({
    String? id,
    String? customerId,
    String? period,
    double? previousValue,
    double? currentValue,
    double? consumptionKwh,
    Value<String?> photoUrl = const Value.absent(),
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? cargoFijo,
    double? alumbradoPublico,
    double? saldoRedondeo,
    double? totalToPay,
    bool? isSynced,
    Value<String?> comment = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    period: period ?? this.period,
    previousValue: previousValue ?? this.previousValue,
    currentValue: currentValue ?? this.currentValue,
    consumptionKwh: consumptionKwh ?? this.consumptionKwh,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    cargoFijo: cargoFijo ?? this.cargoFijo,
    alumbradoPublico: alumbradoPublico ?? this.alumbradoPublico,
    saldoRedondeo: saldoRedondeo ?? this.saldoRedondeo,
    totalToPay: totalToPay ?? this.totalToPay,
    isSynced: isSynced ?? this.isSynced,
    comment: comment.present ? comment.value : this.comment,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      period: data.period.present ? data.period.value : this.period,
      previousValue: data.previousValue.present
          ? data.previousValue.value
          : this.previousValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      consumptionKwh: data.consumptionKwh.present
          ? data.consumptionKwh.value
          : this.consumptionKwh,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      cargoFijo: data.cargoFijo.present ? data.cargoFijo.value : this.cargoFijo,
      alumbradoPublico: data.alumbradoPublico.present
          ? data.alumbradoPublico.value
          : this.alumbradoPublico,
      saldoRedondeo: data.saldoRedondeo.present
          ? data.saldoRedondeo.value
          : this.saldoRedondeo,
      totalToPay: data.totalToPay.present
          ? data.totalToPay.value
          : this.totalToPay,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('period: $period, ')
          ..write('previousValue: $previousValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('consumptionKwh: $consumptionKwh, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('cargoFijo: $cargoFijo, ')
          ..write('alumbradoPublico: $alumbradoPublico, ')
          ..write('saldoRedondeo: $saldoRedondeo, ')
          ..write('totalToPay: $totalToPay, ')
          ..write('isSynced: $isSynced, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    period,
    previousValue,
    currentValue,
    consumptionKwh,
    photoUrl,
    timestamp,
    latitude,
    longitude,
    cargoFijo,
    alumbradoPublico,
    saldoRedondeo,
    totalToPay,
    isSynced,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.period == this.period &&
          other.previousValue == this.previousValue &&
          other.currentValue == this.currentValue &&
          other.consumptionKwh == this.consumptionKwh &&
          other.photoUrl == this.photoUrl &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.cargoFijo == this.cargoFijo &&
          other.alumbradoPublico == this.alumbradoPublico &&
          other.saldoRedondeo == this.saldoRedondeo &&
          other.totalToPay == this.totalToPay &&
          other.isSynced == this.isSynced &&
          other.comment == this.comment);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> period;
  final Value<double> previousValue;
  final Value<double> currentValue;
  final Value<double> consumptionKwh;
  final Value<String?> photoUrl;
  final Value<DateTime> timestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> cargoFijo;
  final Value<double> alumbradoPublico;
  final Value<double> saldoRedondeo;
  final Value<double> totalToPay;
  final Value<bool> isSynced;
  final Value<String?> comment;
  final Value<int> rowid;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.period = const Value.absent(),
    this.previousValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.consumptionKwh = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.cargoFijo = const Value.absent(),
    this.alumbradoPublico = const Value.absent(),
    this.saldoRedondeo = const Value.absent(),
    this.totalToPay = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingsCompanion.insert({
    required String id,
    required String customerId,
    this.period = const Value.absent(),
    required double previousValue,
    required double currentValue,
    required double consumptionKwh,
    this.photoUrl = const Value.absent(),
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double cargoFijo,
    required double alumbradoPublico,
    required double saldoRedondeo,
    required double totalToPay,
    this.isSynced = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       previousValue = Value(previousValue),
       currentValue = Value(currentValue),
       consumptionKwh = Value(consumptionKwh),
       timestamp = Value(timestamp),
       latitude = Value(latitude),
       longitude = Value(longitude),
       cargoFijo = Value(cargoFijo),
       alumbradoPublico = Value(alumbradoPublico),
       saldoRedondeo = Value(saldoRedondeo),
       totalToPay = Value(totalToPay);
  static Insertable<Reading> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? period,
    Expression<double>? previousValue,
    Expression<double>? currentValue,
    Expression<double>? consumptionKwh,
    Expression<String>? photoUrl,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? cargoFijo,
    Expression<double>? alumbradoPublico,
    Expression<double>? saldoRedondeo,
    Expression<double>? totalToPay,
    Expression<bool>? isSynced,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (period != null) 'period': period,
      if (previousValue != null) 'previous_value': previousValue,
      if (currentValue != null) 'current_value': currentValue,
      if (consumptionKwh != null) 'consumption_kwh': consumptionKwh,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (cargoFijo != null) 'cargo_fijo': cargoFijo,
      if (alumbradoPublico != null) 'alumbrado_publico': alumbradoPublico,
      if (saldoRedondeo != null) 'saldo_redondeo': saldoRedondeo,
      if (totalToPay != null) 'total_to_pay': totalToPay,
      if (isSynced != null) 'is_synced': isSynced,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? period,
    Value<double>? previousValue,
    Value<double>? currentValue,
    Value<double>? consumptionKwh,
    Value<String?>? photoUrl,
    Value<DateTime>? timestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? cargoFijo,
    Value<double>? alumbradoPublico,
    Value<double>? saldoRedondeo,
    Value<double>? totalToPay,
    Value<bool>? isSynced,
    Value<String?>? comment,
    Value<int>? rowid,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      period: period ?? this.period,
      previousValue: previousValue ?? this.previousValue,
      currentValue: currentValue ?? this.currentValue,
      consumptionKwh: consumptionKwh ?? this.consumptionKwh,
      photoUrl: photoUrl ?? this.photoUrl,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cargoFijo: cargoFijo ?? this.cargoFijo,
      alumbradoPublico: alumbradoPublico ?? this.alumbradoPublico,
      saldoRedondeo: saldoRedondeo ?? this.saldoRedondeo,
      totalToPay: totalToPay ?? this.totalToPay,
      isSynced: isSynced ?? this.isSynced,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (previousValue.present) {
      map['previous_value'] = Variable<double>(previousValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (consumptionKwh.present) {
      map['consumption_kwh'] = Variable<double>(consumptionKwh.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (cargoFijo.present) {
      map['cargo_fijo'] = Variable<double>(cargoFijo.value);
    }
    if (alumbradoPublico.present) {
      map['alumbrado_publico'] = Variable<double>(alumbradoPublico.value);
    }
    if (saldoRedondeo.present) {
      map['saldo_redondeo'] = Variable<double>(saldoRedondeo.value);
    }
    if (totalToPay.present) {
      map['total_to_pay'] = Variable<double>(totalToPay.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('period: $period, ')
          ..write('previousValue: $previousValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('consumptionKwh: $consumptionKwh, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('cargoFijo: $cargoFijo, ')
          ..write('alumbradoPublico: $alumbradoPublico, ')
          ..write('saldoRedondeo: $saldoRedondeo, ')
          ..write('totalToPay: $totalToPay, ')
          ..write('isSynced: $isSynced, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CommunitiesTable communities = $CommunitiesTable(this);
  late final $SectorsTable sectors = $SectorsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    communities,
    sectors,
    customers,
    readings,
    settings,
  ];
}

typedef $$CommunitiesTableCreateCompanionBuilder =
    CommunitiesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$CommunitiesTableUpdateCompanionBuilder =
    CommunitiesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$CommunitiesTableReferences
    extends BaseReferences<_$AppDatabase, $CommunitiesTable, Community> {
  $$CommunitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SectorsTable, List<Sector>> _sectorsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sectors,
    aliasName: $_aliasNameGenerator(db.communities.id, db.sectors.communityId),
  );

  $$SectorsTableProcessedTableManager get sectorsRefs {
    final manager = $$SectorsTableTableManager(
      $_db,
      $_db.sectors,
    ).filter((f) => f.communityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sectorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: $_aliasNameGenerator(
      db.communities.id,
      db.customers.communityId,
    ),
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.communityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CommunitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CommunitiesTable> {
  $$CommunitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sectorsRefs(
    Expression<bool> Function($$SectorsTableFilterComposer f) f,
  ) {
    final $$SectorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectors,
      getReferencedColumn: (t) => t.communityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectorsTableFilterComposer(
            $db: $db,
            $table: $db.sectors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.communityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CommunitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CommunitiesTable> {
  $$CommunitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommunitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommunitiesTable> {
  $$CommunitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> sectorsRefs<T extends Object>(
    Expression<T> Function($$SectorsTableAnnotationComposer a) f,
  ) {
    final $$SectorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectors,
      getReferencedColumn: (t) => t.communityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectorsTableAnnotationComposer(
            $db: $db,
            $table: $db.sectors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.communityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CommunitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommunitiesTable,
          Community,
          $$CommunitiesTableFilterComposer,
          $$CommunitiesTableOrderingComposer,
          $$CommunitiesTableAnnotationComposer,
          $$CommunitiesTableCreateCompanionBuilder,
          $$CommunitiesTableUpdateCompanionBuilder,
          (Community, $$CommunitiesTableReferences),
          Community,
          PrefetchHooks Function({bool sectorsRefs, bool customersRefs})
        > {
  $$CommunitiesTableTableManager(_$AppDatabase db, $CommunitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommunitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommunitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommunitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommunitiesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) =>
                  CommunitiesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CommunitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sectorsRefs = false, customersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sectorsRefs) db.sectors,
                    if (customersRefs) db.customers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sectorsRefs)
                        await $_getPrefetchedData<
                          Community,
                          $CommunitiesTable,
                          Sector
                        >(
                          currentTable: table,
                          referencedTable: $$CommunitiesTableReferences
                              ._sectorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CommunitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).sectorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.communityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customersRefs)
                        await $_getPrefetchedData<
                          Community,
                          $CommunitiesTable,
                          Customer
                        >(
                          currentTable: table,
                          referencedTable: $$CommunitiesTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CommunitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.communityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CommunitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommunitiesTable,
      Community,
      $$CommunitiesTableFilterComposer,
      $$CommunitiesTableOrderingComposer,
      $$CommunitiesTableAnnotationComposer,
      $$CommunitiesTableCreateCompanionBuilder,
      $$CommunitiesTableUpdateCompanionBuilder,
      (Community, $$CommunitiesTableReferences),
      Community,
      PrefetchHooks Function({bool sectorsRefs, bool customersRefs})
    >;
typedef $$SectorsTableCreateCompanionBuilder =
    SectorsCompanion Function({
      required String id,
      required String communityId,
      required String name,
      Value<int> rowid,
    });
typedef $$SectorsTableUpdateCompanionBuilder =
    SectorsCompanion Function({
      Value<String> id,
      Value<String> communityId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$SectorsTableReferences
    extends BaseReferences<_$AppDatabase, $SectorsTable, Sector> {
  $$SectorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CommunitiesTable _communityIdTable(_$AppDatabase db) =>
      db.communities.createAlias(
        $_aliasNameGenerator(db.sectors.communityId, db.communities.id),
      );

  $$CommunitiesTableProcessedTableManager get communityId {
    final $_column = $_itemColumn<String>('community_id')!;

    final manager = $$CommunitiesTableTableManager(
      $_db,
      $_db.communities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_communityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: $_aliasNameGenerator(db.sectors.id, db.customers.sectorId),
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.sectorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SectorsTableFilterComposer
    extends Composer<_$AppDatabase, $SectorsTable> {
  $$SectorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$CommunitiesTableFilterComposer get communityId {
    final $$CommunitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableFilterComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.sectorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectorsTable> {
  $$SectorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$CommunitiesTableOrderingComposer get communityId {
    final $$CommunitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableOrderingComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectorsTable> {
  $$SectorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$CommunitiesTableAnnotationComposer get communityId {
    final $$CommunitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.sectorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectorsTable,
          Sector,
          $$SectorsTableFilterComposer,
          $$SectorsTableOrderingComposer,
          $$SectorsTableAnnotationComposer,
          $$SectorsTableCreateCompanionBuilder,
          $$SectorsTableUpdateCompanionBuilder,
          (Sector, $$SectorsTableReferences),
          Sector,
          PrefetchHooks Function({bool communityId, bool customersRefs})
        > {
  $$SectorsTableTableManager(_$AppDatabase db, $SectorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> communityId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectorsCompanion(
                id: id,
                communityId: communityId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String communityId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => SectorsCompanion.insert(
                id: id,
                communityId: communityId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SectorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({communityId = false, customersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (customersRefs) db.customers],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (communityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.communityId,
                                    referencedTable: $$SectorsTableReferences
                                        ._communityIdTable(db),
                                    referencedColumn: $$SectorsTableReferences
                                        ._communityIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customersRefs)
                        await $_getPrefetchedData<
                          Sector,
                          $SectorsTable,
                          Customer
                        >(
                          currentTable: table,
                          referencedTable: $$SectorsTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SectorsTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sectorId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SectorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectorsTable,
      Sector,
      $$SectorsTableFilterComposer,
      $$SectorsTableOrderingComposer,
      $$SectorsTableAnnotationComposer,
      $$SectorsTableCreateCompanionBuilder,
      $$SectorsTableUpdateCompanionBuilder,
      (Sector, $$SectorsTableReferences),
      Sector,
      PrefetchHooks Function({bool communityId, bool customersRefs})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String code,
      required String name,
      required String communityId,
      required String sectorId,
      required int connectionType,
      required double tariff,
      required String meterNumber,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> lastReadingValue,
      Value<double> initialReading,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> communityId,
      Value<String> sectorId,
      Value<int> connectionType,
      Value<double> tariff,
      Value<String> meterNumber,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> lastReadingValue,
      Value<double> initialReading,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CommunitiesTable _communityIdTable(_$AppDatabase db) =>
      db.communities.createAlias(
        $_aliasNameGenerator(db.customers.communityId, db.communities.id),
      );

  $$CommunitiesTableProcessedTableManager get communityId {
    final $_column = $_itemColumn<String>('community_id')!;

    final manager = $$CommunitiesTableTableManager(
      $_db,
      $_db.communities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_communityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SectorsTable _sectorIdTable(_$AppDatabase db) => db.sectors
      .createAlias($_aliasNameGenerator(db.customers.sectorId, db.sectors.id));

  $$SectorsTableProcessedTableManager get sectorId {
    final $_column = $_itemColumn<String>('sector_id')!;

    final manager = $$SectorsTableTableManager(
      $_db,
      $_db.sectors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: $_aliasNameGenerator(db.customers.id, db.readings.customerId),
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tariff => $composableBuilder(
    column: $table.tariff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastReadingValue => $composableBuilder(
    column: $table.lastReadingValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialReading => $composableBuilder(
    column: $table.initialReading,
    builder: (column) => ColumnFilters(column),
  );

  $$CommunitiesTableFilterComposer get communityId {
    final $$CommunitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableFilterComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectorsTableFilterComposer get sectorId {
    final $$SectorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectorId,
      referencedTable: $db.sectors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectorsTableFilterComposer(
            $db: $db,
            $table: $db.sectors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tariff => $composableBuilder(
    column: $table.tariff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastReadingValue => $composableBuilder(
    column: $table.lastReadingValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialReading => $composableBuilder(
    column: $table.initialReading,
    builder: (column) => ColumnOrderings(column),
  );

  $$CommunitiesTableOrderingComposer get communityId {
    final $$CommunitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableOrderingComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectorsTableOrderingComposer get sectorId {
    final $$SectorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectorId,
      referencedTable: $db.sectors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectorsTableOrderingComposer(
            $db: $db,
            $table: $db.sectors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tariff =>
      $composableBuilder(column: $table.tariff, builder: (column) => column);

  GeneratedColumn<String> get meterNumber => $composableBuilder(
    column: $table.meterNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get lastReadingValue => $composableBuilder(
    column: $table.lastReadingValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialReading => $composableBuilder(
    column: $table.initialReading,
    builder: (column) => column,
  );

  $$CommunitiesTableAnnotationComposer get communityId {
    final $$CommunitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.communityId,
      referencedTable: $db.communities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommunitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.communities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectorsTableAnnotationComposer get sectorId {
    final $$SectorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectorId,
      referencedTable: $db.sectors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectorsTableAnnotationComposer(
            $db: $db,
            $table: $db.sectors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool communityId,
            bool sectorId,
            bool readingsRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> communityId = const Value.absent(),
                Value<String> sectorId = const Value.absent(),
                Value<int> connectionType = const Value.absent(),
                Value<double> tariff = const Value.absent(),
                Value<String> meterNumber = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> lastReadingValue = const Value.absent(),
                Value<double> initialReading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                code: code,
                name: name,
                communityId: communityId,
                sectorId: sectorId,
                connectionType: connectionType,
                tariff: tariff,
                meterNumber: meterNumber,
                latitude: latitude,
                longitude: longitude,
                lastReadingValue: lastReadingValue,
                initialReading: initialReading,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String communityId,
                required String sectorId,
                required int connectionType,
                required double tariff,
                required String meterNumber,
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> lastReadingValue = const Value.absent(),
                Value<double> initialReading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                code: code,
                name: name,
                communityId: communityId,
                sectorId: sectorId,
                connectionType: connectionType,
                tariff: tariff,
                meterNumber: meterNumber,
                latitude: latitude,
                longitude: longitude,
                lastReadingValue: lastReadingValue,
                initialReading: initialReading,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({communityId = false, sectorId = false, readingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (readingsRefs) db.readings],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (communityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.communityId,
                                    referencedTable: $$CustomersTableReferences
                                        ._communityIdTable(db),
                                    referencedColumn: $$CustomersTableReferences
                                        ._communityIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (sectorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sectorId,
                                    referencedTable: $$CustomersTableReferences
                                        ._sectorIdTable(db),
                                    referencedColumn: $$CustomersTableReferences
                                        ._sectorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Reading
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({
        bool communityId,
        bool sectorId,
        bool readingsRefs,
      })
    >;
typedef $$ReadingsTableCreateCompanionBuilder =
    ReadingsCompanion Function({
      required String id,
      required String customerId,
      Value<String> period,
      required double previousValue,
      required double currentValue,
      required double consumptionKwh,
      Value<String?> photoUrl,
      required DateTime timestamp,
      required double latitude,
      required double longitude,
      required double cargoFijo,
      required double alumbradoPublico,
      required double saldoRedondeo,
      required double totalToPay,
      Value<bool> isSynced,
      Value<String?> comment,
      Value<int> rowid,
    });
typedef $$ReadingsTableUpdateCompanionBuilder =
    ReadingsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> period,
      Value<double> previousValue,
      Value<double> currentValue,
      Value<double> consumptionKwh,
      Value<String?> photoUrl,
      Value<DateTime> timestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> cargoFijo,
      Value<double> alumbradoPublico,
      Value<double> saldoRedondeo,
      Value<double> totalToPay,
      Value<bool> isSynced,
      Value<String?> comment,
      Value<int> rowid,
    });

final class $$ReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingsTable, Reading> {
  $$ReadingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(db.readings.customerId, db.customers.id),
      );

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consumptionKwh => $composableBuilder(
    column: $table.consumptionKwh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cargoFijo => $composableBuilder(
    column: $table.cargoFijo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alumbradoPublico => $composableBuilder(
    column: $table.alumbradoPublico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoRedondeo => $composableBuilder(
    column: $table.saldoRedondeo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalToPay => $composableBuilder(
    column: $table.totalToPay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consumptionKwh => $composableBuilder(
    column: $table.consumptionKwh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cargoFijo => $composableBuilder(
    column: $table.cargoFijo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alumbradoPublico => $composableBuilder(
    column: $table.alumbradoPublico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoRedondeo => $composableBuilder(
    column: $table.saldoRedondeo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalToPay => $composableBuilder(
    column: $table.totalToPay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consumptionKwh => $composableBuilder(
    column: $table.consumptionKwh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get cargoFijo =>
      $composableBuilder(column: $table.cargoFijo, builder: (column) => column);

  GeneratedColumn<double> get alumbradoPublico => $composableBuilder(
    column: $table.alumbradoPublico,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoRedondeo => $composableBuilder(
    column: $table.saldoRedondeo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalToPay => $composableBuilder(
    column: $table.totalToPay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, $$ReadingsTableReferences),
          Reading,
          PrefetchHooks Function({bool customerId})
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<double> previousValue = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<double> consumptionKwh = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> cargoFijo = const Value.absent(),
                Value<double> alumbradoPublico = const Value.absent(),
                Value<double> saldoRedondeo = const Value.absent(),
                Value<double> totalToPay = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                customerId: customerId,
                period: period,
                previousValue: previousValue,
                currentValue: currentValue,
                consumptionKwh: consumptionKwh,
                photoUrl: photoUrl,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                cargoFijo: cargoFijo,
                alumbradoPublico: alumbradoPublico,
                saldoRedondeo: saldoRedondeo,
                totalToPay: totalToPay,
                isSynced: isSynced,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                Value<String> period = const Value.absent(),
                required double previousValue,
                required double currentValue,
                required double consumptionKwh,
                Value<String?> photoUrl = const Value.absent(),
                required DateTime timestamp,
                required double latitude,
                required double longitude,
                required double cargoFijo,
                required double alumbradoPublico,
                required double saldoRedondeo,
                required double totalToPay,
                Value<bool> isSynced = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                customerId: customerId,
                period: period,
                previousValue: previousValue,
                currentValue: currentValue,
                consumptionKwh: consumptionKwh,
                photoUrl: photoUrl,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                cargoFijo: cargoFijo,
                alumbradoPublico: alumbradoPublico,
                saldoRedondeo: saldoRedondeo,
                totalToPay: totalToPay,
                isSynced: isSynced,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (customerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.customerId,
                                referencedTable: $$ReadingsTableReferences
                                    ._customerIdTable(db),
                                referencedColumn: $$ReadingsTableReferences
                                    ._customerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, $$ReadingsTableReferences),
      Reading,
      PrefetchHooks Function({bool customerId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CommunitiesTableTableManager get communities =>
      $$CommunitiesTableTableManager(_db, _db.communities);
  $$SectorsTableTableManager get sectors =>
      $$SectorsTableTableManager(_db, _db.sectors);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
