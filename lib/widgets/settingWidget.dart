import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hive/hive.dart';
import 'package:adhan/adhan.dart';
import '../models/prayerParameterModel.dart';
import 'optionWidget.dart';
import '../models/idLocale.dart';
import '../utils/workerManagerHelper.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  int methodIndex;
  int madhabIndex;

  @override
  void initState() {
    super.initState();
    _checkSettingParameters();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile(
              title: 'Worker Info',
              subtitle: getTaskStatus(updatePrayerTimeTaskID).toString(),
              leading: Icon(Icons.calculate),
              onPressed: (context) {
                _onPressedMethodSelection(context);
              },
            ),
            SettingsTile(
              title: 'Metode Perhitungan',
              subtitle: methodTitles[CalculationMethod.values[methodIndex]] ??=
                  CalculationMethod.values[methodIndex].toString(),
              leading: Icon(Icons.calculate),
              onPressed: (context) {
                _onPressedMethodSelection(context);
              },
            ),
            SettingsTile(
              title: 'Mazhab',
              subtitle: madhabTitles[Madhab.values[madhabIndex]] ??=
                  Madhab.values[madhabIndex].toString(),
              leading: Icon(Icons.calculate),
              onPressed: (context) {
                _onPressedMadhabSelection(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  _onPressedMadhabSelection(BuildContext context) async {
    List<String> names = Madhab.values
        .map((t) => madhabTitles[t] == null ? t.toString() : madhabTitles[t])
        .toList();
    final index = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OptionWidget(title: 'Mazhab', optionNames: names)),
    );

    _writeSettingPrayerParams(methodIndex, index);
    setState(() {
      madhabIndex = index;
    });
  }

  _onPressedMethodSelection(BuildContext context) async {
    List<String> names = CalculationMethod.values
        .map((t) => methodTitles[t] == null ? t.toString() : methodTitles[t])
        .toList();
    final index = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OptionWidget(title: 'Metode Perhitungan', optionNames: names)),
    );

    _writeSettingPrayerParams(index, madhabIndex);
    setState(() {
      methodIndex = index;
    });
  }

  _writeSettingPrayerParams(int _methodIndex, int _madhabIndex) {
    Box<PrayerParameter> _hiveBox = Hive.box<PrayerParameter>('setting');
    _hiveBox.put("prayerParams",
        PrayerParameter(methodIndex: _methodIndex, madhabIndex: _madhabIndex));
  }

  _checkSettingParameters() {
    Box<PrayerParameter> _hiveBox = Hive.box<PrayerParameter>('setting');
    PrayerParameter param = _hiveBox.get("prayerParams");
    setState(() {
      methodIndex = param.methodIndex;
      madhabIndex = param.madhabIndex;
    });
  }
}
