import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jam Sholat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _prayerNames = [
    '-',
    'Subuh',
    'Pagi',
    'Dhuhur',
    'Ashar',
    'Maghrib',
    'Isya'
  ];

  Qibla _qibla;
  Prayer _currPrayer;
  Prayer _nextPrayer;
  LocationData _locationData;

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
            if (snapshot.connectionState == ConnectionState.done) {
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
                    // ListTile(
                    //     title: Text('Time For Prayer'),
                    //     subtitle: Text(DateFormat.jm().format(snapshot.data
                    //         .timeForPrayer(snapshot.data.currentPrayer())))),
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
                        subtitle: Text(DateFormat.jm().format(
                            SunnahTimes(snapshot.data).lastThirdOfTheNight))),
                    // ListTile(
                    //     title: Text('Current Prayer'),
                    //     subtitle:
                    //         Text(snapshot.data.currentPrayer().toString())),
                    // ListTile(
                    //     title: Text('Next Prayer'),
                    //     subtitle: Text(snapshot.data.nextPrayer().toString())),
                    ListTile(
                        title: Text('Qibla'),
                        subtitle: Text(_qibla.direction.toString())),
                    // ListTile(
                    //   title: Text('Location'),
                    //   subtitle: Text('Latitude: ' +
                    //       _locationData.latitude.toString() +
                    //       ', Longitude: ' +
                    //       _locationData.longitude.toString()),
                    // ),
                  ],
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Loading'));
            }
            return Center(child: Text('Loading'));
          }),
    );
  }

  // _genCalcRemainingTime(PrayerTimes _prayerTimes, Prayer _prayer) {
  //   var currPrayer = _prayerTimes.currentPrayer();
  //   if (_prayer == currPrayer) {

  //     return
  //   }
  // }

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
    DateTime _prayerDateTime = _getPrayerTime(_prayerTimes, _prayer);
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
              _getMinuteDiff(_prayerDateTime).toString() + " Minutes",
              style: TextStyle(fontSize: 18, color: _textColor),
            )
          : Text(""),
    );
  }

  int _getMinuteDiff(DateTime _time) {
    return DateTime.now().difference(_time).inMinutes;
  }

  Future<PrayerTimes> _generatePrayerTimes() async {
    _locationData = await _getCoordinates();
    Coordinates _myCoordinates = Coordinates(37.5371364, 127.0832429);
    if (_locationData != null) {
      _myCoordinates =
          Coordinates(_locationData.latitude, _locationData.longitude);
    }
    // Replace with your own location lat, lng.
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final snackBar = SnackBar(
      content: Text('Latitude: ' +
          _locationData.latitude.toString() +
          ', Longitude: ' +
          _locationData.longitude.toString()),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    _qibla = Qibla(_myCoordinates);

    var _prayerTimes = PrayerTimes.today(_myCoordinates, params);
    _currPrayer = _prayerTimes.currentPrayer();
    _nextPrayer = _prayerTimes.nextPrayer();
    return _prayerTimes;
  }

  _refreshPrayer() {
    _generatePrayerTimes();
  }

  Future<LocationData> _getCoordinates() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();

    return _locationData;
  }
}
