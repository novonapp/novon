import 'package:freezed_annotation/freezed_annotation.dart';

part 'repo_index.freezed.dart';
part 'repo_index.g.dart';

@freezed
class RepoIndex with _$RepoIndex {
  const factory RepoIndex({
    required String repoName,
    required String repoUrl,
    String? maintainerUrl,
    String? generated,
    required String apiVersion,
    String? publicKey,
    @Default([]) List<RepoExtensionEntry> extensions,
  }) = _RepoIndex;

  factory RepoIndex.fromJson(Map<String, dynamic> json) =>
      _$RepoIndexFromJson(json);
}

@freezed
class RepoExtensionEntry with _$RepoExtensionEntry {
  const factory RepoExtensionEntry({
    required String id,
    required String name,
    required String version,
    required String apiVersion,
    required String minAppVersion,
    required String lang,
    @Default(false) bool nsfw,
    @Default(false) bool hasCloudflare,
    @Default([]) List<String> categories,
    String? icon,
    required String downloadUrl,
    required String sha256,
    String? signature,
    String? changelog,
    String? updatedAt,
  }) = _RepoExtensionEntry;

  factory RepoExtensionEntry.fromJson(Map<String, dynamic> json) =>
      _$RepoExtensionEntryFromJson(json);
}
