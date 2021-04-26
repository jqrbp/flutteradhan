import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesTileWidget extends StatelessWidget {
  PrayerTimesTileWidget({Key key, this.prayerTimes, this.prayer, this.onFlag, this.onAlarmPressed})
      : super(key: key);

  final prayerTimes;
  final prayer;
  final onFlag;
  final onAlarmPressed;

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
    final _prayerTimes = prayerTimes;
    final Prayer _prayer = prayer;

    final _prayerDateTime = _getPrayerTime(_prayerTimes, _prayer);

    final _currPrayer = _prayerTimes.currentPrayer();
    final _nextPrayer = _prayerTimes.nextPrayer();

    final _currPrayerFlag = _currPrayer == _prayer;
    final _nextPrayerFlag = _nextPrayer == _prayer;

    final _textColor = _currPrayerFlag
        ? Colors.blue
        : _nextPrayerFlag
            ? Colors.red
            : Colors.black;

    final _timeDuration = _getTimeDiff(_prayerDateTime);

    (_timeDuration.isNegative) ? timeStr = "-" : timeStr = "+";
    timeStr += " " +
        _timeDuration.abs().inHours.toString() +
        " Jam " +
        (_timeDuration.abs().inMinutes % 60).toString() +
        " Menit";

    return ListTile(
      selected: _currPrayerFlag,
      // tileColor: _nextPrayerFlag ? Colors.red : null,
      leading: IconButton(
        icon: onFlag == true ? Icon(Icons.alarm_on) : Icon(Icons.alarm_off),
        onPressed: onAlarmPressed,
      ),
      title: Text(
        _prayerNames[_prayer.index],
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
