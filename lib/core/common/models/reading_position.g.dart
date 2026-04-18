// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingPositionImpl _$$ReadingPositionImplFromJson(
  Map<String, dynamic> json,
) => _$ReadingPositionImpl(
  chapterId: json['chapterId'] as String,
  novelId: json['novelId'] as String,
  itemIndex: (json['itemIndex'] as num?)?.toInt() ?? 0,
  scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0.0,
  lastRead: json['lastRead'] == null
      ? null
      : DateTime.parse(json['lastRead'] as String),
  timeSpentMs: (json['timeSpentMs'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ReadingPositionImplToJson(
  _$ReadingPositionImpl instance,
) => <String, dynamic>{
  'chapterId': instance.chapterId,
  'novelId': instance.novelId,
  'itemIndex': instance.itemIndex,
  'scrollOffset': instance.scrollOffset,
  'lastRead': instance.lastRead?.toIso8601String(),
  'timeSpentMs': instance.timeSpentMs,
};
