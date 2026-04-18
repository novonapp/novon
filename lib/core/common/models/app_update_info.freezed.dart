// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUpdateInfo _$AppUpdateInfoFromJson(Map<String, dynamic> json) {
  return _AppUpdateInfo.fromJson(json);
}

/// @nodoc
mixin _$AppUpdateInfo {
  String get tagName => throw _privateConstructorUsedError;
  String get changelog => throw _privateConstructorUsedError;
  String get downloadUrl => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this AppUpdateInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUpdateInfoCopyWith<AppUpdateInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUpdateInfoCopyWith<$Res> {
  factory $AppUpdateInfoCopyWith(
    AppUpdateInfo value,
    $Res Function(AppUpdateInfo) then,
  ) = _$AppUpdateInfoCopyWithImpl<$Res, AppUpdateInfo>;
  @useResult
  $Res call({
    String tagName,
    String changelog,
    String downloadUrl,
    String fileName,
    int size,
    DateTime publishedAt,
  });
}

/// @nodoc
class _$AppUpdateInfoCopyWithImpl<$Res, $Val extends AppUpdateInfo>
    implements $AppUpdateInfoCopyWith<$Res> {
  _$AppUpdateInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagName = null,
    Object? changelog = null,
    Object? downloadUrl = null,
    Object? fileName = null,
    Object? size = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _value.copyWith(
            tagName: null == tagName
                ? _value.tagName
                : tagName // ignore: cast_nullable_to_non_nullable
                      as String,
            changelog: null == changelog
                ? _value.changelog
                : changelog // ignore: cast_nullable_to_non_nullable
                      as String,
            downloadUrl: null == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUpdateInfoImplCopyWith<$Res>
    implements $AppUpdateInfoCopyWith<$Res> {
  factory _$$AppUpdateInfoImplCopyWith(
    _$AppUpdateInfoImpl value,
    $Res Function(_$AppUpdateInfoImpl) then,
  ) = __$$AppUpdateInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tagName,
    String changelog,
    String downloadUrl,
    String fileName,
    int size,
    DateTime publishedAt,
  });
}

/// @nodoc
class __$$AppUpdateInfoImplCopyWithImpl<$Res>
    extends _$AppUpdateInfoCopyWithImpl<$Res, _$AppUpdateInfoImpl>
    implements _$$AppUpdateInfoImplCopyWith<$Res> {
  __$$AppUpdateInfoImplCopyWithImpl(
    _$AppUpdateInfoImpl _value,
    $Res Function(_$AppUpdateInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagName = null,
    Object? changelog = null,
    Object? downloadUrl = null,
    Object? fileName = null,
    Object? size = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _$AppUpdateInfoImpl(
        tagName: null == tagName
            ? _value.tagName
            : tagName // ignore: cast_nullable_to_non_nullable
                  as String,
        changelog: null == changelog
            ? _value.changelog
            : changelog // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadUrl: null == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUpdateInfoImpl implements _AppUpdateInfo {
  const _$AppUpdateInfoImpl({
    required this.tagName,
    required this.changelog,
    required this.downloadUrl,
    required this.fileName,
    required this.size,
    required this.publishedAt,
  });

  factory _$AppUpdateInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUpdateInfoImplFromJson(json);

  @override
  final String tagName;
  @override
  final String changelog;
  @override
  final String downloadUrl;
  @override
  final String fileName;
  @override
  final int size;
  @override
  final DateTime publishedAt;

  @override
  String toString() {
    return 'AppUpdateInfo(tagName: $tagName, changelog: $changelog, downloadUrl: $downloadUrl, fileName: $fileName, size: $size, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateInfoImpl &&
            (identical(other.tagName, tagName) || other.tagName == tagName) &&
            (identical(other.changelog, changelog) ||
                other.changelog == changelog) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tagName,
    changelog,
    downloadUrl,
    fileName,
    size,
    publishedAt,
  );

  /// Create a copy of AppUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateInfoImplCopyWith<_$AppUpdateInfoImpl> get copyWith =>
      __$$AppUpdateInfoImplCopyWithImpl<_$AppUpdateInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUpdateInfoImplToJson(this);
  }
}

abstract class _AppUpdateInfo implements AppUpdateInfo {
  const factory _AppUpdateInfo({
    required final String tagName,
    required final String changelog,
    required final String downloadUrl,
    required final String fileName,
    required final int size,
    required final DateTime publishedAt,
  }) = _$AppUpdateInfoImpl;

  factory _AppUpdateInfo.fromJson(Map<String, dynamic> json) =
      _$AppUpdateInfoImpl.fromJson;

  @override
  String get tagName;
  @override
  String get changelog;
  @override
  String get downloadUrl;
  @override
  String get fileName;
  @override
  int get size;
  @override
  DateTime get publishedAt;

  /// Create a copy of AppUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUpdateInfoImplCopyWith<_$AppUpdateInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
