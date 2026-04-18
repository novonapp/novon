import 'package:freezed_annotation/freezed_annotation.dart';

part 'extension_manifest.freezed.dart';
part 'extension_manifest.g.dart';

@freezed
class ExtensionManifest with _$ExtensionManifest {
  const factory ExtensionManifest({
    required String id,
    required String name,
    required String version,
    required String apiVersion,
    required String minAppVersion,
    String? maxAppVersion,
    required String lang,
    required String baseUrl,
    required List<String> domains,
    @Default([]) List<String> categories,
    @Default(false) bool nsfw,
    @Default(false) bool hasCloudflare,
    @Default(true) bool supportsLatest,
    @Default(true) bool supportsSearch,
    @Default(true) bool supportsFilters,
    @Default('icon.png') String icon,
    required String sha256,
    required String sourceUrl,
    required String updateUrl,
    String? authorName,
    String? authorUrl,
    String? changelog,
    @Default([]) List<String> tags,
  }) = _ExtensionManifest;

  factory ExtensionManifest.fromJson(Map<String, dynamic> json) =>
      _$ExtensionManifestFromJson(json);
}
