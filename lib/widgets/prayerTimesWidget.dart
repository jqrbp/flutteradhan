import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'prayerTimesTileWidget.dart';
import '../utils/notificationHelper.dart';
import '../main.dart';
import '../models/idLocale.dart';
import '../utils/locationHelper.dart';
import '../utils/prayerTimesHelper.dart';
import '../utils/alarmHelper.dart';
import '../utils/workerManagerHelper.dart';

class PrayerTimesWidget extends StatefulWidget {
  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  Timer _timer;
  PrayerTimes _prayerTimes;
  Coordinates _myCoordinates;
  TextEditingController _latitudeText = TextEditingController();
  TextEditingController _longitudeText = TextEditingController();
  List<bool> alarmFlag = Prayer.values.map((v) {
    return false;
  }).toList();

  @override
  void initState() {
    _myCoordinates = getSavedCoordinates();
    _prayerTimes = PrayerTimes.today(_myCoordinates, getPrayerParams());

    _latitudeText.text = _myCoordinates.latitude.toString();
    _longitudeText.text = _myCoordinates.longitude.toString();

    alarmFlag = Prayer.values.map((p) {
      bool flag = getAlarmFlag(p.index);
      setAlarmNotification(_prayerTimes, p.index, flag);
      return flag;
    }).toList();

    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      setState(() {
        _prayerTimes = PrayerTimes.today(_myCoordinates, getPrayerParams());
      });
    });

    enablePeriodicTask(updatePrayerTimeTaskID, updatePrayerTimeTaskName,
        Duration(minutes: 15));

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _genListViewItems(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return snapshot.data[index];
                });
          }
          return Center(child: Text("Memuat Waktu Sholat"));
        });
  }

  Future<List<Widget>> _genListViewItems() async {
    List<Widget> listViewItems = [];
    listViewItems.add(ListTile(
      title: Text(
        _getHijriFullDate(),
      ),
    ));
    listViewItems.add(ListTile(
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
    ));
    Prayer.values.forEach((p) {
      final prayerDateTime = getPrayerTime(_prayerTimes, p);
      if (p != Prayer.none)
        listViewItems.add(
          PrayerTimesTileWidget(
            prayerTimes: _prayerTimes,
            prayer: p,
            prayerName: prayerNames[p.index],
            prayerTime: DateFormat.jm().format(prayerDateTime),
            disableFlag: p == Prayer.sunrise ? true : false,
            timeDuration: getTimeDiff(prayerDateTime),
            onFlag: alarmFlag[p.index],
            onAlarmPressed: () =>
                _onAlarmPressed(p.index, _prayerTimes.timeForPrayer(p)),
          ),
        );
    });
    listViewItems.add(
      PrayerTimesTileWidget(
        prayerTimes: _prayerTimes,
        prayerName: "Qiyam",
        prayerTime: DateFormat.jm()
            .format(SunnahTimes(_prayerTimes).lastThirdOfTheNight),
      ),
    );
    return listViewItems;
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

  _onAlarmPressed(int index, DateTime prayerTime) {
    bool flag = !alarmFlag[index];
    setAlarmNotification(_prayerTimes, index, flag);
    saveAlarmFlag(index, flag);
    setState(() {
      alarmFlag[index] = flag;
    });
  }

  _refreshFunc() {
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
    var prayerTimes = PrayerTimes.today(coordinates, getPrayerParams());
    Prayer.values.forEach((p) {
      turnOffNotificationById(flutterLocalNotificationsPlugin, p.index);
      setAlarmNotification(_prayerTimes, p.index, alarmFlag[p.index]);
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
