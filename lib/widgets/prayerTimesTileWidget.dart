import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesTileWidget extends StatefulWidget {
  PrayerTimesTileWidget({Key key, this.prayerTimes, this.prayer})
      : super(key: key);

  final prayerTimes;
  final prayer;

  final List<String> prayerNames = [
    '-',
    'Subuh',
    'Pagi',
    'Dhuhur',
    'Ashar',
    'Maghrib',
    'Isya'
  ];

  @override
  _PrayerTimesTileWidgetState createState() => _PrayerTimesTileWidgetState();
}

class _PrayerTimesTileWidgetState extends State<PrayerTimesTileWidget> {
  String timeStr;
  DateTime _prayerDateTime;

  Prayer _currPrayer;
  Prayer _nextPrayer;

  bool _currPrayerFlag;
  bool _nextPrayerFlag;

  Color _textColor;

  Duration _timeDuration = Duration(seconds: 0);

  @override
  void initState() {
    final _prayerDateTime = _getPrayerTime(widget.prayerTimes, widget.prayer);

    final _currPrayer = widget.prayerTimes.currentPrayer();
    final _nextPrayer = widget.prayerTimes.nextPrayer();

    final _currPrayerFlag = _currPrayer == widget.prayer;
    final _nextPrayerFlag = _nextPrayer == widget.prayer;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          IconButton(icon: Icon(Icons.alarm), onPressed: onPressedAlarmFunc),
      selected: _currPrayerFlag,
      // tileColor: _nextPrayerFlag ? Colors.red : null,
      title: Text(
        widget.prayerNames[widget.prayer.index],
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

  onPressedAlarmFunc() {}

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
