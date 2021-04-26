import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'prayerTimesTileWidget.dart';

class PrayerTimesWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.fajr,
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
          onPressedAlarmFunc: onPressedAlarmFunc(Prayer.dhuhr.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.asr,
          onPressedAlarmFunc: onPressedAlarmFunc(Prayer.asr.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.maghrib,
          onPressedAlarmFunc: onPressedAlarmFunc(Prayer.maghrib.index),
        ),
        PrayerTimesTileWidget(
          prayerTimes: prayerTimes,
          prayer: Prayer.isha,
          onPressedAlarmFunc: onPressedAlarmFunc(Prayer.isha.index),
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
          onTap: refreshFunc,
        ),
      ],
    );
  }
}
