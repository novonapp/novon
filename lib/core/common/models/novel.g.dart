// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NovelImpl _$$NovelImplFromJson(Map<String, dynamic> json) => _$NovelImpl(
  id: json['id'] as String,
  sourceId: json['sourceId'] as String,
  url: json['url'] as String,
  title: json['title'] as String,
  author: json['author'] as String? ?? '',
  description: json['description'] as String? ?? '',
  coverUrl: json['coverUrl'] as String? ?? '',
  status:
      $enumDecodeNullable(_$NovelStatusEnumMap, json['status']) ??
      NovelStatus.unknown,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  inLibrary: json['inLibrary'] as bool? ?? false,
  totalChapters: (json['totalChapters'] as num?)?.toInt() ?? 0,
  readChapters: (json['readChapters'] as num?)?.toInt() ?? 0,
  downloadedChapters: (json['downloadedChapters'] as num?)?.toInt() ?? 0,
  dateAdded: json['dateAdded'] == null
      ? null
      : DateTime.parse(json['dateAdded'] as String),
  lastFetched: json['lastFetched'] == null
      ? null
      : DateTime.parse(json['lastFetched'] as String),
  lastRead: json['lastRead'] == null
      ? null
      : DateTime.parse(json['lastRead'] as String),
);

Map<String, dynamic> _$$NovelImplToJson(_$NovelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'url': instance.url,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'status': _$NovelStatusEnumMap[instance.status]!,
      'genres': instance.genres,
      'inLibrary': instance.inLibrary,
      'totalChapters': instance.totalChapters,
      'readChapters': instance.readChapters,
      'downloadedChapters': instance.downloadedChapters,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'lastFetched': instance.lastFetched?.toIso8601String(),
      'lastRead': instance.lastRead?.toIso8601String(),
    };

const _$NovelStatusEnumMap = {
  NovelStatus.ongoing: 'ongoing',
  NovelStatus.completed: 'completed',
  NovelStatus.hiatus: 'hiatus',
  NovelStatus.dropped: 'dropped',
  NovelStatus.unknown: 'unknown',
};
