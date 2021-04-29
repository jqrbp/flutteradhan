import 'package:flutteradhan/utils/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import 'package:adhan/adhan.dart';
import '../utils/alarmHelper.dart';
import '../utils/locationHelper.dart';
import '../utils/prayerTimesHelper.dart';
import '../main.dart';
// import '../models/taskModel.dart';
// import 'package:hive/hive.dart';

final workManager = new Workmanager();
const updatePrayerTimeTaskID = '0';
const updatePrayerTimeTaskName = 'updatePrayerTimeTask';

void callbackDispatcher() {
  workManager.executeTask((task, inputData) async {
    switch (task) {
      case updatePrayerTimeTaskName:
        _updateAlarmBackgroundFunc();
        break;
    }

    return Future.value(true);
  });
}

void _updateAlarmBackgroundFunc() {
  bool flag;
  final Coordinates coords = getSavedCoordinates();
  final PrayerTimes prayerTimes = PrayerTimes.today(coords, getPrayerParams());

  Prayer.values.forEach((p) {
    flag = getAlarmFlag(p.index);
    setAlarmNotification(prayerTimes, p.index, flag);
  });

  showNotification(flutterLocalNotificationsPlugin, 100, 'updateAlarm',
      'Waktu Sholat', 'Memperbaharui data...', 'item');
}

Future<void> initWorkerManager() async {
  await workManager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
}

Future<void> cancelAllTask() async {
  await workManager.cancelAll();
}

Future<void> cancelTask(String id) async {
  await workManager.cancelByUniqueName(id);
}

Future<void> enablePeriodicTask(
    String id, String taskName, Duration duration) async {
  // if (_getTaskRunFlag(id)) return;
  // _saveTaskStatus(id, TaskStatus(id: id, runFlag: true));
  await workManager.registerPeriodicTask(
    id,
    taskName,
    frequency: duration,
  );
}

// void _saveTaskStatus(String id, TaskStatus status) {
//   Box<TaskStatus> _hiveBox = Hive.box<TaskStatus>('taskStatus');
//   _hiveBox.put(id, status);
// }

// bool _getTaskRunFlag(String id) {
//   Box<TaskStatus> _hiveBox = Hive.box<TaskStatus>('taskStatus');
//   TaskStatus status = _hiveBox.get(id);

//   if (status != null) {
//     return status.runFlag;
//   }
//   _saveTaskStatus(id, TaskStatus(id: id, runFlag: false));
//   return false;
// }
