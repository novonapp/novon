// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourceInfoImpl _$$SourceInfoImplFromJson(Map<String, dynamic> json) =>
    _$SourceInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      lang: json['lang'] as String? ?? 'en',
      isInstalled: json['isInstalled'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
      isNsfw: json['isNsfw'] as bool? ?? false,
      iconUrl: json['iconUrl'] as String? ?? '',
      domains:
          (json['domains'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SourceInfoImplToJson(_$SourceInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'lang': instance.lang,
      'isInstalled': instance.isInstalled,
      'isEnabled': instance.isEnabled,
      'isNsfw': instance.isNsfw,
      'iconUrl': instance.iconUrl,
      'domains': instance.domains,
    };
