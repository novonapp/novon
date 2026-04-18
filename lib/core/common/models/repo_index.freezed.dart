// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repo_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RepoIndex _$RepoIndexFromJson(Map<String, dynamic> json) {
  return _RepoIndex.fromJson(json);
}

/// @nodoc
mixin _$RepoIndex {
  String get repoName => throw _privateConstructorUsedError;
  String get repoUrl => throw _privateConstructorUsedError;
  String? get maintainerUrl => throw _privateConstructorUsedError;
  String? get generated => throw _privateConstructorUsedError;
  String get apiVersion => throw _privateConstructorUsedError;
  String? get publicKey => throw _privateConstructorUsedError;
  List<RepoExtensionEntry> get extensions => throw _privateConstructorUsedError;

  /// Serializes this RepoIndex to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RepoIndex
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepoIndexCopyWith<RepoIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepoIndexCopyWith<$Res> {
  factory $RepoIndexCopyWith(RepoIndex value, $Res Function(RepoIndex) then) =
      _$RepoIndexCopyWithImpl<$Res, RepoIndex>;
  @useResult
  $Res call({
    String repoName,
    String repoUrl,
    String? maintainerUrl,
    String? generated,
    String apiVersion,
    String? publicKey,
    List<RepoExtensionEntry> extensions,
  });
}

/// @nodoc
class _$RepoIndexCopyWithImpl<$Res, $Val extends RepoIndex>
    implements $RepoIndexCopyWith<$Res> {
  _$RepoIndexCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepoIndex
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repoName = null,
    Object? repoUrl = null,
    Object? maintainerUrl = freezed,
    Object? generated = freezed,
    Object? apiVersion = null,
    Object? publicKey = freezed,
    Object? extensions = null,
  }) {
    return _then(
      _value.copyWith(
            repoName: null == repoName
                ? _value.repoName
                : repoName // ignore: cast_nullable_to_non_nullable
                      as String,
            repoUrl: null == repoUrl
                ? _value.repoUrl
                : repoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            maintainerUrl: freezed == maintainerUrl
                ? _value.maintainerUrl
                : maintainerUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            generated: freezed == generated
                ? _value.generated
                : generated // ignore: cast_nullable_to_non_nullable
                      as String?,
            apiVersion: null == apiVersion
                ? _value.apiVersion
                : apiVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            publicKey: freezed == publicKey
                ? _value.publicKey
                : publicKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            extensions: null == extensions
                ? _value.extensions
                : extensions // ignore: cast_nullable_to_non_nullable
                      as List<RepoExtensionEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepoIndexImplCopyWith<$Res>
    implements $RepoIndexCopyWith<$Res> {
  factory _$$RepoIndexImplCopyWith(
    _$RepoIndexImpl value,
    $Res Function(_$RepoIndexImpl) then,
  ) = __$$RepoIndexImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String repoName,
    String repoUrl,
    String? maintainerUrl,
    String? generated,
    String apiVersion,
    String? publicKey,
    List<RepoExtensionEntry> extensions,
  });
}

/// @nodoc
class __$$RepoIndexImplCopyWithImpl<$Res>
    extends _$RepoIndexCopyWithImpl<$Res, _$RepoIndexImpl>
    implements _$$RepoIndexImplCopyWith<$Res> {
  __$$RepoIndexImplCopyWithImpl(
    _$RepoIndexImpl _value,
    $Res Function(_$RepoIndexImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepoIndex
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repoName = null,
    Object? repoUrl = null,
    Object? maintainerUrl = freezed,
    Object? generated = freezed,
    Object? apiVersion = null,
    Object? publicKey = freezed,
    Object? extensions = null,
  }) {
    return _then(
      _$RepoIndexImpl(
        repoName: null == repoName
            ? _value.repoName
            : repoName // ignore: cast_nullable_to_non_nullable
                  as String,
        repoUrl: null == repoUrl
            ? _value.repoUrl
            : repoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        maintainerUrl: freezed == maintainerUrl
            ? _value.maintainerUrl
            : maintainerUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        generated: freezed == generated
            ? _value.generated
            : generated // ignore: cast_nullable_to_non_nullable
                  as String?,
        apiVersion: null == apiVersion
            ? _value.apiVersion
            : apiVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        publicKey: freezed == publicKey
            ? _value.publicKey
            : publicKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        extensions: null == extensions
            ? _value._extensions
            : extensions // ignore: cast_nullable_to_non_nullable
                  as List<RepoExtensionEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepoIndexImpl implements _RepoIndex {
  const _$RepoIndexImpl({
    required this.repoName,
    required this.repoUrl,
    this.maintainerUrl,
    this.generated,
    required this.apiVersion,
    this.publicKey,
    final List<RepoExtensionEntry> extensions = const [],
  }) : _extensions = extensions;

  factory _$RepoIndexImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepoIndexImplFromJson(json);

  @override
  final String repoName;
  @override
  final String repoUrl;
  @override
  final String? maintainerUrl;
  @override
  final String? generated;
  @override
  final String apiVersion;
  @override
  final String? publicKey;
  final List<RepoExtensionEntry> _extensions;
  @override
  @JsonKey()
  List<RepoExtensionEntry> get extensions {
    if (_extensions is EqualUnmodifiableListView) return _extensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extensions);
  }

  @override
  String toString() {
    return 'RepoIndex(repoName: $repoName, repoUrl: $repoUrl, maintainerUrl: $maintainerUrl, generated: $generated, apiVersion: $apiVersion, publicKey: $publicKey, extensions: $extensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepoIndexImpl &&
            (identical(other.repoName, repoName) ||
                other.repoName == repoName) &&
            (identical(other.repoUrl, repoUrl) || other.repoUrl == repoUrl) &&
            (identical(other.maintainerUrl, maintainerUrl) ||
                other.maintainerUrl == maintainerUrl) &&
            (identical(other.generated, generated) ||
                other.generated == generated) &&
            (identical(other.apiVersion, apiVersion) ||
                other.apiVersion == apiVersion) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            const DeepCollectionEquality().equals(
              other._extensions,
              _extensions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    repoName,
    repoUrl,
    maintainerUrl,
    generated,
    apiVersion,
    publicKey,
    const DeepCollectionEquality().hash(_extensions),
  );

  /// Create a copy of RepoIndex
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepoIndexImplCopyWith<_$RepoIndexImpl> get copyWith =>
      __$$RepoIndexImplCopyWithImpl<_$RepoIndexImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepoIndexImplToJson(this);
  }
}

abstract class _RepoIndex implements RepoIndex {
  const factory _RepoIndex({
    required final String repoName,
    required final String repoUrl,
    final String? maintainerUrl,
    final String? generated,
    required final String apiVersion,
    final String? publicKey,
    final List<RepoExtensionEntry> extensions,
  }) = _$RepoIndexImpl;

  factory _RepoIndex.fromJson(Map<String, dynamic> json) =
      _$RepoIndexImpl.fromJson;

  @override
  String get repoName;
  @override
  String get repoUrl;
  @override
  String? get maintainerUrl;
  @override
  String? get generated;
  @override
  String get apiVersion;
  @override
  String? get publicKey;
  @override
  List<RepoExtensionEntry> get extensions;

  /// Create a copy of RepoIndex
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepoIndexImplCopyWith<_$RepoIndexImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RepoExtensionEntry _$RepoExtensionEntryFromJson(Map<String, dynamic> json) {
  return _RepoExtensionEntry.fromJson(json);
}

/// @nodoc
mixin _$RepoExtensionEntry {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get apiVersion => throw _privateConstructorUsedError;
  String get minAppVersion => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
  bool get nsfw => throw _privateConstructorUsedError;
  bool get hasCloudflare => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String get downloadUrl => throw _privateConstructorUsedError;
  String get sha256 => throw _privateConstructorUsedError;
  String? get signature => throw _privateConstructorUsedError;
  String? get changelog => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RepoExtensionEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RepoExtensionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RepoExtensionEntryCopyWith<RepoExtensionEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepoExtensionEntryCopyWith<$Res> {
  factory $RepoExtensionEntryCopyWith(
    RepoExtensionEntry value,
    $Res Function(RepoExtensionEntry) then,
  ) = _$RepoExtensionEntryCopyWithImpl<$Res, RepoExtensionEntry>;
  @useResult
  $Res call({
    String id,
    String name,
    String version,
    String apiVersion,
    String minAppVersion,
    String lang,
    bool nsfw,
    bool hasCloudflare,
    List<String> categories,
    String? icon,
    String downloadUrl,
    String sha256,
    String? signature,
    String? changelog,
    String? updatedAt,
  });
}

/// @nodoc
class _$RepoExtensionEntryCopyWithImpl<$Res, $Val extends RepoExtensionEntry>
    implements $RepoExtensionEntryCopyWith<$Res> {
  _$RepoExtensionEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepoExtensionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? version = null,
    Object? apiVersion = null,
    Object? minAppVersion = null,
    Object? lang = null,
    Object? nsfw = null,
    Object? hasCloudflare = null,
    Object? categories = null,
    Object? icon = freezed,
    Object? downloadUrl = null,
    Object? sha256 = null,
    Object? signature = freezed,
    Object? changelog = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            apiVersion: null == apiVersion
                ? _value.apiVersion
                : apiVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            minAppVersion: null == minAppVersion
                ? _value.minAppVersion
                : minAppVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            lang: null == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String,
            nsfw: null == nsfw
                ? _value.nsfw
                : nsfw // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasCloudflare: null == hasCloudflare
                ? _value.hasCloudflare
                : hasCloudflare // ignore: cast_nullable_to_non_nullable
                      as bool,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            downloadUrl: null == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            sha256: null == sha256
                ? _value.sha256
                : sha256 // ignore: cast_nullable_to_non_nullable
                      as String,
            signature: freezed == signature
                ? _value.signature
                : signature // ignore: cast_nullable_to_non_nullable
                      as String?,
            changelog: freezed == changelog
                ? _value.changelog
                : changelog // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RepoExtensionEntryImplCopyWith<$Res>
    implements $RepoExtensionEntryCopyWith<$Res> {
  factory _$$RepoExtensionEntryImplCopyWith(
    _$RepoExtensionEntryImpl value,
    $Res Function(_$RepoExtensionEntryImpl) then,
  ) = __$$RepoExtensionEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String version,
    String apiVersion,
    String minAppVersion,
    String lang,
    bool nsfw,
    bool hasCloudflare,
    List<String> categories,
    String? icon,
    String downloadUrl,
    String sha256,
    String? signature,
    String? changelog,
    String? updatedAt,
  });
}

/// @nodoc
class __$$RepoExtensionEntryImplCopyWithImpl<$Res>
    extends _$RepoExtensionEntryCopyWithImpl<$Res, _$RepoExtensionEntryImpl>
    implements _$$RepoExtensionEntryImplCopyWith<$Res> {
  __$$RepoExtensionEntryImplCopyWithImpl(
    _$RepoExtensionEntryImpl _value,
    $Res Function(_$RepoExtensionEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepoExtensionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? version = null,
    Object? apiVersion = null,
    Object? minAppVersion = null,
    Object? lang = null,
    Object? nsfw = null,
    Object? hasCloudflare = null,
    Object? categories = null,
    Object? icon = freezed,
    Object? downloadUrl = null,
    Object? sha256 = null,
    Object? signature = freezed,
    Object? changelog = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RepoExtensionEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        apiVersion: null == apiVersion
            ? _value.apiVersion
            : apiVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        minAppVersion: null == minAppVersion
            ? _value.minAppVersion
            : minAppVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        lang: null == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String,
        nsfw: null == nsfw
            ? _value.nsfw
            : nsfw // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasCloudflare: null == hasCloudflare
            ? _value.hasCloudflare
            : hasCloudflare // ignore: cast_nullable_to_non_nullable
                  as bool,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        downloadUrl: null == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        sha256: null == sha256
            ? _value.sha256
            : sha256 // ignore: cast_nullable_to_non_nullable
                  as String,
        signature: freezed == signature
            ? _value.signature
            : signature // ignore: cast_nullable_to_non_nullable
                  as String?,
        changelog: freezed == changelog
            ? _value.changelog
            : changelog // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RepoExtensionEntryImpl implements _RepoExtensionEntry {
  const _$RepoExtensionEntryImpl({
    required this.id,
    required this.name,
    required this.version,
    required this.apiVersion,
    required this.minAppVersion,
    required this.lang,
    this.nsfw = false,
    this.hasCloudflare = false,
    final List<String> categories = const [],
    this.icon,
    required this.downloadUrl,
    required this.sha256,
    this.signature,
    this.changelog,
    this.updatedAt,
  }) : _categories = categories;

  factory _$RepoExtensionEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepoExtensionEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String version;
  @override
  final String apiVersion;
  @override
  final String minAppVersion;
  @override
  final String lang;
  @override
  @JsonKey()
  final bool nsfw;
  @override
  @JsonKey()
  final bool hasCloudflare;
  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? icon;
  @override
  final String downloadUrl;
  @override
  final String sha256;
  @override
  final String? signature;
  @override
  final String? changelog;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'RepoExtensionEntry(id: $id, name: $name, version: $version, apiVersion: $apiVersion, minAppVersion: $minAppVersion, lang: $lang, nsfw: $nsfw, hasCloudflare: $hasCloudflare, categories: $categories, icon: $icon, downloadUrl: $downloadUrl, sha256: $sha256, signature: $signature, changelog: $changelog, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepoExtensionEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.apiVersion, apiVersion) ||
                other.apiVersion == apiVersion) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.nsfw, nsfw) || other.nsfw == nsfw) &&
            (identical(other.hasCloudflare, hasCloudflare) ||
                other.hasCloudflare == hasCloudflare) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.sha256, sha256) || other.sha256 == sha256) &&
            (identical(other.signature, signature) ||
                other.signature == signature) &&
            (identical(other.changelog, changelog) ||
                other.changelog == changelog) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    version,
    apiVersion,
    minAppVersion,
    lang,
    nsfw,
    hasCloudflare,
    const DeepCollectionEquality().hash(_categories),
    icon,
    downloadUrl,
    sha256,
    signature,
    changelog,
    updatedAt,
  );

  /// Create a copy of RepoExtensionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepoExtensionEntryImplCopyWith<_$RepoExtensionEntryImpl> get copyWith =>
      __$$RepoExtensionEntryImplCopyWithImpl<_$RepoExtensionEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RepoExtensionEntryImplToJson(this);
  }
}

abstract class _RepoExtensionEntry implements RepoExtensionEntry {
  const factory _RepoExtensionEntry({
    required final String id,
    required final String name,
    required final String version,
    required final String apiVersion,
    required final String minAppVersion,
    required final String lang,
    final bool nsfw,
    final bool hasCloudflare,
    final List<String> categories,
    final String? icon,
    required final String downloadUrl,
    required final String sha256,
    final String? signature,
    final String? changelog,
    final String? updatedAt,
  }) = _$RepoExtensionEntryImpl;

  factory _RepoExtensionEntry.fromJson(Map<String, dynamic> json) =
      _$RepoExtensionEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get version;
  @override
  String get apiVersion;
  @override
  String get minAppVersion;
  @override
  String get lang;
  @override
  bool get nsfw;
  @override
  bool get hasCloudflare;
  @override
  List<String> get categories;
  @override
  String? get icon;
  @override
  String get downloadUrl;
  @override
  String get sha256;
  @override
  String? get signature;
  @override
  String? get changelog;
  @override
  String? get updatedAt;

  /// Create a copy of RepoExtensionEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepoExtensionEntryImplCopyWith<_$RepoExtensionEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
