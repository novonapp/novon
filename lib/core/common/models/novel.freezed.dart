// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Novel _$NovelFromJson(Map<String, dynamic> json) {
  return _Novel.fromJson(json);
}

/// @nodoc
mixin _$Novel {
  String get id => throw _privateConstructorUsedError;
  String get sourceId => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get coverUrl => throw _privateConstructorUsedError;
  NovelStatus get status => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  bool get inLibrary => throw _privateConstructorUsedError;
  int get totalChapters => throw _privateConstructorUsedError;
  int get readChapters => throw _privateConstructorUsedError;
  int get downloadedChapters => throw _privateConstructorUsedError;
  DateTime? get dateAdded => throw _privateConstructorUsedError;
  DateTime? get lastFetched => throw _privateConstructorUsedError;
  DateTime? get lastRead => throw _privateConstructorUsedError;

  /// Serializes this Novel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Novel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NovelCopyWith<Novel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NovelCopyWith<$Res> {
  factory $NovelCopyWith(Novel value, $Res Function(Novel) then) =
      _$NovelCopyWithImpl<$Res, Novel>;
  @useResult
  $Res call({
    String id,
    String sourceId,
    String url,
    String title,
    String author,
    String description,
    String coverUrl,
    NovelStatus status,
    List<String> genres,
    bool inLibrary,
    int totalChapters,
    int readChapters,
    int downloadedChapters,
    DateTime? dateAdded,
    DateTime? lastFetched,
    DateTime? lastRead,
  });
}

/// @nodoc
class _$NovelCopyWithImpl<$Res, $Val extends Novel>
    implements $NovelCopyWith<$Res> {
  _$NovelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Novel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? url = null,
    Object? title = null,
    Object? author = null,
    Object? description = null,
    Object? coverUrl = null,
    Object? status = null,
    Object? genres = null,
    Object? inLibrary = null,
    Object? totalChapters = null,
    Object? readChapters = null,
    Object? downloadedChapters = null,
    Object? dateAdded = freezed,
    Object? lastFetched = freezed,
    Object? lastRead = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceId: null == sourceId
                ? _value.sourceId
                : sourceId // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            coverUrl: null == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as NovelStatus,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            inLibrary: null == inLibrary
                ? _value.inLibrary
                : inLibrary // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalChapters: null == totalChapters
                ? _value.totalChapters
                : totalChapters // ignore: cast_nullable_to_non_nullable
                      as int,
            readChapters: null == readChapters
                ? _value.readChapters
                : readChapters // ignore: cast_nullable_to_non_nullable
                      as int,
            downloadedChapters: null == downloadedChapters
                ? _value.downloadedChapters
                : downloadedChapters // ignore: cast_nullable_to_non_nullable
                      as int,
            dateAdded: freezed == dateAdded
                ? _value.dateAdded
                : dateAdded // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastFetched: freezed == lastFetched
                ? _value.lastFetched
                : lastFetched // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastRead: freezed == lastRead
                ? _value.lastRead
                : lastRead // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NovelImplCopyWith<$Res> implements $NovelCopyWith<$Res> {
  factory _$$NovelImplCopyWith(
    _$NovelImpl value,
    $Res Function(_$NovelImpl) then,
  ) = __$$NovelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sourceId,
    String url,
    String title,
    String author,
    String description,
    String coverUrl,
    NovelStatus status,
    List<String> genres,
    bool inLibrary,
    int totalChapters,
    int readChapters,
    int downloadedChapters,
    DateTime? dateAdded,
    DateTime? lastFetched,
    DateTime? lastRead,
  });
}

/// @nodoc
class __$$NovelImplCopyWithImpl<$Res>
    extends _$NovelCopyWithImpl<$Res, _$NovelImpl>
    implements _$$NovelImplCopyWith<$Res> {
  __$$NovelImplCopyWithImpl(
    _$NovelImpl _value,
    $Res Function(_$NovelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Novel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? url = null,
    Object? title = null,
    Object? author = null,
    Object? description = null,
    Object? coverUrl = null,
    Object? status = null,
    Object? genres = null,
    Object? inLibrary = null,
    Object? totalChapters = null,
    Object? readChapters = null,
    Object? downloadedChapters = null,
    Object? dateAdded = freezed,
    Object? lastFetched = freezed,
    Object? lastRead = freezed,
  }) {
    return _then(
      _$NovelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _value.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        coverUrl: null == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as NovelStatus,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        inLibrary: null == inLibrary
            ? _value.inLibrary
            : inLibrary // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalChapters: null == totalChapters
            ? _value.totalChapters
            : totalChapters // ignore: cast_nullable_to_non_nullable
                  as int,
        readChapters: null == readChapters
            ? _value.readChapters
            : readChapters // ignore: cast_nullable_to_non_nullable
                  as int,
        downloadedChapters: null == downloadedChapters
            ? _value.downloadedChapters
            : downloadedChapters // ignore: cast_nullable_to_non_nullable
                  as int,
        dateAdded: freezed == dateAdded
            ? _value.dateAdded
            : dateAdded // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastFetched: freezed == lastFetched
            ? _value.lastFetched
            : lastFetched // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastRead: freezed == lastRead
            ? _value.lastRead
            : lastRead // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NovelImpl implements _Novel {
  const _$NovelImpl({
    required this.id,
    required this.sourceId,
    required this.url,
    required this.title,
    this.author = '',
    this.description = '',
    this.coverUrl = '',
    this.status = NovelStatus.unknown,
    final List<String> genres = const [],
    this.inLibrary = false,
    this.totalChapters = 0,
    this.readChapters = 0,
    this.downloadedChapters = 0,
    this.dateAdded,
    this.lastFetched,
    this.lastRead,
  }) : _genres = genres;

  factory _$NovelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NovelImplFromJson(json);

  @override
  final String id;
  @override
  final String sourceId;
  @override
  final String url;
  @override
  final String title;
  @override
  @JsonKey()
  final String author;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String coverUrl;
  @override
  @JsonKey()
  final NovelStatus status;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  @JsonKey()
  final bool inLibrary;
  @override
  @JsonKey()
  final int totalChapters;
  @override
  @JsonKey()
  final int readChapters;
  @override
  @JsonKey()
  final int downloadedChapters;
  @override
  final DateTime? dateAdded;
  @override
  final DateTime? lastFetched;
  @override
  final DateTime? lastRead;

  @override
  String toString() {
    return 'Novel(id: $id, sourceId: $sourceId, url: $url, title: $title, author: $author, description: $description, coverUrl: $coverUrl, status: $status, genres: $genres, inLibrary: $inLibrary, totalChapters: $totalChapters, readChapters: $readChapters, downloadedChapters: $downloadedChapters, dateAdded: $dateAdded, lastFetched: $lastFetched, lastRead: $lastRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NovelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.inLibrary, inLibrary) ||
                other.inLibrary == inLibrary) &&
            (identical(other.totalChapters, totalChapters) ||
                other.totalChapters == totalChapters) &&
            (identical(other.readChapters, readChapters) ||
                other.readChapters == readChapters) &&
            (identical(other.downloadedChapters, downloadedChapters) ||
                other.downloadedChapters == downloadedChapters) &&
            (identical(other.dateAdded, dateAdded) ||
                other.dateAdded == dateAdded) &&
            (identical(other.lastFetched, lastFetched) ||
                other.lastFetched == lastFetched) &&
            (identical(other.lastRead, lastRead) ||
                other.lastRead == lastRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sourceId,
    url,
    title,
    author,
    description,
    coverUrl,
    status,
    const DeepCollectionEquality().hash(_genres),
    inLibrary,
    totalChapters,
    readChapters,
    downloadedChapters,
    dateAdded,
    lastFetched,
    lastRead,
  );

  /// Create a copy of Novel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NovelImplCopyWith<_$NovelImpl> get copyWith =>
      __$$NovelImplCopyWithImpl<_$NovelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NovelImplToJson(this);
  }
}

abstract class _Novel implements Novel {
  const factory _Novel({
    required final String id,
    required final String sourceId,
    required final String url,
    required final String title,
    final String author,
    final String description,
    final String coverUrl,
    final NovelStatus status,
    final List<String> genres,
    final bool inLibrary,
    final int totalChapters,
    final int readChapters,
    final int downloadedChapters,
    final DateTime? dateAdded,
    final DateTime? lastFetched,
    final DateTime? lastRead,
  }) = _$NovelImpl;

  factory _Novel.fromJson(Map<String, dynamic> json) = _$NovelImpl.fromJson;

  @override
  String get id;
  @override
  String get sourceId;
  @override
  String get url;
  @override
  String get title;
  @override
  String get author;
  @override
  String get description;
  @override
  String get coverUrl;
  @override
  NovelStatus get status;
  @override
  List<String> get genres;
  @override
  bool get inLibrary;
  @override
  int get totalChapters;
  @override
  int get readChapters;
  @override
  int get downloadedChapters;
  @override
  DateTime? get dateAdded;
  @override
  DateTime? get lastFetched;
  @override
  DateTime? get lastRead;

  /// Create a copy of Novel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NovelImplCopyWith<_$NovelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
