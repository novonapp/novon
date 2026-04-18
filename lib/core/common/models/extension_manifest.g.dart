// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtensionManifestImpl _$$ExtensionManifestImplFromJson(
  Map<String, dynamic> json,
) => _$ExtensionManifestImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  version: json['version'] as String,
  apiVersion: json['apiVersion'] as String,
  minAppVersion: json['minAppVersion'] as String,
  maxAppVersion: json['maxAppVersion'] as String?,
  lang: json['lang'] as String,
  baseUrl: json['baseUrl'] as String,
  domains: (json['domains'] as List<dynamic>).map((e) => e as String).toList(),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nsfw: json['nsfw'] as bool? ?? false,
  hasCloudflare: json['hasCloudflare'] as bool? ?? false,
  supportsLatest: json['supportsLatest'] as bool? ?? true,
  supportsSearch: json['supportsSearch'] as bool? ?? true,
  supportsFilters: json['supportsFilters'] as bool? ?? true,
  icon: json['icon'] as String? ?? 'icon.png',
  sha256: json['sha256'] as String,
  sourceUrl: json['sourceUrl'] as String,
  updateUrl: json['updateUrl'] as String,
  authorName: json['authorName'] as String?,
  authorUrl: json['authorUrl'] as String?,
  changelog: json['changelog'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$ExtensionManifestImplToJson(
  _$ExtensionManifestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'version': instance.version,
  'apiVersion': instance.apiVersion,
  'minAppVersion': instance.minAppVersion,
  'maxAppVersion': instance.maxAppVersion,
  'lang': instance.lang,
  'baseUrl': instance.baseUrl,
  'domains': instance.domains,
  'categories': instance.categories,
  'nsfw': instance.nsfw,
  'hasCloudflare': instance.hasCloudflare,
  'supportsLatest': instance.supportsLatest,
  'supportsSearch': instance.supportsSearch,
  'supportsFilters': instance.supportsFilters,
  'icon': instance.icon,
  'sha256': instance.sha256,
  'sourceUrl': instance.sourceUrl,
  'updateUrl': instance.updateUrl,
  'authorName': instance.authorName,
  'authorUrl': instance.authorUrl,
  'changelog': instance.changelog,
  'tags': instance.tags,
};
