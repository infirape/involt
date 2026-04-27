//
//  Generated code. Do not modify.
//  source: involt/v1/models.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pbenum.dart';

export 'models.pbenum.dart';

/// Community represents a village or Caserio (e.g., Alto Chetilla, Cadena).
class Community extends $pb.GeneratedMessage {
  factory Community({
    $core.String? id,
    $core.String? name,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  Community._() : super();
  factory Community.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Community.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Community', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Community clone() => Community()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Community copyWith(void Function(Community) updates) => super.copyWith((message) => updates(message as Community)) as Community;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Community create() => Community._();
  Community createEmptyInstance() => create();
  static $pb.PbList<Community> createRepeated() => $pb.PbList<Community>();
  @$core.pragma('dart2js:noInline')
  static Community getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Community>(create);
  static Community? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

/// Sector represents a specific area within a community (e.g., Sector A, Tambillo Alto).
class Sector extends $pb.GeneratedMessage {
  factory Sector({
    $core.String? id,
    $core.String? communityId,
    $core.String? name,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  Sector._() : super();
  factory Sector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Sector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Sector', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'communityId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Sector clone() => Sector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Sector copyWith(void Function(Sector) updates) => super.copyWith((message) => updates(message as Sector)) as Sector;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sector create() => Sector._();
  Sector createEmptyInstance() => create();
  static $pb.PbList<Sector> createRepeated() => $pb.PbList<Sector>();
  @$core.pragma('dart2js:noInline')
  static Sector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sector>(create);
  static Sector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get communityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set communityId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCommunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunityId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);
}

/// Customer contains the master data for a water/electricity user.
class Customer extends $pb.GeneratedMessage {
  factory Customer({
    $core.String? id,
    $core.String? code,
    $core.String? name,
    $core.String? communityId,
    $core.String? sectorId,
    ConnectionType? connectionType,
    $core.double? tariff,
    $core.String? meterNumber,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? lastReadingValue,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (code != null) {
      $result.code = code;
    }
    if (name != null) {
      $result.name = name;
    }
    if (communityId != null) {
      $result.communityId = communityId;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (connectionType != null) {
      $result.connectionType = connectionType;
    }
    if (tariff != null) {
      $result.tariff = tariff;
    }
    if (meterNumber != null) {
      $result.meterNumber = meterNumber;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (lastReadingValue != null) {
      $result.lastReadingValue = lastReadingValue;
    }
    return $result;
  }
  Customer._() : super();
  factory Customer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Customer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Customer', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'communityId')
    ..aOS(5, _omitFieldNames ? '' : 'sectorId')
    ..e<ConnectionType>(6, _omitFieldNames ? '' : 'connectionType', $pb.PbFieldType.OE, defaultOrMaker: ConnectionType.CONNECTION_TYPE_UNSPECIFIED, valueOf: ConnectionType.valueOf, enumValues: ConnectionType.values)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'tariff', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'meterNumber')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'lastReadingValue', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Customer clone() => Customer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Customer copyWith(void Function(Customer) updates) => super.copyWith((message) => updates(message as Customer)) as Customer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Customer create() => Customer._();
  Customer createEmptyInstance() => create();
  static $pb.PbList<Customer> createRepeated() => $pb.PbList<Customer>();
  @$core.pragma('dart2js:noInline')
  static Customer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Customer>(create);
  static Customer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get communityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set communityId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCommunityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommunityId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sectorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sectorId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSectorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSectorId() => clearField(5);

  @$pb.TagNumber(6)
  ConnectionType get connectionType => $_getN(5);
  @$pb.TagNumber(6)
  set connectionType(ConnectionType v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConnectionType() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectionType() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get tariff => $_getN(6);
  @$pb.TagNumber(7)
  set tariff($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTariff() => $_has(6);
  @$pb.TagNumber(7)
  void clearTariff() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get meterNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set meterNumber($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMeterNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeterNumber() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get latitude => $_getN(8);
  @$pb.TagNumber(9)
  set latitude($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLatitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLatitude() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get longitude => $_getN(9);
  @$pb.TagNumber(10)
  set longitude($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasLongitude() => $_has(9);
  @$pb.TagNumber(10)
  void clearLongitude() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get lastReadingValue => $_getN(10);
  @$pb.TagNumber(11)
  set lastReadingValue($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasLastReadingValue() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastReadingValue() => clearField(11);
}

/// Reading represents a captured meter value at a point in time.
class Reading extends $pb.GeneratedMessage {
  factory Reading({
    $core.String? id,
    $core.String? customerId,
    $core.double? previousValue,
    $core.double? currentValue,
    $core.double? consumptionKwh,
    $core.String? photoUrl,
    $fixnum.Int64? timestamp,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? cargoFijo,
    $core.double? alumbradoPublico,
    $core.double? saldoRedondeo,
    $core.double? totalToPay,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (previousValue != null) {
      $result.previousValue = previousValue;
    }
    if (currentValue != null) {
      $result.currentValue = currentValue;
    }
    if (consumptionKwh != null) {
      $result.consumptionKwh = consumptionKwh;
    }
    if (photoUrl != null) {
      $result.photoUrl = photoUrl;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (cargoFijo != null) {
      $result.cargoFijo = cargoFijo;
    }
    if (alumbradoPublico != null) {
      $result.alumbradoPublico = alumbradoPublico;
    }
    if (saldoRedondeo != null) {
      $result.saldoRedondeo = saldoRedondeo;
    }
    if (totalToPay != null) {
      $result.totalToPay = totalToPay;
    }
    return $result;
  }
  Reading._() : super();
  factory Reading.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Reading.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Reading', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'customerId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'previousValue', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'currentValue', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'consumptionKwh', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'photoUrl')
    ..aInt64(7, _omitFieldNames ? '' : 'timestamp')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'cargoFijo', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'alumbradoPublico', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'saldoRedondeo', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'totalToPay', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Reading clone() => Reading()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Reading copyWith(void Function(Reading) updates) => super.copyWith((message) => updates(message as Reading)) as Reading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reading create() => Reading._();
  Reading createEmptyInstance() => create();
  static $pb.PbList<Reading> createRepeated() => $pb.PbList<Reading>();
  @$core.pragma('dart2js:noInline')
  static Reading getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reading>(create);
  static Reading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCustomerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerId() => clearField(2);

  /// Consumption data
  @$pb.TagNumber(3)
  $core.double get previousValue => $_getN(2);
  @$pb.TagNumber(3)
  set previousValue($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPreviousValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreviousValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get currentValue => $_getN(3);
  @$pb.TagNumber(4)
  set currentValue($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get consumptionKwh => $_getN(4);
  @$pb.TagNumber(5)
  set consumptionKwh($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConsumptionKwh() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsumptionKwh() => clearField(5);

  /// Metadata
  @$pb.TagNumber(6)
  $core.String get photoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set photoUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPhotoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhotoUrl() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestamp => $_getI64(6);
  @$pb.TagNumber(7)
  set timestamp($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get latitude => $_getN(7);
  @$pb.TagNumber(8)
  set latitude($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLatitude() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatitude() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get longitude => $_getN(8);
  @$pb.TagNumber(9)
  set longitude($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLongitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLongitude() => clearField(9);

  /// Financial data (captured for receipt generation consistency)
  @$pb.TagNumber(10)
  $core.double get cargoFijo => $_getN(9);
  @$pb.TagNumber(10)
  set cargoFijo($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCargoFijo() => $_has(9);
  @$pb.TagNumber(10)
  void clearCargoFijo() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get alumbradoPublico => $_getN(10);
  @$pb.TagNumber(11)
  set alumbradoPublico($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAlumbradoPublico() => $_has(10);
  @$pb.TagNumber(11)
  void clearAlumbradoPublico() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get saldoRedondeo => $_getN(11);
  @$pb.TagNumber(12)
  set saldoRedondeo($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSaldoRedondeo() => $_has(11);
  @$pb.TagNumber(12)
  void clearSaldoRedondeo() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get totalToPay => $_getN(12);
  @$pb.TagNumber(13)
  set totalToPay($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTotalToPay() => $_has(12);
  @$pb.TagNumber(13)
  void clearTotalToPay() => clearField(13);
}

/// AppConfig contains remote configuration for the mobile application.
class AppConfig extends $pb.GeneratedMessage {
  factory AppConfig({
    $core.String? mapUrlTemplate,
    $core.String? mapUserAgent,
  }) {
    final $result = create();
    if (mapUrlTemplate != null) {
      $result.mapUrlTemplate = mapUrlTemplate;
    }
    if (mapUserAgent != null) {
      $result.mapUserAgent = mapUserAgent;
    }
    return $result;
  }
  AppConfig._() : super();
  factory AppConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mapUrlTemplate')
    ..aOS(2, _omitFieldNames ? '' : 'mapUserAgent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppConfig clone() => AppConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppConfig copyWith(void Function(AppConfig) updates) => super.copyWith((message) => updates(message as AppConfig)) as AppConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppConfig create() => AppConfig._();
  AppConfig createEmptyInstance() => create();
  static $pb.PbList<AppConfig> createRepeated() => $pb.PbList<AppConfig>();
  @$core.pragma('dart2js:noInline')
  static AppConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppConfig>(create);
  static AppConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapUrlTemplate => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapUrlTemplate($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMapUrlTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapUrlTemplate() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mapUserAgent => $_getSZ(1);
  @$pb.TagNumber(2)
  set mapUserAgent($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMapUserAgent() => $_has(1);
  @$pb.TagNumber(2)
  void clearMapUserAgent() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
