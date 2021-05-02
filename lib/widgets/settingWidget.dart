import 'package:flutter/material.dart';
import 'package:flutteradhan/utils/prayerTimesHelper.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:adhan/adhan.dart';
import 'optionWidget.dart';
import '../models/idLocale.dart';
import '../utils/workerManagerHelper.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  int methodIndex = 0;
  int madhabIndex = 0;
  String workerLastRunStr = '';

  Future<void> _initStateAsync() async {
    final savedParams = await getSavedPrayerParams();
    workerLastRunStr = await getWorkerLastRunDate();
    methodIndex = savedParams['prayerMethodIndex'];
    madhabIndex = savedParams['prayerMadhabIndex'];
  }

  @override
  void initState() {
    _initStateAsync().then((_) => setState((){}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile(
              title: 'Worker Info',
              subtitle: workerLastRunStr,
              leading: Icon(Icons.work),
              enabled: false,
            ),
            SettingsTile(
              title: 'Metode Perhitungan',
              subtitle: '"' + methodTitles[CalculationMethod.values[methodIndex]] + '"',
              leading: Icon(Icons.calculate),
              onPressed: (context) {
                _onPressedMethodSelection(context);
              },
            ),
            SettingsTile(
              title: 'Mazhab',
              subtitle: '"' + madhabTitles[Madhab.values[madhabIndex]] + '"',
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

    if (index == null || index == madhabIndex) return;
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

    if (index == null || index == methodIndex) return;
    _writeSettingPrayerParams(index, madhabIndex);
    setState(() {
      methodIndex = index;
    });
  }

  _writeSettingPrayerParams(int _methodIndex, int _madhabIndex) {
    savePrayerParams(_methodIndex, _madhabIndex);
  }
}
