import 'package:flutter/material.dart';
import 'package:novon/core/common/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/novon_colors.dart';

/// Guided diagnostic capture interface facilitating the formalization of
/// bug reports, feature requests, and community inquiries via
/// standardized metadata collection.
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  int _step = 1;
  String? _issueType;
  final _summaryController = TextEditingController();
  final _stepsController = TextEditingController();

  @override
  void dispose() {
    _summaryController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  /// Orchestrates the dispatch of a URI to the localized platform-native handler
  /// for external interaction.
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Issue')),
      body: _step == 1 ? _buildStep1() : _buildStep2(),
    );
  }

  Widget _buildStep1() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'What do you need help with?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 32),
        _IssueTypeCard(
          icon: Icons.bug_report,
          title: 'Bug Report',
          subtitle: 'Something isn\'t working correctly',
          onTap: () => _setTopic('bug'),
        ),
        _IssueTypeCard(
          icon: Icons.lightbulb,
          title: 'Feature Request',
          subtitle: 'Suggest an improvement',
          onTap: () => _setTopic('feature'),
        ),
        _IssueTypeCard(
          icon: Icons.extension,
          title: 'Extension Issue',
          subtitle: 'A source is broken',
          onTap: () => _setTopic('extension'),
        ),
        _IssueTypeCard(
          icon: Icons.help,
          title: 'General Question',
          subtitle: 'Not a bug, just need help',
          onTap: () => _setTopic('question'),
        ),
      ],
    );
  }

  /// Orchestrates the transition of the diagnostic workflow to the
  /// contextual data entry phase based on the appraisal of the selected topic.
  void _setTopic(String type) {
    setState(() {
      _issueType = type;
      _step = 2;
    });
  }

  Widget _buildStep2() {
    if (_issueType == 'question') {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: () => _openUrl(AppConstants.linkDocumentation),
              child: const Text('Read the Documentation'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _openUrl(AppConstants.linkDiscord),
              child: const Text('Join the Discord'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _summaryController,
          decoration: const InputDecoration(
            hintText: 'Short description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Steps to Reproduce',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: _stepsController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: '1. Go to...\n2. Tap on...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            final type = _issueType ?? 'bug';
            final title = Uri.encodeComponent(
              _summaryController.text.trim().isEmpty
                  ? '[${type.toUpperCase()}] '
                  : '[${type.toUpperCase()}] ${_summaryController.text.trim()}',
            );
            final body = Uri.encodeComponent(
              '### Type\n$type\n\n'
              '### Summary\n${_summaryController.text.trim()}\n\n'
              '### Steps to Reproduce\n${_stepsController.text.trim()}\n\n'
              '### Environment\n- App: Novon\n- Platform: Android\n',
            );
            _openUrl(
              'https://github.com/novonapp/novon/issues/new?title=$title&body=$body',
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: NovonColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Open in GitHub ->'),
        ),
      ],
    );
  }
}

/// Specialized navigational component used for orchestrating the selection
/// of specific diagnostic categories during the issue formalization workflow.
class _IssueTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _IssueTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: NovonColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
