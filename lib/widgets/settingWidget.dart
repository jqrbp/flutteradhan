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
  int methodIndex;
  int madhabIndex;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getSettingParams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SettingsList(
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile(
                        title: 'Worker Info',
                        subtitle: snapshot.data['workerLastRunDate'],
                        leading: Icon(Icons.work),
                        enabled: false,
                      ),
                      SettingsTile(
                        title: 'Metode Perhitungan',
                        subtitle: methodTitles[CalculationMethod
                                .values[snapshot.data['methodIndex']]] ??=
                            CalculationMethod
                                .values[snapshot.data['methodIndex']]
                                .toString(),
                        leading: Icon(Icons.calculate),
                        onPressed: (context) {
                          _onPressedMethodSelection(context);
                        },
                      ),
                      SettingsTile(
                        title: 'Mazhab',
                        subtitle: madhabTitles[
                                Madhab.values[snapshot.data['madhabIndex']]] ??=
                            Madhab.values[snapshot.data['madhabIndex']]
                                .toString(),
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
          }
          return Center(child: Text('Memuat Data'));
        });
  }

  Future<Map<String, dynamic>> _getSettingParams() async {
    final savedParams = await getSavedPrayerParams();
    final workerLastRunDate = await getWorkerLastRunDate();
    methodIndex = savedParams['prayerMethodIndex'];
    madhabIndex = savedParams['prayerMadhabIndex'];

    print(workerLastRunDate);
    return {
      'methodIndex': methodIndex,
      'madhabIndex': madhabIndex,
      'workerLastRunDate': workerLastRunDate
    };
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
    savePrayerParams(_methodIndex, _madhabIndex);
  }
}
