// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepoIndexImpl _$$RepoIndexImplFromJson(Map<String, dynamic> json) =>
    _$RepoIndexImpl(
      repoName: json['repoName'] as String,
      repoUrl: json['repoUrl'] as String,
      maintainerUrl: json['maintainerUrl'] as String?,
      generated: json['generated'] as String?,
      apiVersion: json['apiVersion'] as String,
      publicKey: json['publicKey'] as String?,
      extensions:
          (json['extensions'] as List<dynamic>?)
              ?.map(
                (e) => RepoExtensionEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RepoIndexImplToJson(_$RepoIndexImpl instance) =>
    <String, dynamic>{
      'repoName': instance.repoName,
      'repoUrl': instance.repoUrl,
      'maintainerUrl': instance.maintainerUrl,
      'generated': instance.generated,
      'apiVersion': instance.apiVersion,
      'publicKey': instance.publicKey,
      'extensions': instance.extensions,
    };

_$RepoExtensionEntryImpl _$$RepoExtensionEntryImplFromJson(
  Map<String, dynamic> json,
) => _$RepoExtensionEntryImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  version: json['version'] as String,
  apiVersion: json['apiVersion'] as String,
  minAppVersion: json['minAppVersion'] as String,
  lang: json['lang'] as String,
  nsfw: json['nsfw'] as bool? ?? false,
  hasCloudflare: json['hasCloudflare'] as bool? ?? false,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  icon: json['icon'] as String?,
  downloadUrl: json['downloadUrl'] as String,
  sha256: json['sha256'] as String,
  signature: json['signature'] as String?,
  changelog: json['changelog'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$RepoExtensionEntryImplToJson(
  _$RepoExtensionEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'version': instance.version,
  'apiVersion': instance.apiVersion,
  'minAppVersion': instance.minAppVersion,
  'lang': instance.lang,
  'nsfw': instance.nsfw,
  'hasCloudflare': instance.hasCloudflare,
  'categories': instance.categories,
  'icon': instance.icon,
  'downloadUrl': instance.downloadUrl,
  'sha256': instance.sha256,
  'signature': instance.signature,
  'changelog': instance.changelog,
  'updatedAt': instance.updatedAt,
};
