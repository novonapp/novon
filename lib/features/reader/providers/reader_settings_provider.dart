import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novon/core/common/constants/app_constants.dart';

final readerFontSizeProvider = StateProvider<double>(
  (ref) => AppConstants.defaultReaderFontSize,
);
final readerLineHeightProvider = StateProvider<double>(
  (ref) => AppConstants.defaultReaderLineHeight,
);
final readerFontFamilyProvider = StateProvider<String>(
  (ref) => AppConstants.defaultReaderFont,
);
