import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'prayerTimesTileWidget.dart';
import '../models/prayerAlarmModel.dart';
import 'package:hive/hive.dart';
import '../utils/notificationHelper.dart';
import '../main.dart';
import '../models/idLocale.dart';
import '../utils/locationHelper.dart';
import '../utils/prayerTimesHelper.dart';

class PrayerTimesWidget extends StatefulWidget {
  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  PrayerTimes _prayerTimes;
  Coordinates _myCoordinates;
  TextEditingController _latitudeText = TextEditingController();
  TextEditingController _longitudeText = TextEditingController();
  List<bool> alarmFlag = Prayer.values.map((v) {
    return false;
  }).toList();

  @override
  void initState() {
    setState(() {
      _myCoordinates = getSavedCoordinates();
      _prayerTimes = PrayerTimes.today(_myCoordinates, getPrayerParams());
      _latitudeText.text = _myCoordinates.latitude.toString();
      _longitudeText.text = _myCoordinates.longitude.toString();
      alarmFlag = Prayer.values.map((v) {
        return _getAlarmFlag(v.index);
      }).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            _getHijriFullDate(),
          ),
        ),
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: () => _refreshFunc(),
          ),
          title: Text('Lokasi & Arah Kiblat'),
          subtitle: _myCoordinates != null
              ? Text(
                  _myCoordinates.latitude.toStringAsFixed(5) +
                      ', ' +
                      _myCoordinates.longitude.toStringAsFixed(5) +
                      '\n(' +
                      Qibla(_myCoordinates).direction.toStringAsFixed(2) +
                      ' Derajat)',
                )
              : Text(''),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _onPressedEditLocation(),
          ),
        ),
        PrayerTimesTileWidget(
          prayerTimes: _prayerTimes,
          prayer: Prayer.fajr,
          onFlag: alarmFlag[Prayer.fajr.index],
          onAlarmPressed: () =>
              _onAlarmPressed(Prayer.fajr.index, _prayerTimes.fajr),
        ),
        ListTile(
          title: Text('Terbit'),
          subtitle: Text(
            DateFormat.jm().format(_prayerTimes.sunrise),
          ),
        ),
        PrayerTimesTileWidget(
          prayerTimes: _prayerTimes,
          prayer: Prayer.dhuhr,
          onFlag: alarmFlag[Prayer.dhuhr.index],
          onAlarmPressed: () =>
              _onAlarmPressed(Prayer.dhuhr.index, _prayerTimes.dhuhr),
        ),
        PrayerTimesTileWidget(
          prayerTimes: _prayerTimes,
          prayer: Prayer.asr,
          onFlag: alarmFlag[Prayer.asr.index],
          onAlarmPressed: () =>
              _onAlarmPressed(Prayer.asr.index, _prayerTimes.asr),
        ),
        PrayerTimesTileWidget(
          prayerTimes: _prayerTimes,
          prayer: Prayer.maghrib,
          onFlag: alarmFlag[Prayer.maghrib.index],
          onAlarmPressed: () =>
              _onAlarmPressed(Prayer.maghrib.index, _prayerTimes.maghrib),
        ),
        PrayerTimesTileWidget(
          prayerTimes: _prayerTimes,
          prayer: Prayer.isha,
          onFlag: alarmFlag[Prayer.isha.index],
          onAlarmPressed: () =>
              _onAlarmPressed(Prayer.isha.index, _prayerTimes.isha),
        ),
        ListTile(
          title: Text('Qiyam'),
          subtitle: Text(
            DateFormat.jm()
                .format(SunnahTimes(_prayerTimes).lastThirdOfTheNight),
          ),
        ),
      ],
    );
  }

  _onPressedEditLocation() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
          title: Text('Set Lokasi'),
          contentPadding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            TextField(
                decoration: InputDecoration(
                  hintText: "Latitude",
                  labelText: "Latitude",
                ),
                controller: _latitudeText),
            TextField(
                decoration: InputDecoration(
                  hintText: "Longitude",
                  labelText: "Longitude",
                ),
                controller: _longitudeText),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                var latitude = double.tryParse(_latitudeText.text);
                var longitude = double.tryParse(_longitudeText.text);
                if (latitude != null && longitude != null) {
                  _setNewCoordinates(Coordinates(latitude, longitude));
                }
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  String _getHijriFullDate() {
    var hijri = HijriCalendar.now();
    return hariNames[hijri.wkDay] +
        ", " +
        hijri.hDay.toString() +
        " " +
        bulanNames[hijri.hMonth] +
        " " +
        hijri.hYear.toString();
  }

  _setAlarmNotification(PrayerTimes prayerTimes, int prayerIndex) {
    Prayer prayer = Prayer.values[prayerIndex];
    DateTime prayerTime = prayerTimes.timeForPrayer(prayer);

    scheduleNotification(
        flutterLocalNotificationsPlugin,
        prayerIndex,
        prayer.toString(),
        'Saatnya Sholat: ' +
            prayerNames[prayerIndex] +
            ', Pukul ' +
            prayerTime.hour.toString() +
            ':' +
            prayerTime.minute.toString(),
        prayerTime);
  }

  _onAlarmPressed(int index, DateTime prayerTime) {
    bool flag = !alarmFlag[index];
    _saveAlarmFlag(index, flag);
    if (flag) {
      _setAlarmNotification(_prayerTimes, index);
    } else {
      turnOffNotificationById(flutterLocalNotificationsPlugin, index);
    }
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

  _refreshFunc() {
    print('refresh');
    getCoordinates().then((coordinates) {
      if (coordinates == null) return;
      if (_myCoordinates != null) {
        if (_myCoordinates.latitude.toStringAsFixed(4) ==
                coordinates.latitude.toStringAsFixed(4) &&
            _myCoordinates.longitude.toStringAsFixed(4) ==
                coordinates.longitude.toStringAsFixed(4)) return;
      }
      _setNewCoordinates(coordinates);
    });
  }

  _setNewCoordinates(Coordinates coordinates) {
    print('setting new coordinates');
    var prayerTimes = PrayerTimes.today(coordinates, getPrayerParams());
    Prayer.values.forEach((p) {
      if (alarmFlag[p.index]) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, p.index);
        _setAlarmNotification(_prayerTimes, p.index);
      }
    });

    _latitudeText.text = coordinates.latitude.toString();
    _longitudeText.text = coordinates.longitude.toString();

    _prayerTimes = prayerTimes;

    saveCoordinates(coordinates);
    setState(() {
      _myCoordinates = coordinates;
    });
  }
}
