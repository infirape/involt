//
//  Generated code. Do not modify.
//  source: involt/v1/admin.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pbenum.dart';
import 'models.pb.dart' as $0;

export 'admin.pbenum.dart';

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? email,
    $core.String? password,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? token,
    User? user,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  LoginResponse._() : super();
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOM<User>(2, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(User v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
  @$pb.TagNumber(2)
  User ensureUser() => $_ensure(1);
}

class GetUsersRequest extends $pb.GeneratedMessage {
  factory GetUsersRequest() => create();
  GetUsersRequest._() : super();
  factory GetUsersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUsersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUsersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUsersRequest clone() => GetUsersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUsersRequest copyWith(void Function(GetUsersRequest) updates) => super.copyWith((message) => updates(message as GetUsersRequest)) as GetUsersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsersRequest create() => GetUsersRequest._();
  GetUsersRequest createEmptyInstance() => create();
  static $pb.PbList<GetUsersRequest> createRepeated() => $pb.PbList<GetUsersRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUsersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsersRequest>(create);
  static GetUsersRequest? _defaultInstance;
}

class GetUsersResponse extends $pb.GeneratedMessage {
  factory GetUsersResponse({
    $core.Iterable<User>? users,
  }) {
    final $result = create();
    if (users != null) {
      $result.users.addAll(users);
    }
    return $result;
  }
  GetUsersResponse._() : super();
  factory GetUsersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUsersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUsersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<User>(1, _omitFieldNames ? '' : 'users', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUsersResponse clone() => GetUsersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUsersResponse copyWith(void Function(GetUsersResponse) updates) => super.copyWith((message) => updates(message as GetUsersResponse)) as GetUsersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUsersResponse create() => GetUsersResponse._();
  GetUsersResponse createEmptyInstance() => create();
  static $pb.PbList<GetUsersResponse> createRepeated() => $pb.PbList<GetUsersResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUsersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsersResponse>(create);
  static GetUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<User> get users => $_getList(0);
}

class UpsertUserRequest extends $pb.GeneratedMessage {
  factory UpsertUserRequest({
    User? user,
    $core.String? password,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  UpsertUserRequest._() : super();
  factory UpsertUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUserRequest clone() => UpsertUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUserRequest copyWith(void Function(UpsertUserRequest) updates) => super.copyWith((message) => updates(message as UpsertUserRequest)) as UpsertUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertUserRequest create() => UpsertUserRequest._();
  UpsertUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertUserRequest> createRepeated() => $pb.PbList<UpsertUserRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUserRequest>(create);
  static UpsertUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class UpsertUserResponse extends $pb.GeneratedMessage {
  factory UpsertUserResponse({
    User? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  UpsertUserResponse._() : super();
  factory UpsertUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertUserResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertUserResponse clone() => UpsertUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertUserResponse copyWith(void Function(UpsertUserResponse) updates) => super.copyWith((message) => updates(message as UpsertUserResponse)) as UpsertUserResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertUserResponse create() => UpsertUserResponse._();
  UpsertUserResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertUserResponse> createRepeated() => $pb.PbList<UpsertUserResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertUserResponse>(create);
  static UpsertUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class GetSectorsRequest extends $pb.GeneratedMessage {
  factory GetSectorsRequest() => create();
  GetSectorsRequest._() : super();
  factory GetSectorsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSectorsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSectorsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSectorsRequest clone() => GetSectorsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSectorsRequest copyWith(void Function(GetSectorsRequest) updates) => super.copyWith((message) => updates(message as GetSectorsRequest)) as GetSectorsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSectorsRequest create() => GetSectorsRequest._();
  GetSectorsRequest createEmptyInstance() => create();
  static $pb.PbList<GetSectorsRequest> createRepeated() => $pb.PbList<GetSectorsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSectorsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSectorsRequest>(create);
  static GetSectorsRequest? _defaultInstance;
}

class GetSectorsResponse extends $pb.GeneratedMessage {
  factory GetSectorsResponse({
    $core.Iterable<$0.Sector>? sectors,
  }) {
    final $result = create();
    if (sectors != null) {
      $result.sectors.addAll(sectors);
    }
    return $result;
  }
  GetSectorsResponse._() : super();
  factory GetSectorsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSectorsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSectorsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Sector>(1, _omitFieldNames ? '' : 'sectors', $pb.PbFieldType.PM, subBuilder: $0.Sector.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSectorsResponse clone() => GetSectorsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSectorsResponse copyWith(void Function(GetSectorsResponse) updates) => super.copyWith((message) => updates(message as GetSectorsResponse)) as GetSectorsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSectorsResponse create() => GetSectorsResponse._();
  GetSectorsResponse createEmptyInstance() => create();
  static $pb.PbList<GetSectorsResponse> createRepeated() => $pb.PbList<GetSectorsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSectorsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSectorsResponse>(create);
  static GetSectorsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Sector> get sectors => $_getList(0);
}

class GetCustomersRequest extends $pb.GeneratedMessage {
  factory GetCustomersRequest({
    $core.String? sectorId,
    $core.String? searchQuery,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (searchQuery != null) {
      $result.searchQuery = searchQuery;
    }
    return $result;
  }
  GetCustomersRequest._() : super();
  factory GetCustomersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..aOS(2, _omitFieldNames ? '' : 'searchQuery')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomersRequest clone() => GetCustomersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomersRequest copyWith(void Function(GetCustomersRequest) updates) => super.copyWith((message) => updates(message as GetCustomersRequest)) as GetCustomersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomersRequest create() => GetCustomersRequest._();
  GetCustomersRequest createEmptyInstance() => create();
  static $pb.PbList<GetCustomersRequest> createRepeated() => $pb.PbList<GetCustomersRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCustomersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomersRequest>(create);
  static GetCustomersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sectorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sectorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSectorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSectorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get searchQuery => $_getSZ(1);
  @$pb.TagNumber(2)
  set searchQuery($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSearchQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearSearchQuery() => clearField(2);
}

class GetCustomersResponse extends $pb.GeneratedMessage {
  factory GetCustomersResponse({
    $core.Iterable<$0.Customer>? customers,
  }) {
    final $result = create();
    if (customers != null) {
      $result.customers.addAll(customers);
    }
    return $result;
  }
  GetCustomersResponse._() : super();
  factory GetCustomersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCustomersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCustomersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Customer>(1, _omitFieldNames ? '' : 'customers', $pb.PbFieldType.PM, subBuilder: $0.Customer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCustomersResponse clone() => GetCustomersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCustomersResponse copyWith(void Function(GetCustomersResponse) updates) => super.copyWith((message) => updates(message as GetCustomersResponse)) as GetCustomersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCustomersResponse create() => GetCustomersResponse._();
  GetCustomersResponse createEmptyInstance() => create();
  static $pb.PbList<GetCustomersResponse> createRepeated() => $pb.PbList<GetCustomersResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCustomersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCustomersResponse>(create);
  static GetCustomersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Customer> get customers => $_getList(0);
}

class GetReadingsRequest extends $pb.GeneratedMessage {
  factory GetReadingsRequest({
    $core.String? customerId,
    $core.String? sectorId,
    $core.String? period,
  }) {
    final $result = create();
    if (customerId != null) {
      $result.customerId = customerId;
    }
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (period != null) {
      $result.period = period;
    }
    return $result;
  }
  GetReadingsRequest._() : super();
  factory GetReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'customerId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorId')
    ..aOS(3, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReadingsRequest clone() => GetReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReadingsRequest copyWith(void Function(GetReadingsRequest) updates) => super.copyWith((message) => updates(message as GetReadingsRequest)) as GetReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadingsRequest create() => GetReadingsRequest._();
  GetReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetReadingsRequest> createRepeated() => $pb.PbList<GetReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReadingsRequest>(create);
  static GetReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSectorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectorId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get period => $_getSZ(2);
  @$pb.TagNumber(3)
  set period($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriod() => clearField(3);
}

class GetReadingsResponse extends $pb.GeneratedMessage {
  factory GetReadingsResponse({
    $core.Iterable<$0.Reading>? readings,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    return $result;
  }
  GetReadingsResponse._() : super();
  factory GetReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..pc<$0.Reading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: $0.Reading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReadingsResponse clone() => GetReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReadingsResponse copyWith(void Function(GetReadingsResponse) updates) => super.copyWith((message) => updates(message as GetReadingsResponse)) as GetReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadingsResponse create() => GetReadingsResponse._();
  GetReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetReadingsResponse> createRepeated() => $pb.PbList<GetReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReadingsResponse>(create);
  static GetReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.Reading> get readings => $_getList(0);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => create();
  GetSettingsRequest._() : super();
  factory GetSettingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSettingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSettingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSettingsRequest clone() => GetSettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) => super.copyWith((message) => updates(message as GetSettingsRequest)) as GetSettingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  GetSettingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetSettingsRequest> createRepeated() => $pb.PbList<GetSettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  GetSettingsResponse._() : super();
  factory GetSettingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSettingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSettingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSettingsResponse clone() => GetSettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) => super.copyWith((message) => updates(message as GetSettingsResponse)) as GetSettingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse create() => GetSettingsResponse._();
  GetSettingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetSettingsResponse> createRepeated() => $pb.PbList<GetSettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(create);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  UpdateSettingsRequest._() : super();
  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSettingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateSettingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSettingsRequest clone() => UpdateSettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSettingsRequest copyWith(void Function(UpdateSettingsRequest) updates) => super.copyWith((message) => updates(message as UpdateSettingsRequest)) as UpdateSettingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  UpdateSettingsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSettingsRequest> createRepeated() => $pb.PbList<UpdateSettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    $0.Settings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  UpdateSettingsResponse._() : super();
  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSettingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateSettingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Settings>(1, _omitFieldNames ? '' : 'settings', subBuilder: $0.Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSettingsResponse clone() => UpdateSettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSettingsResponse copyWith(void Function(UpdateSettingsResponse) updates) => super.copyWith((message) => updates(message as UpdateSettingsResponse)) as UpdateSettingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  UpdateSettingsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateSettingsResponse> createRepeated() => $pb.PbList<UpdateSettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(create);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($0.Settings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  $0.Settings ensureSettings() => $_ensure(0);
}

class UpsertCustomerRequest extends $pb.GeneratedMessage {
  factory UpsertCustomerRequest({
    $0.Customer? customer,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    return $result;
  }
  UpsertCustomerRequest._() : super();
  factory UpsertCustomerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCustomerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCustomerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCustomerRequest clone() => UpsertCustomerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCustomerRequest copyWith(void Function(UpsertCustomerRequest) updates) => super.copyWith((message) => updates(message as UpsertCustomerRequest)) as UpsertCustomerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCustomerRequest create() => UpsertCustomerRequest._();
  UpsertCustomerRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertCustomerRequest> createRepeated() => $pb.PbList<UpsertCustomerRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertCustomerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCustomerRequest>(create);
  static UpsertCustomerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Customer get customer => $_getN(0);
  @$pb.TagNumber(1)
  set customer($0.Customer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomer() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomer() => clearField(1);
  @$pb.TagNumber(1)
  $0.Customer ensureCustomer() => $_ensure(0);
}

class UpsertCustomerResponse extends $pb.GeneratedMessage {
  factory UpsertCustomerResponse({
    $0.Customer? customer,
  }) {
    final $result = create();
    if (customer != null) {
      $result.customer = customer;
    }
    return $result;
  }
  UpsertCustomerResponse._() : super();
  factory UpsertCustomerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertCustomerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertCustomerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOM<$0.Customer>(1, _omitFieldNames ? '' : 'customer', subBuilder: $0.Customer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertCustomerResponse clone() => UpsertCustomerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertCustomerResponse copyWith(void Function(UpsertCustomerResponse) updates) => super.copyWith((message) => updates(message as UpsertCustomerResponse)) as UpsertCustomerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertCustomerResponse create() => UpsertCustomerResponse._();
  UpsertCustomerResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertCustomerResponse> createRepeated() => $pb.PbList<UpsertCustomerResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertCustomerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertCustomerResponse>(create);
  static UpsertCustomerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Customer get customer => $_getN(0);
  @$pb.TagNumber(1)
  set customer($0.Customer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCustomer() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomer() => clearField(1);
  @$pb.TagNumber(1)
  $0.Customer ensureCustomer() => $_ensure(0);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? email,
    UserRole? role,
    $core.Iterable<$core.String>? assignedSectorIds,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (email != null) {
      $result.email = email;
    }
    if (role != null) {
      $result.role = role;
    }
    if (assignedSectorIds != null) {
      $result.assignedSectorIds.addAll(assignedSectorIds);
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..e<UserRole>(3, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: UserRole.USER_ROLE_UNSPECIFIED, valueOf: UserRole.valueOf, enumValues: UserRole.values)
    ..pPS(4, _omitFieldNames ? '' : 'assignedSectorIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role(UserRole v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.String> get assignedSectorIds => $_getList(3);
}

class GetDashboardStatsRequest extends $pb.GeneratedMessage {
  factory GetDashboardStatsRequest({
    $core.String? period,
  }) {
    final $result = create();
    if (period != null) {
      $result.period = period;
    }
    return $result;
  }
  GetDashboardStatsRequest._() : super();
  factory GetDashboardStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDashboardStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDashboardStatsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDashboardStatsRequest clone() => GetDashboardStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDashboardStatsRequest copyWith(void Function(GetDashboardStatsRequest) updates) => super.copyWith((message) => updates(message as GetDashboardStatsRequest)) as GetDashboardStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsRequest create() => GetDashboardStatsRequest._();
  GetDashboardStatsRequest createEmptyInstance() => create();
  static $pb.PbList<GetDashboardStatsRequest> createRepeated() => $pb.PbList<GetDashboardStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDashboardStatsRequest>(create);
  static GetDashboardStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get period => $_getSZ(0);
  @$pb.TagNumber(1)
  set period($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriod() => clearField(1);
}

class GetDashboardStatsResponse extends $pb.GeneratedMessage {
  factory GetDashboardStatsResponse({
    $core.int? totalCustomers,
    $core.int? totalUsers,
    $core.int? totalReadingsPeriod,
    $core.int? pendingReadingsPeriod,
    $core.Iterable<SectorStat>? sectorStats,
  }) {
    final $result = create();
    if (totalCustomers != null) {
      $result.totalCustomers = totalCustomers;
    }
    if (totalUsers != null) {
      $result.totalUsers = totalUsers;
    }
    if (totalReadingsPeriod != null) {
      $result.totalReadingsPeriod = totalReadingsPeriod;
    }
    if (pendingReadingsPeriod != null) {
      $result.pendingReadingsPeriod = pendingReadingsPeriod;
    }
    if (sectorStats != null) {
      $result.sectorStats.addAll(sectorStats);
    }
    return $result;
  }
  GetDashboardStatsResponse._() : super();
  factory GetDashboardStatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDashboardStatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDashboardStatsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalCustomers', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalUsers', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalReadingsPeriod', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pendingReadingsPeriod', $pb.PbFieldType.O3)
    ..pc<SectorStat>(5, _omitFieldNames ? '' : 'sectorStats', $pb.PbFieldType.PM, subBuilder: SectorStat.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDashboardStatsResponse clone() => GetDashboardStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDashboardStatsResponse copyWith(void Function(GetDashboardStatsResponse) updates) => super.copyWith((message) => updates(message as GetDashboardStatsResponse)) as GetDashboardStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsResponse create() => GetDashboardStatsResponse._();
  GetDashboardStatsResponse createEmptyInstance() => create();
  static $pb.PbList<GetDashboardStatsResponse> createRepeated() => $pb.PbList<GetDashboardStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDashboardStatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDashboardStatsResponse>(create);
  static GetDashboardStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCustomers => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCustomers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalCustomers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCustomers() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalUsers => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalUsers($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalUsers() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalReadingsPeriod => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalReadingsPeriod($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalReadingsPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalReadingsPeriod() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get pendingReadingsPeriod => $_getIZ(3);
  @$pb.TagNumber(4)
  set pendingReadingsPeriod($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPendingReadingsPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingReadingsPeriod() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<SectorStat> get sectorStats => $_getList(4);
}

class SectorStat extends $pb.GeneratedMessage {
  factory SectorStat({
    $core.String? sectorId,
    $core.String? sectorName,
    $core.int? registeredCount,
    $core.int? totalCount,
    $core.int? progressPercentage,
    $core.double? totalConsumption,
  }) {
    final $result = create();
    if (sectorId != null) {
      $result.sectorId = sectorId;
    }
    if (sectorName != null) {
      $result.sectorName = sectorName;
    }
    if (registeredCount != null) {
      $result.registeredCount = registeredCount;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    if (progressPercentage != null) {
      $result.progressPercentage = progressPercentage;
    }
    if (totalConsumption != null) {
      $result.totalConsumption = totalConsumption;
    }
    return $result;
  }
  SectorStat._() : super();
  factory SectorStat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SectorStat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SectorStat', package: const $pb.PackageName(_omitMessageNames ? '' : 'involt.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sectorId')
    ..aOS(2, _omitFieldNames ? '' : 'sectorName')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'registeredCount', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'progressPercentage', $pb.PbFieldType.O3)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalConsumption', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SectorStat clone() => SectorStat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SectorStat copyWith(void Function(SectorStat) updates) => super.copyWith((message) => updates(message as SectorStat)) as SectorStat;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SectorStat create() => SectorStat._();
  SectorStat createEmptyInstance() => create();
  static $pb.PbList<SectorStat> createRepeated() => $pb.PbList<SectorStat>();
  @$core.pragma('dart2js:noInline')
  static SectorStat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SectorStat>(create);
  static SectorStat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sectorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sectorId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSectorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSectorId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectorName => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectorName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSectorName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectorName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get registeredCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set registeredCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRegisteredCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegisteredCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get progressPercentage => $_getIZ(4);
  @$pb.TagNumber(5)
  set progressPercentage($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProgressPercentage() => $_has(4);
  @$pb.TagNumber(5)
  void clearProgressPercentage() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalConsumption => $_getN(5);
  @$pb.TagNumber(6)
  set totalConsumption($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalConsumption() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalConsumption() => clearField(6);
}

class AdminServiceApi {
  $pb.RpcClient _client;
  AdminServiceApi(this._client);

  $async.Future<LoginResponse> login($pb.ClientContext? ctx, LoginRequest request) =>
    _client.invoke<LoginResponse>(ctx, 'AdminService', 'Login', request, LoginResponse())
  ;
  $async.Future<GetUsersResponse> getUsers($pb.ClientContext? ctx, GetUsersRequest request) =>
    _client.invoke<GetUsersResponse>(ctx, 'AdminService', 'GetUsers', request, GetUsersResponse())
  ;
  $async.Future<UpsertUserResponse> upsertUser($pb.ClientContext? ctx, UpsertUserRequest request) =>
    _client.invoke<UpsertUserResponse>(ctx, 'AdminService', 'UpsertUser', request, UpsertUserResponse())
  ;
  $async.Future<GetSectorsResponse> getSectors($pb.ClientContext? ctx, GetSectorsRequest request) =>
    _client.invoke<GetSectorsResponse>(ctx, 'AdminService', 'GetSectors', request, GetSectorsResponse())
  ;
  $async.Future<GetCustomersResponse> getCustomers($pb.ClientContext? ctx, GetCustomersRequest request) =>
    _client.invoke<GetCustomersResponse>(ctx, 'AdminService', 'GetCustomers', request, GetCustomersResponse())
  ;
  $async.Future<GetReadingsResponse> getReadings($pb.ClientContext? ctx, GetReadingsRequest request) =>
    _client.invoke<GetReadingsResponse>(ctx, 'AdminService', 'GetReadings', request, GetReadingsResponse())
  ;
  $async.Future<GetSettingsResponse> getSettings($pb.ClientContext? ctx, GetSettingsRequest request) =>
    _client.invoke<GetSettingsResponse>(ctx, 'AdminService', 'GetSettings', request, GetSettingsResponse())
  ;
  $async.Future<UpdateSettingsResponse> updateSettings($pb.ClientContext? ctx, UpdateSettingsRequest request) =>
    _client.invoke<UpdateSettingsResponse>(ctx, 'AdminService', 'UpdateSettings', request, UpdateSettingsResponse())
  ;
  $async.Future<UpsertCustomerResponse> upsertCustomer($pb.ClientContext? ctx, UpsertCustomerRequest request) =>
    _client.invoke<UpsertCustomerResponse>(ctx, 'AdminService', 'UpsertCustomer', request, UpsertCustomerResponse())
  ;
  $async.Future<GetDashboardStatsResponse> getDashboardStats($pb.ClientContext? ctx, GetDashboardStatsRequest request) =>
    _client.invoke<GetDashboardStatsResponse>(ctx, 'AdminService', 'GetDashboardStats', request, GetDashboardStatsResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
