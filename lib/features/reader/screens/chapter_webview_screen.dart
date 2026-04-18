import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/providers/extension_provider.dart';
import '../../../core/common/widgets/shimmer_loading.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

class ChapterWebViewScreen extends ConsumerStatefulWidget {
  final String sourceId;
  final String initialUrl;

  const ChapterWebViewScreen({
    super.key,
    required this.sourceId,
    required this.initialUrl,
  });

  @override
  ConsumerState<ChapterWebViewScreen> createState() =>
      _ChapterWebViewScreenState();
}

class _ChapterWebViewScreenState extends ConsumerState<ChapterWebViewScreen> {
  InAppWebViewController? _controller;
  bool _saving = false;
  String _title = 'Chapter Preview';

  String? get _userAgent {
    final box = Hive.box(HiveBox.app);
    final ua = box.get(HiveKeys.globalUserAgent) as String?;
    if (ua == null) return null;
    final trimmed = ua.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _saveCookies(List<String> domains) async {
    if (_saving || domains.isEmpty) return;
    setState(() => _saving = true);
    try {
      final cm = CookieManager.instance();
      final box = Hive.box(HiveBox.app);
      final raw = box.get(HiveKeys.sourceCookies);
      final Map<String, dynamic> all = raw is Map
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{};

      final Map<String, String> perDomain = {};
      for (final domain in domains) {
        if (domain.trim().isEmpty) continue;
        final url = WebUri('https://$domain/');
        final cookies = await cm.getCookies(url: url);
        if (cookies.isEmpty) continue;
        final cookieHeader = cookies
            .where((c) => c.name.isNotEmpty)
            .map((c) => '${c.name}=${c.value}')
            .join('; ');
        if (cookieHeader.isNotEmpty) {
          perDomain[domain] = cookieHeader;
        }
      }

      all[widget.sourceId] = perDomain;
      await box.put(HiveKeys.sourceCookies, all);

      log('[CHAPTER_WEBVIEW] Cookies saved for ${perDomain.length} domains');
    } catch (e) {
      log('[CHAPTER_WEBVIEW] Failed to save cookies: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final installed = ref.watch(installedExtensionsProvider);
    final manifest = installed.whenOrNull(
      data: (list) => list.firstWhere((m) => m.id == widget.sourceId),
    );
    final domains = manifest?.domains ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: () => _controller?.reload(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Save cookies',
            onPressed: _saving ? null : () => _saveCookies(domains),
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: ShimmerLoading(
                      width: 18,
                      height: 18,
                      borderRadius: 999,
                    ),
                  )
                : const Icon(Icons.vpn_key_rounded),
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          clearCache: false,
          userAgent: _userAgent,
          thirdPartyCookiesEnabled: true,
          useHybridComposition: true,
        ),
        onWebViewCreated: (controller) => _controller = controller,
        onTitleChanged: (controller, title) {
          if (title != null && mounted) setState(() => _title = title);
        },
        onLoadStop: (controller, url) async {
          await _saveCookies(domains);
        },
      ),
    );
  }
}
