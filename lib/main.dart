import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'models/prayerParameterModel.dart';
import 'models/savedCoordinateModel.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PrayerParameterAdapter());
  Hive.registerAdapter(SavedCoordinateAdapter());
  await Hive.openBox<PrayerParameter>('setting');
  await Hive.openBox<SavedCoordinate>('savedCoordinate');
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
