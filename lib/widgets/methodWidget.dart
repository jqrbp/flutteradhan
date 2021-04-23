import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:adhan/adhan.dart';

class MethodWidget extends StatefulWidget {
  MethodWidget({Key key, this.titles}) : super(key: key);
  final titles;
  @override
  _MethodWidgetState createState() => _MethodWidgetState();
}

class _MethodWidgetState extends State<MethodWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Method')),
      body: SettingsList(
        sections: [
          SettingsSection(
              tiles: CalculationMethod.values.map((t) {
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
