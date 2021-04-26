import 'package:hive/hive.dart';

// run
// flutter packages pub run build_runner build
// to generate adapter
part 'prayerAlarmModel.g.dart';

@HiveType(typeId: 2)
class PrayerAlarm {
  @HiveField(0)
  final int alarmIndex;

  @HiveField(1)
  final bool alarmFlag;

  PrayerAlarm({this.alarmIndex, this.alarmFlag});
}
