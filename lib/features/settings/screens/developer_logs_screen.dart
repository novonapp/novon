import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/exception_logger_service.dart';
import '../../../core/theme/novon_colors.dart';

/// A diagnostic dashboard providing a centralized interface for inspecting, 
/// searching, and managing persistent exception records.
class DeveloperLogsScreen extends StatefulWidget {
  const DeveloperLogsScreen({super.key});

  @override
  State<DeveloperLogsScreen> createState() => _DeveloperLogsScreenState();
}

class _DeveloperLogsScreenState extends State<DeveloperLogsScreen> {
  List<ExceptionLogEntry> _logs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  /// Synchronizes the local state with the latest entries from the 
  /// persistent exception archival store.
  void _refreshLogs() {
    setState(() {
      _logs = ExceptionLoggerService.instance.readAll();
    });
  }

  List<ExceptionLogEntry> get _filteredLogs {
    if (_searchQuery.isEmpty) return _logs;
    final q = _searchQuery.toLowerCase();
    return _logs.where((l) {
      return l.message.toLowerCase().contains(q) ||
          l.errorType.toLowerCase().contains(q) ||
          l.stackSummary.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLogs;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Exception Logs'),
            actions: [
              IconButton(
                tooltip: 'Clear Logs',
                icon: const Icon(Icons.delete_sweep_rounded),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Logs?'),
                      content: const Text(
                        'This will permanently delete all stored exception logs.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: NovonColors.error,
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ExceptionLoggerService.instance.clearAll();
                    _refreshLogs();
                  }
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search logs...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: NovonColors.surfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            NovonColors.primary.withValues(alpha: 0.1),
                            NovonColors.primary.withValues(alpha: 0.02),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.checklist_rounded,
                        size: 32,
                        color: NovonColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _searchQuery.isEmpty
                          ? 'No logs found'
                          : 'No matching logs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: NovonColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => _LogTile(log: filtered[index]),
            ),
        ],
      ),
    );
  }
}

/// A specialized UI component for rendering individual diagnostic records, 
/// supporting hierarchical expansion for in-depth data inspection.
class _LogTile extends StatelessWidget {
  final ExceptionLogEntry log;

  const _LogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.yMMMd().add_jm().format(log.timestamp);

    return ExpansionTile(
      shape: const Border(), // Remove outline on expansion
      collapsedShape: const Border(),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        log.errorType,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              log.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: NovonColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(color: NovonColors.textTertiary, fontSize: 11),
            ),
          ],
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Stack Trace Summary:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text:
                        'Error: ${log.errorType}\nMessage: ${log.message}\nTime: ${log.timestamp}\n\nStack Trace:\n${log.stackSummary}',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Copied to clipboard'),
                    backgroundColor: NovonColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: NovonColors.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: NovonColors.border.withValues(alpha: 0.5),
            ),
          ),
          child: SelectableText(
            log.stackSummary.isEmpty
                ? 'No stack trace available'
                : log.stackSummary,
            style: GoogleFonts.firaCode(
              fontSize: 11,
              color: NovonColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
