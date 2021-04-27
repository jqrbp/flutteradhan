import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class OptionWidget extends StatefulWidget {
  OptionWidget({Key key, this.title, this.optionNames}) : super(key: key);
  final title;
  final List<String> optionNames;
  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SettingsList(
        sections: [
          SettingsSection(
              tiles: widget.optionNames.map((t) {
            return SettingsTile(
              title: t,
              titleTextStyle: TextStyle(fontStyle: FontStyle.italic),
              // trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                Navigator.pop(context, widget.optionNames.indexOf(t));
              },
            );
          }).toList()),
        ],
      ),
    );
  }
}
