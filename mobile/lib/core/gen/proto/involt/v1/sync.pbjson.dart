// This is a generated file - do not edit.
//
// Generated from involt/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'models.pbjson.dart' as $0;

@$core.Deprecated('Use pushReadingsRequestDescriptor instead')
const PushReadingsRequest$json = {
  '1': 'PushReadingsRequest',
  '2': [
    {
      '1': 'readings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.involt.v1.Reading',
      '10': 'readings'
    },
  ],
};

/// Descriptor for `PushReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushReadingsRequestDescriptor = $convert.base64Decode(
    'ChNQdXNoUmVhZGluZ3NSZXF1ZXN0Ei4KCHJlYWRpbmdzGAEgAygLMhIuaW52b2x0LnYxLlJlYW'
    'RpbmdSCHJlYWRpbmdz');

@$core.Deprecated('Use pushReadingsResponseDescriptor instead')
const PushReadingsResponse$json = {
  '1': 'PushReadingsResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'synced_count', '3': 2, '4': 1, '5': 5, '10': 'syncedCount'},
  ],
};

/// Descriptor for `PushReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushReadingsResponseDescriptor = $convert.base64Decode(
    'ChRQdXNoUmVhZGluZ3NSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEiEKDHN5bm'
    'NlZF9jb3VudBgCIAEoBVILc3luY2VkQ291bnQ=');

@$core.Deprecated('Use pullMetadataRequestDescriptor instead')
const PullMetadataRequest$json = {
  '1': 'PullMetadataRequest',
  '2': [
    {
      '1': 'last_sync_timestamp',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'lastSyncTimestamp'
    },
  ],
};

/// Descriptor for `PullMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMetadataRequestDescriptor = $convert.base64Decode(
    'ChNQdWxsTWV0YWRhdGFSZXF1ZXN0Ei4KE2xhc3Rfc3luY190aW1lc3RhbXAYASABKANSEWxhc3'
    'RTeW5jVGltZXN0YW1w');

@$core.Deprecated('Use pullMetadataResponseDescriptor instead')
const PullMetadataResponse$json = {
  '1': 'PullMetadataResponse',
  '2': [
    {
      '1': 'communities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.involt.v1.Community',
      '10': 'communities'
    },
    {
      '1': 'sectors',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.involt.v1.Sector',
      '10': 'sectors'
    },
    {
      '1': 'customers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.involt.v1.Customer',
      '10': 'customers'
    },
  ],
};

/// Descriptor for `PullMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMetadataResponseDescriptor = $convert.base64Decode(
    'ChRQdWxsTWV0YWRhdGFSZXNwb25zZRI2Cgtjb21tdW5pdGllcxgBIAMoCzIULmludm9sdC52MS'
    '5Db21tdW5pdHlSC2NvbW11bml0aWVzEisKB3NlY3RvcnMYAiADKAsyES5pbnZvbHQudjEuU2Vj'
    'dG9yUgdzZWN0b3JzEjEKCWN1c3RvbWVycxgDIAMoCzITLmludm9sdC52MS5DdXN0b21lclIJY3'
    'VzdG9tZXJz');

const $core.Map<$core.String, $core.dynamic> SyncServiceBase$json = {
  '1': 'SyncService',
  '2': [
    {
      '1': 'PushReadings',
      '2': '.involt.v1.PushReadingsRequest',
      '3': '.involt.v1.PushReadingsResponse'
    },
    {
      '1': 'PullMetadata',
      '2': '.involt.v1.PullMetadataRequest',
      '3': '.involt.v1.PullMetadataResponse'
    },
  ],
};

@$core.Deprecated('Use syncServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SyncServiceBase$messageJson = {
  '.involt.v1.PushReadingsRequest': PushReadingsRequest$json,
  '.involt.v1.Reading': $0.Reading$json,
  '.involt.v1.PushReadingsResponse': PushReadingsResponse$json,
  '.involt.v1.PullMetadataRequest': PullMetadataRequest$json,
  '.involt.v1.PullMetadataResponse': PullMetadataResponse$json,
  '.involt.v1.Community': $0.Community$json,
  '.involt.v1.Sector': $0.Sector$json,
  '.involt.v1.Customer': $0.Customer$json,
};

/// Descriptor for `SyncService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List syncServiceDescriptor = $convert.base64Decode(
    'CgtTeW5jU2VydmljZRJPCgxQdXNoUmVhZGluZ3MSHi5pbnZvbHQudjEuUHVzaFJlYWRpbmdzUm'
    'VxdWVzdBofLmludm9sdC52MS5QdXNoUmVhZGluZ3NSZXNwb25zZRJPCgxQdWxsTWV0YWRhdGES'
    'Hi5pbnZvbHQudjEuUHVsbE1ldGFkYXRhUmVxdWVzdBofLmludm9sdC52MS5QdWxsTWV0YWRhdG'
    'FSZXNwb25zZQ==');
