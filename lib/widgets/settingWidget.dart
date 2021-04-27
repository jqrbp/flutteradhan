import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hive/hive.dart';
import 'package:adhan/adhan.dart';
import '../models/prayerParameterModel.dart';
import 'optionWidget.dart';
import '../models/idLocale.dart';

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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OptionWidget(titles: madhabTitles, optionList: Madhab)),
    );

    _writeSettingPrayerParams(methodIndex, result.index);
    setState(() {
      madhabIndex = result.index;
    });
  }

  _onPressedMethodSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OptionWidget(
              titles: methodTitles, optionList: CalculationMethod)),
    );

    _writeSettingPrayerParams(result.index, madhabIndex);
    setState(() {
      methodIndex = result.index;
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
