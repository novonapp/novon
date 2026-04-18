import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/network/dio_factory.dart';
import 'package:novon/core/common/constants/engine_constants.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Primary execution environment for modular extensions, facilitating secure
/// JavaScript runtime isolation and bidirectional bridge communication.
///
/// Orchestrates the lifecycle of extension runtimes, coordinates network requests
/// via a specialized [Dio] layer, and provides a standardized interface for
/// catalog discovery and content retrieval.
class ExtensionEngine {
  static final ExtensionEngine instance = ExtensionEngine._();
  ExtensionEngine._();

  Dio? _dioInternal;

  Dio get _dio {
    final box = Hive.box(HiveBox.app);
    final userAgent = box.get(HiveKeys.globalUserAgent) as String?;

    if (_dioInternal != null) {
      final currentUa = _dioInternal!.options.headers['User-Agent'];
      if (currentUa == userAgent || (userAgent == null && currentUa != null)) {
        return _dioInternal!;
      }
    }

    log('[ENGINE] Creating/Updating Dio with User-Agent: $userAgent');
    return _dioInternal = DioFactory.create(
      headers: userAgent == null || userAgent.trim().isEmpty
          ? null
          : {'User-Agent': userAgent.trim()},
    );
  }

  String? _htmlParserPlugin;

  final Map<String, JavascriptRuntime> _runtimes = {};
  final Map<String, Completer<dynamic>> _pendingCalls = {};
  final Map<String, String> _bridgeDataCache = {};
  int _callCounter = 0;

  static const List<String> _requiredMethods = EngineConstants.requiredMethods;

  /// Ensures the availability of critical platform-native JS plugins, such as
  /// the HTML parser, before runtime initialization.
  Future<void> _ensurePlugins() async {
    _htmlParserPlugin ??= await rootBundle.loadString(
      EngineConstants.htmlParserAsset,
    );
  }

  /// Orchestrates the creation and configuration of a new [JavascriptRuntime]
  /// for a specific extension, including the injection of polyfills and bridges.
  Future<JavascriptRuntime> _getRuntime(
    String extensionId,
    String scriptSource,
  ) async {
    if (_runtimes.containsKey(extensionId)) {
      return _runtimes[extensionId]!;
    }

    await _ensurePlugins();
    log('[ENGINE] Initializing new runtime for: $extensionId');

    final JavascriptRuntime rt = getJavascriptRuntime();
    rt.enableHandlePromises();

    /// Parses and sanitizes arguments received via the bridge communication channels.
    Map<String, dynamic> parseBridgeArgs(dynamic args, String channel) {
      try {
        log('[BRIDGE] Raw $channel args: $args (type: ${args.runtimeType})');
        if (args == null) return {};
        if (args is Map) return Map<String, dynamic>.from(args);
        final str = args.toString();
        if (str.contains('[object Object]')) {
          log('[BRIDGE] Warning: Received stringified object instead of JSON');
          return {};
        }
        if (!str.startsWith('{') && !str.startsWith('[')) {
          return {'id': str};
        }
        return Map<String, dynamic>.from(jsonDecode(str));
      } catch (e) {
        log('[BRIDGE] Error parsing $channel args: $e');
        return {};
      }
    }

    // Injects essential polyfills to ensure environment compatibility with
    // common browser-native APIs.
    rt.evaluate(r'''
      (function() {
        var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

        globalThis.btoa = function(input) {
          var str = String(input);
          var output = '';
          for (var block, charCode, idx = 0, map = chars;
               str.charAt(idx | 0) || (map = '=', idx % 1);
               output += map.charAt(63 & block >> 8 - idx % 1 * 8)) {
            charCode = str.charCodeAt(idx += 3/4);
            if (charCode > 0xFF) throw new Error("'btoa' failed: The string contains characters outside of the Latin1 range.");
            block = block << 8 | charCode;
          }
          return output;
        };

        globalThis.atob = function(input) {
          var str = String(input).replace(/[=]+$/, '');
          if (str.length % 4 === 1) throw new Error("'atob' failed: The string to be decoded is not correctly encoded.");
          var output = '';
          for (var bc = 0, bs = 0, buffer, idx = 0;
               buffer = str.charAt(idx++);
               ~buffer && (bs = bc % 4 ? bs * 64 + buffer : buffer, bc++ % 4)
                 ? output += String.fromCharCode(255 & bs >> (-2 * bc & 6))
                 : 0) {
            buffer = chars.indexOf(buffer);
          }
          return output;
        };

        if (typeof globalThis.TextEncoder === 'undefined') {
          globalThis.TextEncoder = function TextEncoder() {};
          globalThis.TextEncoder.prototype.encode = function(str) {
            var buf = [];
            for (var i = 0; i < str.length; i++) {
              var c = str.charCodeAt(i);
              if (c < 0x80) {
                buf.push(c);
              } else if (c < 0x800) {
                buf.push(0xc0 | (c >> 6), 0x80 | (c & 0x3f));
              } else {
                buf.push(0xe0 | (c >> 12), 0x80 | ((c >> 6) & 0x3f), 0x80 | (c & 0x3f));
              }
            }
            return new Uint8Array(buf);
          };
        }

        if (typeof globalThis.TextDecoder === 'undefined') {
          globalThis.TextDecoder = function TextDecoder() {};
          globalThis.TextDecoder.prototype.decode = function(buf) {
            var str = '';
            var arr = buf instanceof Uint8Array ? buf : new Uint8Array(buf);
            for (var i = 0; i < arr.length; i++) {
              str += String.fromCharCode(arr[i]);
            }
            return str;
          };
        }

        if (typeof Array.from === 'undefined') {
          Array.from = function(iterable) {
            if (!iterable) return [];
            var arr = [];
            var len = iterable.length;
            if (typeof len === 'number') {
              for (var i = 0; i < len; i++) arr.push(iterable[i]);
              return arr;
            }
            try {
              var it = iterable[Symbol.iterator] && iterable[Symbol.iterator]();
              if (it && typeof it.next === 'function') {
                var step;
                while (!(step = it.next()).done) arr.push(step.value);
              }
            } catch (_) {}
            return arr;
          };
        }

        if (typeof Object.hasOwn !== 'function') {
          Object.hasOwn = function(obj, prop) {
            return Object.prototype.hasOwnProperty.call(obj, prop);
          };
        }
      })();
    ''');

    // Injects the specialized HTML parsing layer and applies navigational
    // utility patches for document traversal.
    final parserResult = rt.evaluate(_htmlParserPlugin!);
    log(
      '[ENGINE] HTML Parser Eval Result: isError = ${parserResult.isError}, stringResult = ${parserResult.stringResult}',
    );

    rt.evaluate(r'''
      (function() {
        const _origParseHtml = globalThis.parseHtml;
        globalThis.parseHtml = function(html) {
          const doc = _origParseHtml(html);

          function patchNode(node) {
            if (!node || node.__novonPatched) return;
            try { node.__novonPatched = true; } catch (_) {}

            if (typeof node.attr !== 'function') {
              try {
                node.attr = function(name) {
                  if (!name) return null;
                  if (typeof this.getAttribute === 'function') {
                    try { return this.getAttribute(name); } catch (_) {}
                  }
                  if (this.attribs && this.attribs[name] != null) return this.attribs[name];
                  if (this.attributes && this.attributes[name] != null) return this.attributes[name];
                  return null;
                };
              } catch (_) {}
            }

            try {
              if (!('text' in node)) {
                Object.defineProperty(node, 'text', {
                  configurable: true,
                  enumerable: false,
                  get: function() {
                    if (typeof this.textContent === 'string') return this.textContent;
                    if (typeof this.innerText === 'string') return this.innerText;
                    if (typeof this.data === 'string') return this.data;
                    return String(this.textContent || this.innerText || this.data || '');
                  }
                });
              }
            } catch (_) {}

            wrapQuerySelector(node);
            wrapQuerySelectorAll(node);
          }

          function wrapQuerySelector(node) {
            if (!node || typeof node.querySelector !== 'function' || node.__novonWrapQS) return;
            node.__novonWrapQS = true;
            const orig = node.querySelector.bind(node);
            node.querySelector = function(sel) {
              const res = orig(sel);
              patchNode(res);
              return res;
            };
          }

          function normalizeToArray(res) {
            if (!res) return [];
            if (Array.isArray(res)) return res;
            try { return Array.from(res); } catch (_) {}
            if (typeof res.length === 'number') {
              const out = [];
              for (let i = 0; i < res.length; i++) out.push(res[i]);
              return out;
            }
            return [];
          }

          function wrapQuerySelectorAll(node) {
            if (!node || typeof node.querySelectorAll !== 'function' || node.__novonWrapQSA) return;
            node.__novonWrapQSA = true;
            const orig = node.querySelectorAll.bind(node);
            node.querySelectorAll = function(sel) {
              const res = normalizeToArray(orig(sel));
              for (let i = 0; i < res.length; i++) patchNode(res[i]);
              return res;
            };
          }

          patchNode(doc);
          return doc;
        };
      })();
    ''');

    // Establishes the asynchronous HTTP bridge, permitting extensions to
    // perform network requests via the host's specialized network layer.
    rt.onMessage('http_get', (dynamic args) async {
      final startTime = DateTime.now();
      String callbackId = '';
      String url = '';
      try {
        final req = parseBridgeArgs(args, 'http_get');
        callbackId = req['id']?.toString() ?? '';
        url = req['url'] ?? '';

        if (url.isEmpty) throw Exception('Empty URL in http_get');

        log('[BRIDGE] http.get [$callbackId] -> $url');

        final response = await _dio.get<String>(
          url,
          options: Options(responseType: ResponseType.plain),
        );

        final duration = DateTime.now().difference(startTime).inMilliseconds;
        log(
          '[BRIDGE] http.get [$callbackId] resolved in ${duration}ms (size: ${response.data?.length ?? 0})',
        );

        _bridgeDataCache[callbackId] = response.data ?? '';
        rt.evaluate('__httpResolve("$callbackId");');
        rt.executePendingJob();
      } catch (e) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        log('[BRIDGE] http.get error [$callbackId] after ${duration}ms: $e');
        final encodedError = jsonEncode(e.toString());
        if (callbackId.isNotEmpty) {
          rt.evaluate('__httpReject("$callbackId", $encodedError);');
          rt.executePendingJob();
        }
      }
    });

    rt.onMessage('get_bridge_data', (dynamic args) {
      final id = args.toString();
      return _bridgeDataCache.remove(id) ?? '';
    });

    rt.onMessage('console_log', (dynamic args) {
      final msg = args is String ? args : args.toString();
      log('[JS] $msg');
    });

    // Establishes the result synchronization bridge for orchestrating complex
    // asynchronous method calls.
    rt.onMessage('method_result', (dynamic args) {
      try {
        final res = parseBridgeArgs(args, 'method_result');
        final String id = res['id']?.toString() ?? '';
        final duration = res['duration'] ?? 0;
        log('[ENGINE] method_result received for id: $id in ${duration}ms');

        final completer = _pendingCalls.remove(id);
        if (completer == null) {
          log('[ENGINE] Warning: no pending call found for id: $id');
          return;
        }

        if (res['ok'] == true) {
          completer.complete(res['data']);
        } else {
          completer.completeError(
            Exception(res['error']?.toString() ?? 'Unknown JS error'),
          );
        }
      } catch (e) {
        log('[ENGINE] method_result parse error: $e');
      }
    });

    // Injects the core bridge glue and global namespaces (http, console, etc.)
    // into the JavaScript environment.
    rt.evaluate(r'''
      (function() {
        var __httpPending = {};
        var __httpCounter = 0;

        globalThis.__httpResolve = function(id) {
          if (__httpPending[id]) {
            var data = sendMessage('get_bridge_data', id);
            __httpPending[id].resolve(data);
            delete __httpPending[id];
          }
        };

        globalThis.__httpReject = function(id, err) {
          if (__httpPending[id]) {
            __httpPending[id].reject(new Error(err));
            delete __httpPending[id];
          }
        };

        globalThis.http = {
          get: function(url) {
            return new Promise(function(resolve, reject) {
              var id = String(++__httpCounter);
              __httpPending[id] = { resolve: resolve, reject: reject };
              sendMessage('http_get', JSON.stringify({ id: id, url: url }));
            });
          }
        };

        globalThis.console = {
          log: function() {
            var parts = [];
            for (var i = 0; i < arguments.length; i++) {
              parts.push(typeof arguments[i] === 'object'
                ? JSON.stringify(arguments[i]) : String(arguments[i]));
            }
            sendMessage('console_log', JSON.stringify(parts.join(' ')));
          },
          error: function() {
            var parts = ['ERROR:'];
            for (var i = 0; i < arguments.length; i++) {
              parts.push(typeof arguments[i] === 'object'
                ? JSON.stringify(arguments[i]) : String(arguments[i]));
            }
            sendMessage('console_log', JSON.stringify(parts.join(' ')));
          },
          warn: function() {
            var parts = ['WARN:'];
            for (var i = 0; i < arguments.length; i++) {
              parts.push(typeof arguments[i] === 'object'
                ? JSON.stringify(arguments[i]) : String(arguments[i]));
            }
            sendMessage('console_log', JSON.stringify(parts.join(' ')));
          }
        };

        globalThis.__novonExtension = {};

        globalThis.__callMethod = async function(callId, methodName, argsJson) {
          console.log('[JS] __callMethod started: ' + methodName + ' id=' + callId);
          var start = Date.now();

          function sendResult(ok, data, error) {
            try {
              var payload = JSON.stringify({
                id: callId,
                ok: ok,
                data: data,
                error: error,
                duration: Date.now() - start
              });
              sendMessage('method_result', payload);
            } catch (e) {
              sendMessage('method_result', JSON.stringify({
                id: callId,
                ok: false,
                error: 'Serialization failed: ' + String(e),
                duration: Date.now() - start
              }));
            }
          }

          try {
            var args = JSON.parse(argsJson);
            var fn = globalThis.__novonExtension[methodName];

            if (typeof fn !== 'function') {
              throw new Error('Method "' + methodName + '" is not registered');
            }

            console.log('[JS] Calling ' + methodName);
            var result = await fn.apply(null, args);
            console.log('[JS] ' + methodName + ' completed successfully');
            sendResult(true, result);
          } catch (e) {
            try {
              console.error(
                '[JS] Error in ' + methodName + ':',
                String(e),
                (e && e.stack) ? ('\n' + String(e.stack)) : ''
              );
            } catch (_) {
              console.error('[JS] Error in ' + methodName + ':', String(e));
            }
            sendResult(false, null, (e && (e.stack || e.message)) ? String(e.stack || e.message) : String(e));
          }
        };
      })();
    ''');

    // Performs a final integrity check on the internal bridge state.
    final bridgeCheck = rt.evaluate('typeof globalThis.__novonExtension');
    log(
      '[ENGINE] Bridge check: __novonExtension is ${bridgeCheck.stringResult}',
    );

    // Evaluates the extension's primary script source within the isolated runtime.
    log('[ENGINE] scriptSource length: ${scriptSource.length}');

    final evalStr =
        '''
      try {
        const parseHtml = globalThis.parseHtml;
        const http = globalThis.http;
        const console = globalThis.console;
        globalThis.__evalMark1 = true;
        $scriptSource
        globalThis.__evalMark2 = true;
      } catch (e) {
        if (globalThis.console) {
          globalThis.console.error('EXTENSION EVAL ERROR:', e && e.message, e && e.stack);
        }
      }
    ''';

    final extResult = rt.evaluate(evalStr);
    final mark1 = rt.evaluate('globalThis.__evalMark1');
    final mark2 = rt.evaluate('globalThis.__evalMark2');
    log(
      '[ENGINE] Extension Eval mark1=${mark1.stringResult}, mark2=${mark2.stringResult}, resultError=${extResult.isError}',
    );

    // Orchestrates the registration of contractual methods onto the
    // internal bridge namespace.
    for (final method in _requiredMethods) {
      final res = rt.evaluate(
        '(function() {'
        '  try {'
        '    var fn = globalThis["$method"];'
        '    if (typeof fn === "function") {'
        '      globalThis.__novonExtension["$method"] = fn;'
        '      return "OK";'
        '    }'
        '    return "NOT_FOUND:" + (typeof fn);'
        '  } catch(e) {'
        '    return "ERROR:" + e.message;'
        '  }'
        '})();',
      );
      log('[ENGINE] Registration: $method -> ${res.stringResult}');
    }

    // Verifies the successful registration of all required methods.
    for (final method in _requiredMethods) {
      _checkMethodExistence(rt, extensionId, method);
    }

    _runtimes[extensionId] = rt;
    log('[ENGINE] Runtime ready for: $extensionId');
    return rt;
  }

  /// Appraises the existence of a specific method within the extension's runtime.
  void _checkMethodExistence(
    JavascriptRuntime rt,
    String extensionId,
    String method,
  ) {
    try {
      final exists = rt.evaluate(
        '(typeof globalThis.__novonExtension["$method"] === "function")',
      );
      if (exists.stringResult != 'true') {
        log(
          '[ENGINE] Warning: $method not registered in $extensionId. It may cause timeouts.',
        );
      } else {
        log('[ENGINE] Verified: $method registered in $extensionId');
      }
    } catch (e) {
      log('[ENGINE] Error checking existence of $method: $e');
    }
  }

  Future<dynamic> fetchPopular(
    String extensionId,
    String scriptSource,
    int page,
  ) => _callMethod(
    extensionId,
    scriptSource,
    EngineConstants.methodFetchPopular,
    [page],
  );

  Future<dynamic> fetchLatestUpdates(
    String extensionId,
    String scriptSource,
    int page,
  ) => _callMethod(
    extensionId,
    scriptSource,
    EngineConstants.methodFetchLatestUpdates,
    [page],
  );

  Future<dynamic> search(
    String extensionId,
    String scriptSource,
    String query,
    int page,
  ) => _callMethod(extensionId, scriptSource, EngineConstants.methodSearch, [
    query,
    page,
  ]);

  Future<dynamic> fetchNovelDetail(
    String extensionId,
    String scriptSource,
    String novelUrl,
  ) => _callMethod(
    extensionId,
    scriptSource,
    EngineConstants.methodFetchNovelDetail,
    [novelUrl],
  );

  Future<dynamic> fetchChapterList(
    String extensionId,
    String scriptSource,
    String novelUrl,
  ) => _callMethod(
    extensionId,
    scriptSource,
    EngineConstants.methodFetchChapterList,
    [novelUrl],
  );

  Future<dynamic> fetchChapterContent(
    String extensionId,
    String scriptSource,
    String chapterUrl,
  ) => _callMethod(
    extensionId,
    scriptSource,
    EngineConstants.methodFetchChapterContent,
    [chapterUrl],
  );

  /// Primary internal dispatcher for orchestrating asynchronous method
  /// execution between the host environment and the extension runtime.
  Future<dynamic> _callMethod(
    String extensionId,
    String scriptSource,
    String method,
    List<dynamic> args,
  ) async {
    final rt = await _getRuntime(extensionId, scriptSource);

    final callId = '${method}_${++_callCounter}';
    final completer = Completer<dynamic>();
    _pendingCalls[callId] = completer;

    final argsJson = jsonEncode(args);
    final safeArgsJson = jsonEncode(argsJson);

    rt.evaluate('__callMethod("$callId", "$method", $safeArgsJson);');
    rt.executePendingJob();
    log('[ENGINE] Waiting for $method [$callId] on $extensionId');

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        _pendingCalls.remove(callId);
        log('[ENGINE] Timeout: $method [$callId] on $extensionId');
        throw TimeoutException(
          '$method timed out after 30s',
          const Duration(seconds: 30),
        );
      },
    );
  }

  /// Decommissions a specific extension runtime and invalidates all pending calls.
  void disposeExtension(String extensionId) {
    final rt = _runtimes.remove(extensionId);
    if (rt != null) {
      log('[ENGINE] Disposing runtime for: $extensionId');
      rt.dispose();
    }
    _pendingCalls.removeWhere((key, completer) {
      if (key.contains(extensionId)) {
        completer.completeError(Exception('Extension uninstalled'));
        return true;
      }
      return false;
    });
  }

  /// Decommissions all active extension runtimes and forcefully invalidates
  /// the pending call stack.
  void disposeAll() {
    for (final entry in _runtimes.entries) {
      log('[ENGINE] Disposing runtime for: ${entry.key}');
      entry.value.dispose();
    }
    _runtimes.clear();
    for (final completer in _pendingCalls.values) {
      completer.completeError(Exception('Engine disposed'));
    }
    _pendingCalls.clear();
  }
}
