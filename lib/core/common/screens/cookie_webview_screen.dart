import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../theme/novon_colors.dart';
import '../widgets/shimmer_loading.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

class CookieWebViewScreen extends StatefulWidget {
  final String sourceId;
  final String initialUrl;
  final List<String> domains;
  final bool enableCoverPicker;

  const CookieWebViewScreen({
    super.key,
    required this.sourceId,
    required this.initialUrl,
    required this.domains,
    this.enableCoverPicker = false,
  });

  @override
  State<CookieWebViewScreen> createState() => _CookieWebViewScreenState();
}

class _CookieWebViewScreenState extends State<CookieWebViewScreen> {
  InAppWebViewController? _controller;
  bool _saving = false;
  String _title = 'Browser';

  String? get _userAgent {
    final box = Hive.box(HiveBox.app);
    final ua = box.get(HiveKeys.globalUserAgent) as String?;
    if (ua == null) return null;
    final trimmed = ua.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _saveCookies() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final cm = CookieManager.instance();
      final box = Hive.box(HiveBox.app);
      final raw = box.get(HiveKeys.sourceCookies);
      final Map<String, dynamic> all = raw is Map
          ? Map<String, dynamic>.from(raw)
          : <String, dynamic>{};

      final Map<String, String> perDomain = {};
      for (final domain in widget.domains) {
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

      if (mounted && kDebugMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              perDomain.isEmpty
                  ? 'No cookies found to save'
                  : 'Saved cookies for ${perDomain.length} domain(s)',
            ),
            backgroundColor: perDomain.isEmpty
                ? NovonColors.warning
                : NovonColors.success,
          ),
        );
      }
    } catch (e) {
      log('[WEBVIEW] Failed to save cookies: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save cookies: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveAndClose() async {
    await _saveCookies();
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _pickCoverAndClose() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      final result = await controller.evaluateJavascript(
        source: '''
(() => {
  const fromMeta = document.querySelector('meta[property="og:image"],meta[name="og:image"],meta[property="twitter:image"],meta[name="twitter:image"]');
  if (fromMeta && fromMeta.content) return fromMeta.content;
  const fromKnown = document.querySelector('.seriestu img,.thumb img,.entry-content img,article img');
  if (fromKnown) return fromKnown.getAttribute('src') || '';
  return '';
})()
''',
      );
      final raw = (result ?? '').toString().trim();
      if (raw.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No cover found on this page')),
          );
        }
        return;
      }
      if (mounted) Navigator.of(context).pop(raw);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to extract cover: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _saveAndClose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            TextButton.icon(
              onPressed: _saving ? null : _saveAndClose,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Done'),
            ),
            IconButton(
              tooltip: 'Save cookies',
              onPressed: _saving ? null : _saveCookies,
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
            IconButton(
              tooltip: 'Reload',
              onPressed: () => _controller?.reload(),
              icon: const Icon(Icons.refresh_rounded),
            ),
            if (widget.enableCoverPicker)
              IconButton(
                tooltip: 'Use page cover',
                onPressed: _pickCoverAndClose,
                icon: const Icon(Icons.image_search_rounded),
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
            // auto-save after successful load stop (user can re-save anytime)
            await _saveCookies();
          },
        ),
      ),
    );
  }
}
