import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/prayerTimesWidget.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Coordinates _myCoordinates = Coordinates(0, 0);

  @override
  void initState() {
    super.initState();
    _refreshFunc();
  }

  @override
  Widget build(BuildContext context) {
    CalculationParameters params =
        CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PrayerTimesWidget(
          coordinates: _myCoordinates,
          prayerTimes: PrayerTimes.today(_myCoordinates, params),
          refreshFunc: _refreshFunc),
    );
  }

  _refreshFunc() {
    _getCoordinates().then((coordinates) {
      if (coordinates != null) {
        if (_myCoordinates == null) {
          setState(() {
            _myCoordinates = coordinates;
          });
        } else {
          if (_myCoordinates.latitude.toStringAsFixed(4) !=
                  coordinates.latitude.toStringAsFixed(4) ||
              _myCoordinates.longitude.toStringAsFixed(4) !=
                  coordinates.longitude.toStringAsFixed(4)) {
            setState(() {
              _myCoordinates = coordinates;
            });
          }
        }
      }
    });
  }

  Future<permHandler.PermissionStatus> _requestPermision() async {
    Map<permHandler.Permission, permHandler.PermissionStatus> statuses = await [
      permHandler.Permission.location,
    ].request();
    // print(statuses[permHandler.Permission.location]);
    return statuses[permHandler.Permission.location];
  }

  Future<Coordinates> _getCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (await _requestPermision() != permHandler.PermissionStatus.granted) {
      return Future.error('Location permissions are denied');
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return Coordinates(locationData.latitude, locationData.longitude);
  }
}
