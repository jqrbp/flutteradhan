import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'prayerTimesTileWidget.dart';
import '../models/prayerAlarmModel.dart';
import 'package:hive/hive.dart';

class PrayerTimesWidget extends StatefulWidget {
  PrayerTimesWidget(
      {Key key,
      this.coordinates,
      this.prayerTimes,
      this.refreshFunc,
      this.onPressedAlarmFunc})
      : super(key: key);

  final coordinates;
  final prayerTimes;
  final refreshFunc;
  final onPressedAlarmFunc;

  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  PrayerTimes prayerTimes;
  Coordinates coordinates;
  List<bool> alarmFlag = Prayer.values.map((v) {return false;}).toList();

  @override
  void initState() {
    prayerTimes = widget.prayerTimes;
    coordinates = widget.coordinates;
    setState(() {
      alarmFlag = Prayer.values.map((v) {return _getAlarmFlag(v.index);}).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.fajr,
          onFlag: alarmFlag[Prayer.fajr.index],
          onAlarmPressed: () => _onAlarmPressed(Prayer.fajr.index),
        ),
        ListTile(
          title: Text('Pagi'),
          subtitle: Text(
            DateFormat.jm().format(prayerTimes.sunrise),
          ),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.dhuhr,
          onFlag: alarmFlag[Prayer.dhuhr.index],
          onAlarmPressed: () => _onAlarmPressed(Prayer.dhuhr.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.asr,
          onFlag: alarmFlag[Prayer.asr.index],
          onAlarmPressed: () => _onAlarmPressed(Prayer.asr.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.maghrib,
          onFlag: alarmFlag[Prayer.maghrib.index],
          onAlarmPressed: () => _onAlarmPressed(Prayer.maghrib.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.isha,
          onFlag: alarmFlag[Prayer.isha.index],
          onAlarmPressed: () => _onAlarmPressed(Prayer.isha.index),
        ),
        ListTile(
          title: Text('Qiyam'),
          subtitle: Text(
            DateFormat.jm()
                .format(SunnahTimes(prayerTimes).lastThirdOfTheNight),
          ),
        ),
        ListTile(
          title: Text('Arah Kiblat'),
          subtitle: coordinates != null
              ? Text(
                  Qibla(coordinates).direction.toStringAsFixed(2),
                )
              : Text(''),
        ),
        ListTile(
          title: Text('Lokasi'),
          subtitle: coordinates != null
              ? Text(
                  coordinates.latitude.toStringAsFixed(5) +
                      ', ' +
                      coordinates.longitude.toStringAsFixed(5),
                )
              : Text(''),
          onTap: widget.refreshFunc,
        ),
      ],
    );
  }

  _onAlarmPressed(int index) {
    bool flag = !alarmFlag[index];
    _saveAlarmFlag(index, flag);
    setState(() {
      alarmFlag[index] = flag;
    });
  }

  _saveAlarmFlag(int index, bool flag) {
    Box<PrayerAlarm> _hiveBox = Hive.box<PrayerAlarm>('prayerAlarm');
    _hiveBox.put(
        index.toString(), PrayerAlarm(alarmFlag: flag, alarmIndex: index));
  }

  bool _getAlarmFlag(int index) {
    Box<PrayerAlarm> _hiveBox = Hive.box<PrayerAlarm>('prayerAlarm');
    PrayerAlarm alarm = _hiveBox.get(index.toString());

    if (alarm != null) {
      return alarm.alarmFlag;
    }
    _saveAlarmFlag(index, false);
    return false;
  }
}
