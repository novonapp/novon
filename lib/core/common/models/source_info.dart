import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_info.freezed.dart';
part 'source_info.g.dart';

@freezed
abstract class SourceInfo with _$SourceInfo {
  const factory SourceInfo({
    required String id,
    required String name,
    required String version,
    @Default('en') String lang,
    @Default(false) bool isInstalled,
    @Default(true) bool isEnabled,
    @Default(false) bool isNsfw,
    @Default('') String iconUrl,
    @Default([]) List<String> domains,
  }) = _SourceInfo;

  factory SourceInfo.fromJson(Map<String, dynamic> json) =>
      _$SourceInfoFromJson(json);
}
