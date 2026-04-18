// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NovelFilterImpl _$$NovelFilterImplFromJson(Map<String, dynamic> json) =>
    _$NovelFilterImpl(
      query: json['query'] as String? ?? '',
      sortMode:
          $enumDecodeNullable(_$SortModeEnumMap, json['sortMode']) ??
          SortMode.lastRead,
      sortDirection:
          $enumDecodeNullable(_$SortDirectionEnumMap, json['sortDirection']) ??
          SortDirection.descending,
      downloaded: json['downloaded'] as bool?,
      unread: json['unread'] as bool?,
      started: json['started'] as bool?,
      completed: json['completed'] as bool?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$$NovelFilterImplToJson(_$NovelFilterImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'sortMode': _$SortModeEnumMap[instance.sortMode]!,
      'sortDirection': _$SortDirectionEnumMap[instance.sortDirection]!,
      'downloaded': instance.downloaded,
      'unread': instance.unread,
      'started': instance.started,
      'completed': instance.completed,
      'categoryId': instance.categoryId,
    };

const _$SortModeEnumMap = {
  SortMode.alphabetical: 'alphabetical',
  SortMode.lastRead: 'lastRead',
  SortMode.lastUpdated: 'lastUpdated',
  SortMode.dateAdded: 'dateAdded',
  SortMode.totalChapters: 'totalChapters',
  SortMode.unreadChapters: 'unreadChapters',
};

const _$SortDirectionEnumMap = {
  SortDirection.ascending: 'ascending',
  SortDirection.descending: 'descending',
};
