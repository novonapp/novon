// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReadingPosition _$ReadingPositionFromJson(Map<String, dynamic> json) {
  return _ReadingPosition.fromJson(json);
}

/// @nodoc
mixin _$ReadingPosition {
  String get chapterId => throw _privateConstructorUsedError;
  String get novelId => throw _privateConstructorUsedError;
  int get itemIndex => throw _privateConstructorUsedError;
  double get scrollOffset => throw _privateConstructorUsedError;
  DateTime? get lastRead => throw _privateConstructorUsedError;
  int get timeSpentMs => throw _privateConstructorUsedError;

  /// Serializes this ReadingPosition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingPositionCopyWith<ReadingPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingPositionCopyWith<$Res> {
  factory $ReadingPositionCopyWith(
    ReadingPosition value,
    $Res Function(ReadingPosition) then,
  ) = _$ReadingPositionCopyWithImpl<$Res, ReadingPosition>;
  @useResult
  $Res call({
    String chapterId,
    String novelId,
    int itemIndex,
    double scrollOffset,
    DateTime? lastRead,
    int timeSpentMs,
  });
}

/// @nodoc
class _$ReadingPositionCopyWithImpl<$Res, $Val extends ReadingPosition>
    implements $ReadingPositionCopyWith<$Res> {
  _$ReadingPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? novelId = null,
    Object? itemIndex = null,
    Object? scrollOffset = null,
    Object? lastRead = freezed,
    Object? timeSpentMs = null,
  }) {
    return _then(
      _value.copyWith(
            chapterId: null == chapterId
                ? _value.chapterId
                : chapterId // ignore: cast_nullable_to_non_nullable
                      as String,
            novelId: null == novelId
                ? _value.novelId
                : novelId // ignore: cast_nullable_to_non_nullable
                      as String,
            itemIndex: null == itemIndex
                ? _value.itemIndex
                : itemIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            scrollOffset: null == scrollOffset
                ? _value.scrollOffset
                : scrollOffset // ignore: cast_nullable_to_non_nullable
                      as double,
            lastRead: freezed == lastRead
                ? _value.lastRead
                : lastRead // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            timeSpentMs: null == timeSpentMs
                ? _value.timeSpentMs
                : timeSpentMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingPositionImplCopyWith<$Res>
    implements $ReadingPositionCopyWith<$Res> {
  factory _$$ReadingPositionImplCopyWith(
    _$ReadingPositionImpl value,
    $Res Function(_$ReadingPositionImpl) then,
  ) = __$$ReadingPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String chapterId,
    String novelId,
    int itemIndex,
    double scrollOffset,
    DateTime? lastRead,
    int timeSpentMs,
  });
}

/// @nodoc
class __$$ReadingPositionImplCopyWithImpl<$Res>
    extends _$ReadingPositionCopyWithImpl<$Res, _$ReadingPositionImpl>
    implements _$$ReadingPositionImplCopyWith<$Res> {
  __$$ReadingPositionImplCopyWithImpl(
    _$ReadingPositionImpl _value,
    $Res Function(_$ReadingPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chapterId = null,
    Object? novelId = null,
    Object? itemIndex = null,
    Object? scrollOffset = null,
    Object? lastRead = freezed,
    Object? timeSpentMs = null,
  }) {
    return _then(
      _$ReadingPositionImpl(
        chapterId: null == chapterId
            ? _value.chapterId
            : chapterId // ignore: cast_nullable_to_non_nullable
                  as String,
        novelId: null == novelId
            ? _value.novelId
            : novelId // ignore: cast_nullable_to_non_nullable
                  as String,
        itemIndex: null == itemIndex
            ? _value.itemIndex
            : itemIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        scrollOffset: null == scrollOffset
            ? _value.scrollOffset
            : scrollOffset // ignore: cast_nullable_to_non_nullable
                  as double,
        lastRead: freezed == lastRead
            ? _value.lastRead
            : lastRead // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        timeSpentMs: null == timeSpentMs
            ? _value.timeSpentMs
            : timeSpentMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingPositionImpl implements _ReadingPosition {
  const _$ReadingPositionImpl({
    required this.chapterId,
    required this.novelId,
    this.itemIndex = 0,
    this.scrollOffset = 0.0,
    this.lastRead,
    this.timeSpentMs = 0,
  });

  factory _$ReadingPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingPositionImplFromJson(json);

  @override
  final String chapterId;
  @override
  final String novelId;
  @override
  @JsonKey()
  final int itemIndex;
  @override
  @JsonKey()
  final double scrollOffset;
  @override
  final DateTime? lastRead;
  @override
  @JsonKey()
  final int timeSpentMs;

  @override
  String toString() {
    return 'ReadingPosition(chapterId: $chapterId, novelId: $novelId, itemIndex: $itemIndex, scrollOffset: $scrollOffset, lastRead: $lastRead, timeSpentMs: $timeSpentMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingPositionImpl &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.novelId, novelId) || other.novelId == novelId) &&
            (identical(other.itemIndex, itemIndex) ||
                other.itemIndex == itemIndex) &&
            (identical(other.scrollOffset, scrollOffset) ||
                other.scrollOffset == scrollOffset) &&
            (identical(other.lastRead, lastRead) ||
                other.lastRead == lastRead) &&
            (identical(other.timeSpentMs, timeSpentMs) ||
                other.timeSpentMs == timeSpentMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chapterId,
    novelId,
    itemIndex,
    scrollOffset,
    lastRead,
    timeSpentMs,
  );

  /// Create a copy of ReadingPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingPositionImplCopyWith<_$ReadingPositionImpl> get copyWith =>
      __$$ReadingPositionImplCopyWithImpl<_$ReadingPositionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingPositionImplToJson(this);
  }
}

abstract class _ReadingPosition implements ReadingPosition {
  const factory _ReadingPosition({
    required final String chapterId,
    required final String novelId,
    final int itemIndex,
    final double scrollOffset,
    final DateTime? lastRead,
    final int timeSpentMs,
  }) = _$ReadingPositionImpl;

  factory _ReadingPosition.fromJson(Map<String, dynamic> json) =
      _$ReadingPositionImpl.fromJson;

  @override
  String get chapterId;
  @override
  String get novelId;
  @override
  int get itemIndex;
  @override
  double get scrollOffset;
  @override
  DateTime? get lastRead;
  @override
  int get timeSpentMs;

  /// Create a copy of ReadingPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingPositionImplCopyWith<_$ReadingPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
