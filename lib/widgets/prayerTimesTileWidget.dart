import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/idLocale.dart';
import '../utils/prayerTimesHelper.dart';

class PrayerTimesTileWidget extends StatelessWidget {
  PrayerTimesTileWidget(
      {Key key,
      this.prayerTimes,
      this.prayer,
      this.timeDuration,
      this.onFlag,
      this.onAlarmPressed})
      : super(key: key);

  final prayerTimes;
  final prayer;
  final onFlag;
  final onAlarmPressed;
  final timeDuration;

  @override
  Widget build(BuildContext context) {
    final String prayerNameStr = prayerNames[prayer.index];
    final bool currPrayerFlag = prayerTimes.currentPrayer() == prayer;
    final bool nextPrayerFlag = prayerTimes.nextPrayer() == prayer;
    final Color textColor = _genTextColor(currPrayerFlag, nextPrayerFlag);
    final String subtitleStr =
        DateFormat.jm().format(getPrayerTime(prayerTimes, prayer));
        
    final String timeStr = _genTimeStr(timeDuration, currPrayerFlag || nextPrayerFlag);
    final leadingIcon = onFlag == true ? Icon(Icons.alarm_on) : Icon(Icons.alarm_off);

    return ListTile(
      selected: currPrayerFlag,
      leading: IconButton(
        icon: leadingIcon,
        onPressed: onAlarmPressed,
      ),
      title: Text(
        prayerNameStr,
        style: TextStyle(fontSize: 18, color: textColor),
      ),
      subtitle: Text(
        subtitleStr,
        style: TextStyle(color: textColor),
      ),
      trailing: Text(
              timeStr,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
    );
  }

  Color _genTextColor(bool currPrayerFlag, bool nextPrayerFlag) {
    Color textColor = currPrayerFlag
        ? Colors.blue
        : nextPrayerFlag
            ? Colors.red
            : Colors.black;
    return textColor;
  }

  String _genTimeStr(Duration timeDuration, bool setFlag) {
    String timeStr = "";
    
    if (setFlag) {
      (timeDuration.isNegative) ? timeStr = "-" : timeStr = "+";
      timeStr += " " +
          timeDuration.abs().inHours.toString() +
          " Jam " +
          (timeDuration.abs().inMinutes % 60).toString() +
          " Menit";
    }
    return timeStr;
  }
}
