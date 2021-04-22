import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;

void main() {
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
      home: MyHomePage(title: 'Jam Sholat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Coordinates _myCoordinates = Coordinates(37.5371364, 127.0832429);

  @override
  void initState() {
    super.initState();
    _getCoordinates().then((locationData) {
      setState(() {
        if (locationData != null) {
          _myCoordinates =
              Coordinates(locationData.latitude, locationData.longitude);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshPrayer,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: FutureBuilder(
          future: _generatePrayerTimes(),
          builder: (BuildContext context, AsyncSnapshot<PrayerTimes> snapshot) {
            // if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return ListView(
                children: [
                  _genPrayerListTile(snapshot.data, Prayer.fajr),
                  ListTile(
                    title: Text('Pagi'),
                    subtitle: Text(
                      DateFormat.jm().format(snapshot.data.sunrise),
                    ),
                  ),
                  _genPrayerListTile(snapshot.data, Prayer.dhuhr),
                  _genPrayerListTile(snapshot.data, Prayer.asr),
                  _genPrayerListTile(snapshot.data, Prayer.maghrib),
                  _genPrayerListTile(snapshot.data, Prayer.isha),
                  ListTile(
                    title: Text('Qiyam'),
                    subtitle: Text(
                      DateFormat.jm().format(
                          SunnahTimes(snapshot.data).lastThirdOfTheNight),
                    ),
                  ),
                  ListTile(
                    title: Text('Arah Kiblat'),
                    subtitle: Text(
                      Qibla(_myCoordinates).direction.toStringAsFixed(2),
                    ),
                  ),
                  ListTile(
                    title: Text('Lokasi'),
                    subtitle: Text(
                      _myCoordinates.latitude.toString() +
                          ', ' +
                          _myCoordinates.longitude.toString(),
                    ),
                  ),
                ],
              );
            }
            // } else if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: Text('Loading'),);
            // }
            return Center(
              child: Text('Loading'),
            );
          }),
    );
  }

  DateTime _getPrayerTime(PrayerTimes _prayerTimes, Prayer _prayer) {
    switch (_prayer) {
      case Prayer.fajr:
        return _prayerTimes.fajr;
      case Prayer.dhuhr:
        return _prayerTimes.dhuhr;
      case Prayer.asr:
        return _prayerTimes.asr;
      case Prayer.maghrib:
        return _prayerTimes.maghrib;
      case Prayer.isha:
        return _prayerTimes.isha;
      default:
        return DateTime.now();
    }
  }

  ListTile _genPrayerListTile(PrayerTimes _prayerTimes, Prayer _prayer) {
    List<String> _prayerNames = [
      '-',
      'Subuh',
      'Pagi',
      'Dhuhur',
      'Ashar',
      'Maghrib',
      'Isya'
    ];

    DateTime _prayerDateTime = _getPrayerTime(_prayerTimes, _prayer);

    Prayer _currPrayer = _prayerTimes.currentPrayer();
    Prayer _nextPrayer = _prayerTimes.nextPrayer();

    bool _currPrayerFlag = _currPrayer == _prayer;
    bool _nextPrayerFlag = _nextPrayer == _prayer;

    Color _textColor = _currPrayerFlag
        ? Colors.blue
        : _nextPrayerFlag
            ? Colors.red
            : Colors.black;
    return ListTile(
      selected: _currPrayerFlag,
      // tileColor: _nextPrayerFlag ? Colors.red : null,
      title: Text(
        _prayerNames[_prayer.index],
        style: TextStyle(fontSize: 18, color: _textColor),
      ),
      subtitle: Text(
        DateFormat.jm().format(_prayerDateTime),
        style: TextStyle(color: _textColor),
      ),
      trailing: (_currPrayerFlag || _nextPrayerFlag)
          ? Text(
              _getMinuteDiff(_prayerDateTime).toString() + " Menit",
              style: TextStyle(fontSize: 18, color: _textColor),
            )
          : Text(""),
    );
  }

  int _getMinuteDiff(DateTime _time) {
    return DateTime.now().difference(_time).inMinutes;
  }

  Future<PrayerTimes> _generatePrayerTimes() async {
    // Replace with your own location lat, lng.
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    var _prayerTimes = PrayerTimes.today(_myCoordinates, params);

    return _prayerTimes;
  }

  _refreshPrayer() async {
    LocationData locationData = await _getCoordinates();
    if (locationData != null) {
      final snackBar = SnackBar(
        content: Text(
          'Latitude: ' +
              locationData.latitude.toString() +
              ', Longitude: ' +
              locationData.longitude.toString(),
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _myCoordinates =
            Coordinates(locationData.latitude, locationData.longitude);
      });
    }
  }

  _requestPermision() async {
    Map<permHandler.Permission, permHandler.PermissionStatus> statuses = await [
      permHandler.Permission.location,
    ].request();
    // print(statuses[permHandler.Permission.location]);
    return statuses;
  }

  Future<LocationData> _getCoordinates() async {
    Location location = new Location();
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    LocationData locationData;

    var statuses = await _requestPermision();

    if (statuses[permHandler.Permission.location] !=
        permHandler.PermissionStatus.granted) {
      return null;
    }

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return null;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return null;
    //   }
    // }

    locationData = await location.getLocation();

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   // Use current location
    //   setState(() {
    //     _myCoordinates =
    //         Coordinates(locationData.latitude, locationData.longitude);
    //   });
    // });
    return locationData;
  }
}
