import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreenTemplate extends ConsumerStatefulWidget {
  final String title;
  final String boxName;
  final List<Widget> Function(Box box, void Function(String, dynamic) update)
  buildSettings;

  const SettingsScreenTemplate({
    super.key,
    required this.title,
    required this.boxName,
    required this.buildSettings,
  });

  @override
  ConsumerState<SettingsScreenTemplate> createState() =>
      _SettingsScreenTemplateState();
}

class _SettingsScreenTemplateState
    extends ConsumerState<SettingsScreenTemplate> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box(widget.boxName);
  }

  void _update(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(children: widget.buildSettings(_box, _update)),
    );
  }
}
