import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesWidget extends StatelessWidget {
  PrayerTimesWidget(
      {Key key, this.coordinates, this.prayerTimes, this.refreshFunc})
      : super(key: key);

  final coordinates;
  final prayerTimes;
  final refreshFunc;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _genPrayerListTile(Prayer.fajr),
        ListTile(
          title: Text('Pagi'),
          subtitle: Text(
            DateFormat.jm().format(prayerTimes.sunrise),
          ),
        ),
        _genPrayerListTile(Prayer.dhuhr),
        _genPrayerListTile(Prayer.asr),
        _genPrayerListTile(Prayer.maghrib),
        _genPrayerListTile(Prayer.isha),
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

  ListTile _genPrayerListTile(Prayer _prayer) {
    DateTime _prayerDateTime;

    Prayer _currPrayer;
    Prayer _nextPrayer;

    bool _currPrayerFlag;
    bool _nextPrayerFlag;

    Color _textColor;

    List<String> _prayerNames = [
      '-',
      'Subuh',
      'Pagi',
      'Dhuhur',
      'Ashar',
      'Maghrib',
      'Isya'
    ];

    if (prayerTimes != null) {
      _prayerDateTime = _getPrayerTime(prayerTimes, _prayer);

      _currPrayer = prayerTimes.currentPrayer();
      _nextPrayer = prayerTimes.nextPrayer();

      _currPrayerFlag = _currPrayer == _prayer;
      _nextPrayerFlag = _nextPrayer == _prayer;

      _textColor = _currPrayerFlag
          ? Colors.blue
          : _nextPrayerFlag
              ? Colors.red
              : Colors.black;
      return ListTile(
        selected: _currPrayerFlag,
        // tileColor: _nextPrayerFlag ? Colors.red : null,
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
                _getMinuteDiff(_prayerDateTime).toString() + " Menit",
                style: TextStyle(fontSize: 18, color: _textColor),
              )
            : Text(""),
      );
    }
    return ListTile(title: Text(''));
  }

  int _getMinuteDiff(DateTime _time) {
    return DateTime.now().difference(_time).inMinutes;
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
