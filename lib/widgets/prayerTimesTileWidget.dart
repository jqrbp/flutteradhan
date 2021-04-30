import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrayerTimesTileWidget extends StatelessWidget {
  PrayerTimesTileWidget(
      {Key key,
      this.prayerTimes,
      this.prayer,
      this.prayerName = "",
      this.prayerTime = "",
      this.timeDuration,
      this.onFlag,
      this.disableFlag = true,
      this.onAlarmPressed})
      : super(key: key);

  final prayerTimes;
  final prayer;
  final prayerTime;
  final onFlag;
  final onAlarmPressed;
  final timeDuration;
  final disableFlag;
  final prayerName;

  @override
  Widget build(BuildContext context) {
    
    if (prayerTimes == null) {
      return ListTile(
      leading: Icon(Icons.block),
      title: Text(prayerName),
      subtitle: Text('Memuat data...'));
    }

    final bool currPrayerFlag = (prayer == null || prayerTimes == null)
        ? false
        : prayerTimes.currentPrayer() == prayer;
    final bool nextPrayerFlag = (prayer == null || prayerTimes == null)
        ? false
        : prayerTimes.nextPrayer() == prayer;
    final Color textColor = !disableFlag
        ? _genTextColor(currPrayerFlag, nextPrayerFlag)
        : Colors.blueGrey;
    final double fontSize = !disableFlag ? 18 : 16;

    final String timeStr = !disableFlag
        ? _genTimeStr(timeDuration, currPrayerFlag || nextPrayerFlag)
        : "";
    final leadingIcon = disableFlag
        ? Icon(Icons.block_flipped, color: Colors.blueGrey.withOpacity(0.4))
        : onFlag
            ? Icon(Icons.alarm_on)
            : Icon(Icons.alarm_off);

    final onPressedFunc = disableFlag ? null : onAlarmPressed;

    return ListTile(
      selected: currPrayerFlag,
      leading: IconButton(
        color: Colors.grey,
        icon: leadingIcon,
        onPressed: onPressedFunc,
      ),
      title: Text(
        prayerName,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
      subtitle: Text(
        prayerTime,
        style: TextStyle(color: textColor),
      ),
      trailing: Text(
        timeStr,
        style: TextStyle(fontSize: fontSize, color: textColor),
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
