import 'package:flutteradhan/utils/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import 'package:adhan/adhan.dart';
import '../utils/alarmHelper.dart';
import '../utils/locationHelper.dart';
import '../utils/prayerTimesHelper.dart';
import '../models/taskModel.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final workManager = Workmanager();
const updatePrayerTimeTaskID = '50';
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

void _saveTaskStatus(String id, TaskStatus status) {
  Box<TaskStatus> _hiveBox = Hive.box<TaskStatus>('taskStatus');
  _hiveBox.put(id, status);
}

void _updateAlarmBackgroundFunc() {
  bool flag;
  final Coordinates coords = getSavedCoordinates();
  final PrayerTimes prayerTimes = PrayerTimes.today(coords, getPrayerParams());

  FlutterLocalNotificationsPlugin workerNotificationPlugin = new FlutterLocalNotificationsPlugin();
      
  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = new AndroidInitializationSettings('app_icon');
  var iOS = new IOSInitializationSettings();
    
  // initialise settings for both Android and iOS device.
  var settings = new InitializationSettings(android: android, iOS: iOS);
  
  Prayer.values.forEach((p) {
    flag = getAlarmFlag(p.index);
    setAlarmNotification(prayerTimes, p.index, flag);
  });

  _saveTaskStatus(updatePrayerTimeTaskID, TaskStatus(id: updatePrayerTimeTaskID, lastAccessTime: DateTime.now().toString()));

  workerNotificationPlugin.initialize(settings);
  showNotification(workerNotificationPlugin, 100, 'updateAlarm',
      'Waktu Sholat', 'Memperbaharui data...', 'item');
}

Future<void> initWorkerManager() async {
  await workManager.initialize(
    callbackDispatcher,
    // isInDebugMode: true,
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
    existingWorkPolicy: ExistingWorkPolicy.replace
  );
}

TaskStatus getTaskStatus(String id) {
  Box<TaskStatus> _hiveBox = Hive.box<TaskStatus>('taskStatus');
  TaskStatus status = _hiveBox.get(id);

  if (status == null) {
    status = TaskStatus(id: id, lastAccessTime: DateTime.now().toString());
    _saveTaskStatus(id, status);
  }
  return status;
}
