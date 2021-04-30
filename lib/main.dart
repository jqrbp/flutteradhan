import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'utils/notificationHelper.dart';
import 'utils/locationHelper.dart';
import 'utils/workerManagerHelper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);
  await requestLocationPermision();
  await initWorkerManager();
  
  await enablePeriodicTask(updatePrayerTimeTaskID, updatePrayerTimeTaskName,
          Duration(hours: 3), {'date': DateTime.now().toString()});

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adhan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Jam Sholat'),
    );
  }
}
