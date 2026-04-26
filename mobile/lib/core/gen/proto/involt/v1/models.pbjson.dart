// This is a generated file - do not edit.
//
// Generated from involt/v1/models.proto.

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

@$core.Deprecated('Use connectionTypeDescriptor instead')
const ConnectionType$json = {
  '1': 'ConnectionType',
  '2': [
    {'1': 'CONNECTION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CONNECTION_TYPE_MONOFASICA', '2': 1},
    {'1': 'CONNECTION_TYPE_TRIFASICA', '2': 2},
  ],
};

/// Descriptor for `ConnectionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionTypeDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0aW9uVHlwZRIfChtDT05ORUNUSU9OX1RZUEVfVU5TUEVDSUZJRUQQABIeChpDT0'
    '5ORUNUSU9OX1RZUEVfTU9OT0ZBU0lDQRABEh0KGUNPTk5FQ1RJT05fVFlQRV9UUklGQVNJQ0EQ'
    'Ag==');

@$core.Deprecated('Use communityDescriptor instead')
const Community$json = {
  '1': 'Community',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Community`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityDescriptor = $convert.base64Decode(
    'CglDb21tdW5pdHkSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWU=');

@$core.Deprecated('Use sectorDescriptor instead')
const Sector$json = {
  '1': 'Sector',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'community_id', '3': 2, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Sector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectorDescriptor = $convert.base64Decode(
    'CgZTZWN0b3ISDgoCaWQYASABKAlSAmlkEiEKDGNvbW11bml0eV9pZBgCIAEoCVILY29tbXVuaX'
    'R5SWQSEgoEbmFtZRgDIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use customerDescriptor instead')
const Customer$json = {
  '1': 'Customer',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'community_id', '3': 4, '4': 1, '5': 9, '10': 'communityId'},
    {'1': 'sector_id', '3': 5, '4': 1, '5': 9, '10': 'sectorId'},
    {
      '1': 'connection_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.involt.v1.ConnectionType',
      '10': 'connectionType'
    },
    {'1': 'tariff', '3': 7, '4': 1, '5': 1, '10': 'tariff'},
    {'1': 'meter_number', '3': 8, '4': 1, '5': 9, '10': 'meterNumber'},
  ],
};

/// Descriptor for `Customer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List customerDescriptor = $convert.base64Decode(
    'CghDdXN0b21lchIOCgJpZBgBIAEoCVICaWQSEgoEY29kZRgCIAEoCVIEY29kZRISCgRuYW1lGA'
    'MgASgJUgRuYW1lEiEKDGNvbW11bml0eV9pZBgEIAEoCVILY29tbXVuaXR5SWQSGwoJc2VjdG9y'
    'X2lkGAUgASgJUghzZWN0b3JJZBJCCg9jb25uZWN0aW9uX3R5cGUYBiABKA4yGS5pbnZvbHQudj'
    'EuQ29ubmVjdGlvblR5cGVSDmNvbm5lY3Rpb25UeXBlEhYKBnRhcmlmZhgHIAEoAVIGdGFyaWZm'
    'EiEKDG1ldGVyX251bWJlchgIIAEoCVILbWV0ZXJOdW1iZXI=');

@$core.Deprecated('Use readingDescriptor instead')
const Reading$json = {
  '1': 'Reading',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'customer_id', '3': 2, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'previous_value', '3': 3, '4': 1, '5': 1, '10': 'previousValue'},
    {'1': 'current_value', '3': 4, '4': 1, '5': 1, '10': 'currentValue'},
    {'1': 'consumption_kwh', '3': 5, '4': 1, '5': 1, '10': 'consumptionKwh'},
    {'1': 'photo_url', '3': 6, '4': 1, '5': 9, '10': 'photoUrl'},
    {'1': 'timestamp', '3': 7, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'latitude', '3': 8, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 9, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'cargo_fijo', '3': 10, '4': 1, '5': 1, '10': 'cargoFijo'},
    {
      '1': 'alumbrado_publico',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'alumbradoPublico'
    },
    {'1': 'saldo_redondeo', '3': 12, '4': 1, '5': 1, '10': 'saldoRedondeo'},
    {'1': 'total_to_pay', '3': 13, '4': 1, '5': 1, '10': 'totalToPay'},
  ],
};

/// Descriptor for `Reading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readingDescriptor = $convert.base64Decode(
    'CgdSZWFkaW5nEg4KAmlkGAEgASgJUgJpZBIfCgtjdXN0b21lcl9pZBgCIAEoCVIKY3VzdG9tZX'
    'JJZBIlCg5wcmV2aW91c192YWx1ZRgDIAEoAVINcHJldmlvdXNWYWx1ZRIjCg1jdXJyZW50X3Zh'
    'bHVlGAQgASgBUgxjdXJyZW50VmFsdWUSJwoPY29uc3VtcHRpb25fa3doGAUgASgBUg5jb25zdW'
    '1wdGlvbkt3aBIbCglwaG90b191cmwYBiABKAlSCHBob3RvVXJsEhwKCXRpbWVzdGFtcBgHIAEo'
    'A1IJdGltZXN0YW1wEhoKCGxhdGl0dWRlGAggASgBUghsYXRpdHVkZRIcCglsb25naXR1ZGUYCS'
    'ABKAFSCWxvbmdpdHVkZRIdCgpjYXJnb19maWpvGAogASgBUgljYXJnb0Zpam8SKwoRYWx1bWJy'
    'YWRvX3B1YmxpY28YCyABKAFSEGFsdW1icmFkb1B1YmxpY28SJQoOc2FsZG9fcmVkb25kZW8YDC'
    'ABKAFSDXNhbGRvUmVkb25kZW8SIAoMdG90YWxfdG9fcGF5GA0gASgBUgp0b3RhbFRvUGF5');
