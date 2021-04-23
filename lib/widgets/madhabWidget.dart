import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:adhan/adhan.dart';

class MadhabWidget extends StatefulWidget {
  MadhabWidget({Key key, this.titles}) : super(key: key);
  final titles;
  @override
  _MadhabWidgetState createState() => _MadhabWidgetState();
}

class _MadhabWidgetState extends State<MadhabWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Madhab')),
      body: SettingsList(
        sections: [
          SettingsSection(
              tiles: Madhab.values.map((t) {
            return SettingsTile(
              title: widget.titles[t] ??= t.toString(),
              // trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                Navigator.pop(context, t);
              },
            );
          }).toList()),
        ],
      ),
    );
  }
}
