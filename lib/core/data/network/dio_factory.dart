import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'interceptors.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Centralized factory for the orchestration and configuration of the [Dio] 
/// HTTP client, maintaining standardized connection parameters and interceptor chains.
class DioFactory {
  DioFactory._();
  static String? get userAgent {
    final box = Hive.box(HiveBox.app);
    return box.get(HiveKeys.globalUserAgent) as String?;
  }

  /// Orchestrates the creation of a configured [Dio] instance with 
  /// standardized headers and a prioritized interceptor pipeline.
  static Dio create({
    String? baseUrl,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 30),
    Map<String, String>? headers,
    int maxRequestsPerSecond = 2,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'User-Agent':
              userAgent ??
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'none',
          'Sec-Fetch-Dest': 'document',
          ...?headers,
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      CookieInterceptor(),
      RateLimitInterceptor(maxRequestsPerSecond: maxRequestsPerSecond),
      if (kDebugMode) LoggingInterceptor(),
      RetryInterceptor(dio: dio),
    ]);

    return dio;
  }
}
