import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesTileWidget extends StatelessWidget {
  PrayerTimesTileWidget({Key key, this.prayerTimes, this.prayer})
      : super(key: key);

  final prayerTimes;
  final prayer;

  final List<String> _prayerNames = [
    '-',
    'Subuh',
    'Pagi',
    'Dhuhur',
    'Ashar',
    'Maghrib',
    'Isya'
  ];

  @override
  Widget build(BuildContext context) {
    String timeStr;
    final DateTime _prayerDateTime = _getPrayerTime(prayerTimes, prayer);

    final Prayer _currPrayer = prayerTimes.currentPrayer();
    final Prayer _nextPrayer = prayerTimes.nextPrayer();

    final bool _currPrayerFlag = _currPrayer == prayer;
    final bool _nextPrayerFlag = _nextPrayer == prayer;

    final Color _textColor = _currPrayerFlag
        ? Colors.blue
        : _nextPrayerFlag
            ? Colors.red
            : Colors.black;

    final Duration _timeDuration = _getTimeDiff(_prayerDateTime);

    (_timeDuration.isNegative) ? timeStr = "-" : timeStr = "+";
    timeStr += " " +
        _timeDuration.abs().inHours.toString() +
        " Jam " +
        (_timeDuration.abs().inMinutes % 60).toString() +
        " Menit";
    return ListTile(
      selected: _currPrayerFlag,
      // tileColor: _nextPrayerFlag ? Colors.red : null,
      title: Text(
        _prayerNames[prayer.index],
        style: TextStyle(fontSize: 18, color: _textColor),
      ),
      subtitle: Text(
        DateFormat.jm().format(_prayerDateTime),
        style: TextStyle(color: _textColor),
      ),
      trailing: (_currPrayerFlag || _nextPrayerFlag)
          ? Text(
              timeStr,
              style: TextStyle(fontSize: 18, color: _textColor),
            )
          : Text(""),
    );
  }

  Duration _getTimeDiff(DateTime _time) {
    return DateTime.now().difference(_time);
  }

  DateTime _getPrayerTime(PrayerTimes _prayerTimes, Prayer _prayer) {
    switch (_prayer) {
      case Prayer.fajr:
        return _prayerTimes.fajr;
      case Prayer.dhuhr:
        return _prayerTimes.dhuhr;
      case Prayer.asr:
        return _prayerTimes.asr;
      case Prayer.maghrib:
        return _prayerTimes.maghrib;
      case Prayer.isha:
        return _prayerTimes.isha;
      default:
        return DateTime.now();
    }
  }
}
