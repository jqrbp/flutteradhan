import 'package:flutteradhan/utils/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/locationHelper.dart';
import 'package:adhan/adhan.dart';
import '../utils/prayerTimesHelper.dart';
import '../utils/alarmHelper.dart';

final workManager = Workmanager();
const updatePrayerTimeTaskID = '50';
const updatePrayerTimeTaskName = 'updatePrayerTimeTask';

void callbackDispatcher() {
  workManager.executeTask((task, inputData) async {
    switch (task) {
      case updatePrayerTimeTaskName:
        _updateAlarmBackgroundFunc(inputData);
        break;
    }

    return Future.value(true);
  });
}

Future<void> _saveWorkerLastRunDate(DateTime date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('workerLastRunDate', date.toUtc().toString());
}

Future<void> _updateAlarmBackgroundFunc(inputData) async {
  showNotification(flutterLocalNotificationsPlugin, 100, 'updateAlarm',
      'Waktu Sholat', 'Memperbaharui data...', 'item');

  final CalculationParameters params = await getPrayerParams();
  final Coordinates coords = await getSavedCoordinates();
  // final PrayerTimes prayerTimes = PrayerTimes.today(coords, params);

  // Prayer.values.forEach((p) {
  //   await getAlarmFlag(p.index);
  //     setAlarmNotification(prayerTimes, p.index, flag);
  // });

  _saveWorkerLastRunDate(DateTime.now());
  print('===> latitude: ' +
      coords.latitude.toString() +
      ', longitude: ' +
      coords.longitude.toString());
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

Future<void> enablePeriodicTask(String id, String taskName, Duration duration,
    Map<String, dynamic> inputData) async {
  await workManager.registerPeriodicTask(id, taskName,
      frequency: duration,
      inputData: inputData,
      existingWorkPolicy: ExistingWorkPolicy.replace);
}

Future<String> getWorkerLastRunDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('workerLastRunDate')) {
    return prefs.getString('workerLastRunDate');
  }
  return 'Not Found';
}
