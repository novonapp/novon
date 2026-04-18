import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/novon_colors.dart';
import '../providers/db_providers.dart';

/// Reactive navigation shell providing persistent bottom navigation orchestration 
/// across primary application branches, incorporating real-time update indicators.
class ShellScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadUpdatesCountProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: NovonColors.divider, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.collections_bookmark_outlined),
              selectedIcon: Icon(Icons.collections_bookmark),
              label: 'Library',
            ),
            NavigationDestination(
              icon: unread > 0
                  ? Badge(label: Text('$unread'), child: const Icon(Icons.update_outlined))
                  : const Icon(Icons.update_outlined),
              selectedIcon: unread > 0
                  ? Badge(label: Text('$unread'), child: const Icon(Icons.update))
                  : const Icon(Icons.update),
              label: 'Updates',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Browse',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
