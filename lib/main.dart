import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'models/prayerParameterModel.dart';
import 'models/savedCoordinateModel.dart';
import 'models/prayerAlarmModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'utils/notificationHelper.dart';
import 'utils/locationHelper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PrayerParameterAdapter());
  Hive.registerAdapter(SavedCoordinateAdapter());
  Hive.registerAdapter(PrayerAlarmAdapter());
  await Hive.openBox<PrayerParameter>('setting');
  await Hive.openBox<SavedCoordinate>('savedCoordinate');
  await Hive.openBox<PrayerAlarm>('prayerAlarm');

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);
  await requestLocationPermision();
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
