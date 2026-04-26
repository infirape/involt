// This is a generated file - do not edit.
//
// Generated from involt/v1/models.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'models.pbenum.dart';

/// Community represents a village or Caserio (e.g., Alto Chetilla, Cadena).
class Community extends $pb.GeneratedMessage {
  factory Community({
    $core.String? id,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  Community._();

  factory Community.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Community.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Community',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Community clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Community copyWith(void Function(Community) updates) =>
      super.copyWith((message) => updates(message as Community)) as Community;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Community create() => Community._();
  @$core.override
  Community createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Community getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Community>(create);
  static Community? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

/// Sector represents a specific area within a community (e.g., Sector A, Tambillo Alto).
class Sector extends $pb.GeneratedMessage {
  factory Sector({
    $core.String? id,
    $core.String? communityId,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (communityId != null) result.communityId = communityId;
    if (name != null) result.name = name;
    return result;
  }

  Sector._();

  factory Sector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Sector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Sector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'communityId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sector copyWith(void Function(Sector) updates) =>
      super.copyWith((message) => updates(message as Sector)) as Sector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sector create() => Sector._();
  @$core.override
  Sector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Sector getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sector>(create);
  static Sector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get communityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set communityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
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
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (communityId != null) result.communityId = communityId;
    if (sectorId != null) result.sectorId = sectorId;
    if (connectionType != null) result.connectionType = connectionType;
    if (tariff != null) result.tariff = tariff;
    if (meterNumber != null) result.meterNumber = meterNumber;
    return result;
  }

  Customer._();

  factory Customer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Customer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Customer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'communityId')
    ..aOS(5, _omitFieldNames ? '' : 'sectorId')
    ..aE<ConnectionType>(6, _omitFieldNames ? '' : 'connectionType',
        enumValues: ConnectionType.values)
    ..aD(7, _omitFieldNames ? '' : 'tariff')
    ..aOS(8, _omitFieldNames ? '' : 'meterNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Customer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Customer copyWith(void Function(Customer) updates) =>
      super.copyWith((message) => updates(message as Customer)) as Customer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Customer create() => Customer._();
  @$core.override
  Customer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Customer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Customer>(create);
  static Customer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get communityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set communityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCommunityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommunityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sectorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sectorId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSectorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSectorId() => $_clearField(5);

  @$pb.TagNumber(6)
  ConnectionType get connectionType => $_getN(5);
  @$pb.TagNumber(6)
  set connectionType(ConnectionType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConnectionType() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectionType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get tariff => $_getN(6);
  @$pb.TagNumber(7)
  set tariff($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTariff() => $_has(6);
  @$pb.TagNumber(7)
  void clearTariff() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get meterNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set meterNumber($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMeterNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeterNumber() => $_clearField(8);
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
    final result = create();
    if (id != null) result.id = id;
    if (customerId != null) result.customerId = customerId;
    if (previousValue != null) result.previousValue = previousValue;
    if (currentValue != null) result.currentValue = currentValue;
    if (consumptionKwh != null) result.consumptionKwh = consumptionKwh;
    if (photoUrl != null) result.photoUrl = photoUrl;
    if (timestamp != null) result.timestamp = timestamp;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (cargoFijo != null) result.cargoFijo = cargoFijo;
    if (alumbradoPublico != null) result.alumbradoPublico = alumbradoPublico;
    if (saldoRedondeo != null) result.saldoRedondeo = saldoRedondeo;
    if (totalToPay != null) result.totalToPay = totalToPay;
    return result;
  }

  Reading._();

  factory Reading.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reading.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reading',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'customerId')
    ..aD(3, _omitFieldNames ? '' : 'previousValue')
    ..aD(4, _omitFieldNames ? '' : 'currentValue')
    ..aD(5, _omitFieldNames ? '' : 'consumptionKwh')
    ..aOS(6, _omitFieldNames ? '' : 'photoUrl')
    ..aInt64(7, _omitFieldNames ? '' : 'timestamp')
    ..aD(8, _omitFieldNames ? '' : 'latitude')
    ..aD(9, _omitFieldNames ? '' : 'longitude')
    ..aD(10, _omitFieldNames ? '' : 'cargoFijo')
    ..aD(11, _omitFieldNames ? '' : 'alumbradoPublico')
    ..aD(12, _omitFieldNames ? '' : 'saldoRedondeo')
    ..aD(13, _omitFieldNames ? '' : 'totalToPay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reading clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reading copyWith(void Function(Reading) updates) =>
      super.copyWith((message) => updates(message as Reading)) as Reading;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reading create() => Reading._();
  @$core.override
  Reading createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reading getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reading>(create);
  static Reading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerId() => $_clearField(2);

  /// Consumption data
  @$pb.TagNumber(3)
  $core.double get previousValue => $_getN(2);
  @$pb.TagNumber(3)
  set previousValue($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPreviousValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreviousValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get currentValue => $_getN(3);
  @$pb.TagNumber(4)
  set currentValue($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get consumptionKwh => $_getN(4);
  @$pb.TagNumber(5)
  set consumptionKwh($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsumptionKwh() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsumptionKwh() => $_clearField(5);

  /// Metadata
  @$pb.TagNumber(6)
  $core.String get photoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set photoUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPhotoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhotoUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestamp => $_getI64(6);
  @$pb.TagNumber(7)
  set timestamp($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get latitude => $_getN(7);
  @$pb.TagNumber(8)
  set latitude($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLatitude() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatitude() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get longitude => $_getN(8);
  @$pb.TagNumber(9)
  set longitude($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLongitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLongitude() => $_clearField(9);

  /// Financial data (captured for receipt generation consistency)
  @$pb.TagNumber(10)
  $core.double get cargoFijo => $_getN(9);
  @$pb.TagNumber(10)
  set cargoFijo($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCargoFijo() => $_has(9);
  @$pb.TagNumber(10)
  void clearCargoFijo() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get alumbradoPublico => $_getN(10);
  @$pb.TagNumber(11)
  set alumbradoPublico($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAlumbradoPublico() => $_has(10);
  @$pb.TagNumber(11)
  void clearAlumbradoPublico() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get saldoRedondeo => $_getN(11);
  @$pb.TagNumber(12)
  set saldoRedondeo($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSaldoRedondeo() => $_has(11);
  @$pb.TagNumber(12)
  void clearSaldoRedondeo() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get totalToPay => $_getN(12);
  @$pb.TagNumber(13)
  set totalToPay($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTotalToPay() => $_has(12);
  @$pb.TagNumber(13)
  void clearTotalToPay() => $_clearField(13);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
