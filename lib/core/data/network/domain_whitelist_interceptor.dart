import 'package:dio/dio.dart';

/// Specialized exception representing a security interception event triggered 
/// by an unauthorized domain request.
class DomainNotAllowedException implements Exception {
  final String host;
  DomainNotAllowedException(this.host);

  @override
  String toString() => 'DomainNotAllowedException: $host is not allowed';
}

/// Security interception layer responsible for orchestrating domain appraisal 
/// and enforcing navigational boundaries based on an authorized whitelist.
class DomainWhitelistInterceptor extends Interceptor {
  final Set<String> _allowedDomains;

  DomainWhitelistInterceptor(List<String> allowedDomains)
      : _allowedDomains = allowedDomains.map((d) => d.toLowerCase()).toSet();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final host = Uri.parse(options.uri.toString()).host.toLowerCase();
    if (!_allowedDomains.contains(host)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: DomainNotAllowedException(host),
          type: DioExceptionType.cancel,
        ),
        true,
      );
      return;
    }
    handler.next(options);
  }
}
