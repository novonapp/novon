import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_position.freezed.dart';
part 'reading_position.g.dart';

@freezed
abstract class ReadingPosition with _$ReadingPosition {
  const factory ReadingPosition({
    required String chapterId,
    required String novelId,
    @Default(0) int itemIndex,
    @Default(0.0) double scrollOffset,
    DateTime? lastRead,
    @Default(0) int timeSpentMs,
  }) = _ReadingPosition;

  factory ReadingPosition.fromJson(Map<String, dynamic> json) =>
      _$ReadingPositionFromJson(json);
}
