// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NovelFilter _$NovelFilterFromJson(Map<String, dynamic> json) {
  return _NovelFilter.fromJson(json);
}

/// @nodoc
mixin _$NovelFilter {
  String get query => throw _privateConstructorUsedError;
  SortMode get sortMode => throw _privateConstructorUsedError;
  SortDirection get sortDirection => throw _privateConstructorUsedError;
  bool? get downloaded => throw _privateConstructorUsedError;
  bool? get unread => throw _privateConstructorUsedError;
  bool? get started => throw _privateConstructorUsedError;
  bool? get completed => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this NovelFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NovelFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NovelFilterCopyWith<NovelFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NovelFilterCopyWith<$Res> {
  factory $NovelFilterCopyWith(
    NovelFilter value,
    $Res Function(NovelFilter) then,
  ) = _$NovelFilterCopyWithImpl<$Res, NovelFilter>;
  @useResult
  $Res call({
    String query,
    SortMode sortMode,
    SortDirection sortDirection,
    bool? downloaded,
    bool? unread,
    bool? started,
    bool? completed,
    String? categoryId,
  });
}

/// @nodoc
class _$NovelFilterCopyWithImpl<$Res, $Val extends NovelFilter>
    implements $NovelFilterCopyWith<$Res> {
  _$NovelFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NovelFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? sortMode = null,
    Object? sortDirection = null,
    Object? downloaded = freezed,
    Object? unread = freezed,
    Object? started = freezed,
    Object? completed = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _value.copyWith(
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            sortMode: null == sortMode
                ? _value.sortMode
                : sortMode // ignore: cast_nullable_to_non_nullable
                      as SortMode,
            sortDirection: null == sortDirection
                ? _value.sortDirection
                : sortDirection // ignore: cast_nullable_to_non_nullable
                      as SortDirection,
            downloaded: freezed == downloaded
                ? _value.downloaded
                : downloaded // ignore: cast_nullable_to_non_nullable
                      as bool?,
            unread: freezed == unread
                ? _value.unread
                : unread // ignore: cast_nullable_to_non_nullable
                      as bool?,
            started: freezed == started
                ? _value.started
                : started // ignore: cast_nullable_to_non_nullable
                      as bool?,
            completed: freezed == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NovelFilterImplCopyWith<$Res>
    implements $NovelFilterCopyWith<$Res> {
  factory _$$NovelFilterImplCopyWith(
    _$NovelFilterImpl value,
    $Res Function(_$NovelFilterImpl) then,
  ) = __$$NovelFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    SortMode sortMode,
    SortDirection sortDirection,
    bool? downloaded,
    bool? unread,
    bool? started,
    bool? completed,
    String? categoryId,
  });
}

/// @nodoc
class __$$NovelFilterImplCopyWithImpl<$Res>
    extends _$NovelFilterCopyWithImpl<$Res, _$NovelFilterImpl>
    implements _$$NovelFilterImplCopyWith<$Res> {
  __$$NovelFilterImplCopyWithImpl(
    _$NovelFilterImpl _value,
    $Res Function(_$NovelFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NovelFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? sortMode = null,
    Object? sortDirection = null,
    Object? downloaded = freezed,
    Object? unread = freezed,
    Object? started = freezed,
    Object? completed = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _$NovelFilterImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        sortMode: null == sortMode
            ? _value.sortMode
            : sortMode // ignore: cast_nullable_to_non_nullable
                  as SortMode,
        sortDirection: null == sortDirection
            ? _value.sortDirection
            : sortDirection // ignore: cast_nullable_to_non_nullable
                  as SortDirection,
        downloaded: freezed == downloaded
            ? _value.downloaded
            : downloaded // ignore: cast_nullable_to_non_nullable
                  as bool?,
        unread: freezed == unread
            ? _value.unread
            : unread // ignore: cast_nullable_to_non_nullable
                  as bool?,
        started: freezed == started
            ? _value.started
            : started // ignore: cast_nullable_to_non_nullable
                  as bool?,
        completed: freezed == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NovelFilterImpl implements _NovelFilter {
  const _$NovelFilterImpl({
    this.query = '',
    this.sortMode = SortMode.lastRead,
    this.sortDirection = SortDirection.descending,
    this.downloaded = null,
    this.unread = null,
    this.started = null,
    this.completed = null,
    this.categoryId = null,
  });

  factory _$NovelFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$NovelFilterImplFromJson(json);

  @override
  @JsonKey()
  final String query;
  @override
  @JsonKey()
  final SortMode sortMode;
  @override
  @JsonKey()
  final SortDirection sortDirection;
  @override
  @JsonKey()
  final bool? downloaded;
  @override
  @JsonKey()
  final bool? unread;
  @override
  @JsonKey()
  final bool? started;
  @override
  @JsonKey()
  final bool? completed;
  @override
  @JsonKey()
  final String? categoryId;

  @override
  String toString() {
    return 'NovelFilter(query: $query, sortMode: $sortMode, sortDirection: $sortDirection, downloaded: $downloaded, unread: $unread, started: $started, completed: $completed, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NovelFilterImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.sortMode, sortMode) ||
                other.sortMode == sortMode) &&
            (identical(other.sortDirection, sortDirection) ||
                other.sortDirection == sortDirection) &&
            (identical(other.downloaded, downloaded) ||
                other.downloaded == downloaded) &&
            (identical(other.unread, unread) || other.unread == unread) &&
            (identical(other.started, started) || other.started == started) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    sortMode,
    sortDirection,
    downloaded,
    unread,
    started,
    completed,
    categoryId,
  );

  /// Create a copy of NovelFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NovelFilterImplCopyWith<_$NovelFilterImpl> get copyWith =>
      __$$NovelFilterImplCopyWithImpl<_$NovelFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NovelFilterImplToJson(this);
  }
}

abstract class _NovelFilter implements NovelFilter {
  const factory _NovelFilter({
    final String query,
    final SortMode sortMode,
    final SortDirection sortDirection,
    final bool? downloaded,
    final bool? unread,
    final bool? started,
    final bool? completed,
    final String? categoryId,
  }) = _$NovelFilterImpl;

  factory _NovelFilter.fromJson(Map<String, dynamic> json) =
      _$NovelFilterImpl.fromJson;

  @override
  String get query;
  @override
  SortMode get sortMode;
  @override
  SortDirection get sortDirection;
  @override
  bool? get downloaded;
  @override
  bool? get unread;
  @override
  bool? get started;
  @override
  bool? get completed;
  @override
  String? get categoryId;

  /// Create a copy of NovelFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NovelFilterImplCopyWith<_$NovelFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
