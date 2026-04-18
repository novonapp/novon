// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterImpl _$$ChapterImplFromJson(Map<String, dynamic> json) =>
    _$ChapterImpl(
      id: json['id'] as String,
      novelId: json['novelId'] as String,
      url: json['url'] as String,
      name: json['name'] as String,
      number: (json['number'] as num?)?.toDouble() ?? -1,
      dateUpload: json['dateUpload'] == null
          ? null
          : DateTime.parse(json['dateUpload'] as String),
      read: json['read'] as bool? ?? false,
      lastPageRead: (json['lastPageRead'] as num?)?.toInt() ?? 0,
      lastScrollOffset: (json['lastScrollOffset'] as num?)?.toDouble() ?? 0,
      downloaded: json['downloaded'] as bool? ?? false,
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChapterImplToJson(_$ChapterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'novelId': instance.novelId,
      'url': instance.url,
      'name': instance.name,
      'number': instance.number,
      'dateUpload': instance.dateUpload?.toIso8601String(),
      'read': instance.read,
      'lastPageRead': instance.lastPageRead,
      'lastScrollOffset': instance.lastScrollOffset,
      'downloaded': instance.downloaded,
      'wordCount': instance.wordCount,
    };

_$ChapterContentImpl _$$ChapterContentImplFromJson(Map<String, dynamic> json) =>
    _$ChapterContentImpl(
      chapterId: json['chapterId'] as String,
      html: json['html'] as String,
      title: json['title'] as String?,
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      fetchedAt: json['fetchedAt'] == null
          ? null
          : DateTime.parse(json['fetchedAt'] as String),
    );

Map<String, dynamic> _$$ChapterContentImplToJson(
  _$ChapterContentImpl instance,
) => <String, dynamic>{
  'chapterId': instance.chapterId,
  'html': instance.html,
  'title': instance.title,
  'wordCount': instance.wordCount,
  'fetchedAt': instance.fetchedAt?.toIso8601String(),
};
