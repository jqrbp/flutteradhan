import 'package:hive/hive.dart';
import 'package:adhan/adhan.dart';
import '../models/prayerAlarmModel.dart';
import '../utils/notificationHelper.dart';
import '../main.dart';
import '../models/idLocale.dart';

void _enableAlarmNotification(PrayerTimes prayerTimes, int prayerIndex) {
  Prayer prayer = Prayer.values[prayerIndex];
  DateTime prayerTime = prayerTimes.timeForPrayer(prayer);

  scheduleNotification(
      flutterLocalNotificationsPlugin,
      prayerIndex,
      prayer.toString(),
      'Pengingat Sholat',
      'Saatnya Sholat: ' +
          prayerNames[prayerIndex] +
          ', Pukul ' +
          prayerTime.hour.toString() +
          ':' +
          prayerTime.minute.toString(),
      prayerTime);
}

void setAlarmNotification(
    PrayerTimes prayerTimes, int prayerIndex, bool enableFlag) {
  turnOffNotificationById(flutterLocalNotificationsPlugin, prayerIndex);
  if (enableFlag) {
    _enableAlarmNotification(prayerTimes, prayerIndex);
  }
}

void saveAlarmFlag(int index, bool flag) {
  Box<PrayerAlarm> _hiveBox = Hive.box<PrayerAlarm>('prayerAlarm');
  _hiveBox.put(
      index.toString(), PrayerAlarm(alarmFlag: flag, alarmIndex: index));
}

bool getAlarmFlag(int index) {
  Box<PrayerAlarm> _hiveBox = Hive.box<PrayerAlarm>('prayerAlarm');
  PrayerAlarm alarm = _hiveBox.get(index.toString());

  if (alarm != null) {
    return alarm.alarmFlag;
  }
  saveAlarmFlag(index, false);
  return false;
}
