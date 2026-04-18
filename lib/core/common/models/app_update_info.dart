import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_info.freezed.dart';
part 'app_update_info.g.dart';

@freezed
class AppUpdateInfo with _$AppUpdateInfo {
  const factory AppUpdateInfo({
    required String tagName,
    required String changelog,
    required String downloadUrl,
    required String fileName,
    required int size,
    required DateTime publishedAt,
  }) = _AppUpdateInfo;

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) => _$AppUpdateInfoFromJson(json);
}
