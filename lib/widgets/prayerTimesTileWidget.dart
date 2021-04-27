import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../models/idLocale.dart';
import '../utils/prayerTimesHelper.dart';

class PrayerTimesTileWidget extends StatelessWidget {
  PrayerTimesTileWidget(
      {Key key,
      this.prayerTimes,
      this.prayer,
      this.onFlag,
      this.onAlarmPressed})
      : super(key: key);

  final prayerTimes;
  final prayer;
  final onFlag;
  final onAlarmPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: prayerTimes.currentPrayer() == prayer,
      leading: IconButton(
        icon: onFlag == true ? Icon(Icons.alarm_on) : Icon(Icons.alarm_off),
        onPressed: onAlarmPressed,
      ),
      title: Text(
        prayerNames[prayer.index],
        style:
            TextStyle(fontSize: 18, color: _genTextColor(prayerTimes, prayer)),
      ),
      subtitle: Text(
        DateFormat.jm().format(getPrayerTime(prayerTimes, prayer)),
        style: TextStyle(color: _genTextColor(prayerTimes, prayer)),
      ),
      trailing: (prayerTimes.currentPrayer() == prayer ||
              prayerTimes.nextPrayer() == prayer)
          ? Text(
              _genTimeStr(prayerTimes, prayer),
              style: TextStyle(
                  fontSize: 18, color: _genTextColor(prayerTimes, prayer)),
            )
          : Text(""),
    );
  }

  Color _genTextColor(PrayerTimes prayerTimes, Prayer prayer) {
    Color textColor = prayerTimes.currentPrayer() == prayer
        ? Colors.blue
        : prayerTimes.nextPrayer() == prayer
            ? Colors.red
            : Colors.black;
    return textColor;
  }

  String _genTimeStr(PrayerTimes prayerTimes, Prayer prayer) {
    String timeStr;
    final prayerDateTime = getPrayerTime(prayerTimes, prayer);
    final timeDuration = getTimeDiff(prayerDateTime);

    (timeDuration.isNegative) ? timeStr = "-" : timeStr = "+";
    timeStr += " " +
        timeDuration.abs().inHours.toString() +
        " Jam " +
        (timeDuration.abs().inMinutes % 60).toString() +
        " Menit";
    return timeStr;
  }
}
