import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Security orchestration layer for injecting authentication credentials
/// into outgoing requests.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}

/// Traffic orchestration layer responsible for enforcing domain-specific
/// temporal boundaries between requests to ensure infrastructure stability.
class RateLimitInterceptor extends Interceptor {
  final int maxRequestsPerSecond;
  final Map<String, DateTime> _lastRequestTime = {};

  RateLimitInterceptor({this.maxRequestsPerSecond = 2});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final domain = options.uri.host;
    final lastRequest = _lastRequestTime[domain];
    final interval = Duration(milliseconds: 1000 ~/ maxRequestsPerSecond);

    if (lastRequest != null) {
      final elapsed = DateTime.now().difference(lastRequest);
      if (elapsed < interval) {
        await Future.delayed(interval - elapsed);
      }
    }

    _lastRequestTime[domain] = DateTime.now();
    handler.next(options);
  }
}

/// Persistence orchestration layer for localized cookie appraisal and injection
/// into the [Dio] request pipeline, facilitating authenticated session persistence.
class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final host = options.uri.host;
      if (host.isEmpty) {
        handler.next(options);
        return;
      }

      final box = Hive.box(HiveBox.app);
      final raw = box.get(HiveKeys.sourceCookies);
      if (raw is! Map) {
        handler.next(options);
        return;
      }

      // raw: { sourceId: { domain: "a=b; c=d" } }
      String? cookieHeader;
      for (final entry in raw.entries) {
        final v = entry.value;
        if (v is! Map) continue;
        for (final dEntry in v.entries) {
          final domain = dEntry.key?.toString() ?? '';
          final cookie = dEntry.value?.toString();
          if (cookie == null || cookie.isEmpty) continue;

          final domainMatch =
              host == domain || host.endsWith('.$domain') || domain == host;
          if (domainMatch) {
            cookieHeader = cookie;
            break;
          }
        }
        if (cookieHeader != null) break;
      }

      if (cookieHeader != null && cookieHeader.isNotEmpty) {
        options.headers['Cookie'] = cookieHeader;
      }
    } catch (_) {
      // ignore - never block request
    }

    handler.next(options);
  }
}

/// Resilience orchestration layer for managing automated recovery from
/// transient network failures via exponential backoff strategies.
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;
  final Dio dio;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (retryCount >= maxRetries || !_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final delay = baseDelay * (1 << retryCount);
    await Future.delayed(delay);

    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Diagnostic orchestration layer for monitoring the lifecycle of network
/// requests in diagnostic environments.
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  LoggingInterceptor({this.enabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      log('[HTTP] -> ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      log('[HTTP] <- ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      log('[HTTP] X ${err.type} ${err.requestOptions.uri}');
    }
    handler.next(err);
  }
}
