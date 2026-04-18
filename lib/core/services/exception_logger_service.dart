import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';
import '../common/constants/hive_constants.dart';

/// Data transfer object representing a unique diagnostic event, encompassing 
/// temporal metadata, error classification, and synthesized stack traces.
class ExceptionLogEntry {
  final String id;
  final DateTime timestamp;
  final String errorType;
  final String message;
  final String stackSummary;

  const ExceptionLogEntry({
    required this.id,
    required this.timestamp,
    required this.errorType,
    required this.message,
    required this.stackSummary,
  });

  Map<String, dynamic> toMap() => {
    HiveKeys.excId: id,
    HiveKeys.excTimestamp: timestamp.toIso8601String(),
    HiveKeys.excErrorType: errorType,
    HiveKeys.excMessage: message,
    HiveKeys.excStackSummary: stackSummary,
  };

  factory ExceptionLogEntry.fromMap(Map<dynamic, dynamic> map) =>
      ExceptionLogEntry(
        id: map[HiveKeys.excId]?.toString() ?? '',
        timestamp:
            DateTime.tryParse(map[HiveKeys.excTimestamp]?.toString() ?? '') ??
            DateTime.now(),
        errorType: map[HiveKeys.excErrorType]?.toString() ?? 'Unknown',
        message: map[HiveKeys.excMessage]?.toString() ?? '',
        stackSummary: map[HiveKeys.excStackSummary]?.toString() ?? '',
      );
}

/// Persistent diagnostic orchestration service, providing localized archival 
/// and lifecycle management for application-level exceptions.
///
/// Implements automated maintenance for expiring archival records and provides 
/// a centralized interface for diagnostic retrieval.
class ExceptionLoggerService {
  static final ExceptionLoggerService instance = ExceptionLoggerService._();
  ExceptionLoggerService._();

  static const int _maxLogAgeInDays = 14;

  /// Synthesizes a prioritized stack trace by filtering platform-native 
  /// internals and isolating project-specific execution frames.
  static String _extractUsefulStack(StackTrace? stackTrace) {
    if (stackTrace == null) return '';
    final lines = stackTrace.toString().split('\n');

    final projectLines = lines
        .where((l) {
          if (l.trim().isEmpty) return false;
          if (l.contains('package:flutter/') ||
              l.contains('package:flutter_riverpod/') ||
              l.startsWith('dart:') ||
              l.contains('package:async') ||
              l.contains('package:stack_trace')) {
            return false;
          }
          return true;
        })
        .take(5)
        .toList();

    if (projectLines.isEmpty) {
      return lines.take(5).join('\n');
    }
    return projectLines.join('\n');
  }

  /// Orchestrates the capture and localized persistence of an exception, 
  /// ensuring high-availability diagnostic logging without impacting runtime performance.
  void log(Object error, [StackTrace? stackTrace]) {
    try {
      if (!Hive.isBoxOpen(HiveBox.exceptions)) return;
      final box = Hive.box(HiveBox.exceptions);

      final entry = ExceptionLogEntry(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        timestamp: DateTime.now(),
        errorType: error.runtimeType.toString(),
        message: error.toString(),
        stackSummary: _extractUsefulStack(stackTrace),
      );

      box.put(entry.id, entry.toMap());
      developer.log(
        '[EXCEPTION LOGGER] ${entry.errorType}: ${entry.message}',
        name: 'ExceptionLoggerService',
        error: error,
        stackTrace: stackTrace,
      );
    } catch (e) {
      // Never let the logger itself crash the app.
      developer.log('[EXCEPTION LOGGER] Failed to persist log: $e');
    }
  }

  /// Retrieves the complete collection of diagnostic archival records, 
  /// ordered by temporal recency.
  List<ExceptionLogEntry> readAll() {
    if (!Hive.isBoxOpen(HiveBox.exceptions)) return const [];
    final box = Hive.box(HiveBox.exceptions);
    return box.values
        .whereType<Map>()
        .map((m) => ExceptionLogEntry.fromMap(m))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Orchestrates the decommissioning of diagnostic records exceeding the 
  /// defined saturation threshold.
  Future<void> pruneOldLogs() async {
    if (!Hive.isBoxOpen(HiveBox.exceptions)) return;
    final box = Hive.box(HiveBox.exceptions);
    final cutoff = DateTime.now().subtract(
      const Duration(days: _maxLogAgeInDays),
    );
    final toDelete = box.keys.where((k) {
      final raw = box.get(k);
      if (raw is! Map) return true; // malformed — remove
      final ts = DateTime.tryParse(raw[HiveKeys.excTimestamp]?.toString() ?? '');
      return ts == null || ts.isBefore(cutoff);
    }).toList();
    await box.deleteAll(toDelete);
    developer.log(
      '[EXCEPTION LOGGER] Pruned ${toDelete.length} old log entries.',
    );
  }

  /// Purges all diagnostic archival records from persistent storage.
  Future<void> clearAll() async {
    if (!Hive.isBoxOpen(HiveBox.exceptions)) return;
    await Hive.box(HiveBox.exceptions).clear();
  }
}
