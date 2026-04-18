// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUpdateInfoImpl _$$AppUpdateInfoImplFromJson(Map<String, dynamic> json) =>
    _$AppUpdateInfoImpl(
      tagName: json['tagName'] as String,
      changelog: json['changelog'] as String,
      downloadUrl: json['downloadUrl'] as String,
      fileName: json['fileName'] as String,
      size: (json['size'] as num).toInt(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$AppUpdateInfoImplToJson(_$AppUpdateInfoImpl instance) =>
    <String, dynamic>{
      'tagName': instance.tagName,
      'changelog': instance.changelog,
      'downloadUrl': instance.downloadUrl,
      'fileName': instance.fileName,
      'size': instance.size,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
