// This is a generated file - do not edit.
//
// Generated from involt/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class PushReadingsRequest extends $pb.GeneratedMessage {
  factory PushReadingsRequest({
    $core.Iterable<$0.Reading>? readings,
  }) {
    final result = create();
    if (readings != null) result.readings.addAll(readings);
    return result;
  }

  PushReadingsRequest._();

  factory PushReadingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushReadingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushReadingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..pPM<$0.Reading>(1, _omitFieldNames ? '' : 'readings',
        subBuilder: $0.Reading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushReadingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushReadingsRequest copyWith(void Function(PushReadingsRequest) updates) =>
      super.copyWith((message) => updates(message as PushReadingsRequest))
          as PushReadingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushReadingsRequest create() => PushReadingsRequest._();
  @$core.override
  PushReadingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushReadingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushReadingsRequest>(create);
  static PushReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.Reading> get readings => $_getList(0);
}

class PushReadingsResponse extends $pb.GeneratedMessage {
  factory PushReadingsResponse({
    $core.bool? success,
    $core.int? syncedCount,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (syncedCount != null) result.syncedCount = syncedCount;
    return result;
  }

  PushReadingsResponse._();

  factory PushReadingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushReadingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushReadingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'syncedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushReadingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushReadingsResponse copyWith(void Function(PushReadingsResponse) updates) =>
      super.copyWith((message) => updates(message as PushReadingsResponse))
          as PushReadingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushReadingsResponse create() => PushReadingsResponse._();
  @$core.override
  PushReadingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushReadingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushReadingsResponse>(create);
  static PushReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get syncedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set syncedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSyncedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncedCount() => $_clearField(2);
}

class PullMetadataRequest extends $pb.GeneratedMessage {
  factory PullMetadataRequest({
    $fixnum.Int64? lastSyncTimestamp,
  }) {
    final result = create();
    if (lastSyncTimestamp != null) result.lastSyncTimestamp = lastSyncTimestamp;
    return result;
  }

  PullMetadataRequest._();

  factory PullMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'lastSyncTimestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMetadataRequest copyWith(void Function(PullMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as PullMetadataRequest))
          as PullMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMetadataRequest create() => PullMetadataRequest._();
  @$core.override
  PullMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PullMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullMetadataRequest>(create);
  static PullMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lastSyncTimestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set lastSyncTimestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLastSyncTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearLastSyncTimestamp() => $_clearField(1);
}

class PullMetadataResponse extends $pb.GeneratedMessage {
  factory PullMetadataResponse({
    $core.Iterable<$0.Community>? communities,
    $core.Iterable<$0.Sector>? sectors,
    $core.Iterable<$0.Customer>? customers,
  }) {
    final result = create();
    if (communities != null) result.communities.addAll(communities);
    if (sectors != null) result.sectors.addAll(sectors);
    if (customers != null) result.customers.addAll(customers);
    return result;
  }

  PullMetadataResponse._();

  factory PullMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullMetadataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'),
      createEmptyInstance: create)
    ..pPM<$0.Community>(1, _omitFieldNames ? '' : 'communities',
        subBuilder: $0.Community.create)
    ..pPM<$0.Sector>(2, _omitFieldNames ? '' : 'sectors',
        subBuilder: $0.Sector.create)
    ..pPM<$0.Customer>(3, _omitFieldNames ? '' : 'customers',
        subBuilder: $0.Customer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMetadataResponse copyWith(void Function(PullMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as PullMetadataResponse))
          as PullMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMetadataResponse create() => PullMetadataResponse._();
  @$core.override
  PullMetadataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PullMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullMetadataResponse>(create);
  static PullMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.Community> get communities => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.Sector> get sectors => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$0.Customer> get customers => $_getList(2);
}

/// SyncService handles bidirectional data exchange between mobile and cloud.
class SyncServiceApi {
  final $pb.RpcClient _client;

  SyncServiceApi(this._client);

  /// PushReadings uploads multiple readings from the mobile device.
  $async.Future<PushReadingsResponse> pushReadings(
          $pb.ClientContext? ctx, PushReadingsRequest request) =>
      _client.invoke<PushReadingsResponse>(
          ctx, 'SyncService', 'PushReadings', request, PushReadingsResponse());

  /// PullMetadata retrieves the latest master data (Customers, Communities, Sectors).
  $async.Future<PullMetadataResponse> pullMetadata(
          $pb.ClientContext? ctx, PullMetadataRequest request) =>
      _client.invoke<PullMetadataResponse>(
          ctx, 'SyncService', 'PullMetadata', request, PullMetadataResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
