import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:adhan/adhan.dart';

class OptionWidget extends StatefulWidget {
  OptionWidget({Key key, this.titles, this.optionList}) : super(key: key);
  final titles;
  final optionList;
  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mazhab')),
      body: SettingsList(
        sections: [
          SettingsSection(
              tiles: widget.optionList.values.map((t) {
            return SettingsTile(
              title: widget.titles[t] ??= t.toString(),
              titleTextStyle: TextStyle(fontStyle: FontStyle.italic),
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
