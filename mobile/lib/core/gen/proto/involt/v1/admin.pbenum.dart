//
//  Generated code. Do not modify.
//  source: involt/v1/admin.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_UNSPECIFIED = UserRole._(0, _omitEnumNames ? '' : 'USER_ROLE_UNSPECIFIED');
  static const UserRole USER_ROLE_ADMIN = UserRole._(1, _omitEnumNames ? '' : 'USER_ROLE_ADMIN');
  static const UserRole USER_ROLE_SUPERVISOR = UserRole._(2, _omitEnumNames ? '' : 'USER_ROLE_SUPERVISOR');
  static const UserRole USER_ROLE_READER = UserRole._(3, _omitEnumNames ? '' : 'USER_ROLE_READER');

  static const $core.List<UserRole> values = <UserRole> [
    USER_ROLE_UNSPECIFIED,
    USER_ROLE_ADMIN,
    USER_ROLE_SUPERVISOR,
    USER_ROLE_READER,
  ];

  static final $core.Map<$core.int, UserRole> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserRole? valueOf($core.int value) => _byValue[value];

  const UserRole._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
