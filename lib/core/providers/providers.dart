import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/network/dio_factory.dart';
import '../services/app_preferences.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioFactory.create();
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences();
});

final readerPreferencesProvider = Provider<ReaderPreferences>((ref) {
  return ReaderPreferences();
});

