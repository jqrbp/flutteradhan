import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;
import '../widgets/prayerTimesWidget.dart';
import '../widgets/settingWidget.dart';
import 'package:hive/hive.dart';
import '../models/prayerParameterModel.dart';
import '../models/savedCoordinateModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Coordinates _myCoordinates = Coordinates(0, 0);
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    _myCoordinates = _getSavedCoordinates();
    _refreshFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageControllerChanged,
            children: [
              PrayerTimesWidget(
                coordinates: _myCoordinates,
                prayerTimes:
                    PrayerTimes.today(_myCoordinates, _getPrayerParams()),
                refreshFunc: _refreshFunc,
              ),
              SettingWidget(),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Halaman Muka'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Pengaturan'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // void _onPressedAlarmFunc(int prayerIndex) {
  //   Box<SavedCoordinate> _hiveBox = Hive.box<SavedCoordinate>('prayerAlarm');
  //   PrayerAlarm alarm = _hiveBox.get(prayerIndex.toString());
  // }

  void _onPageControllerChanged(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  _refreshFunc() {
    _getCoordinates().then((coordinates) {
      if (coordinates == null) return;
      if (_myCoordinates != null) {
        if (_myCoordinates.latitude.toStringAsFixed(4) ==
                coordinates.latitude.toStringAsFixed(4) &&
            _myCoordinates.longitude.toStringAsFixed(4) ==
                coordinates.longitude.toStringAsFixed(4)) return;
      }
      setState(() {
        _myCoordinates = coordinates;
      });
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

    final coordinates =
        Coordinates(locationData.latitude, locationData.longitude);

    _saveCoordinates(coordinates);
    return coordinates;
  }

  CalculationParameters _getPrayerParams() {
    CalculationParameters prayerParams;
    Box<PrayerParameter> _hiveBox = Hive.box<PrayerParameter>('setting');
    PrayerParameter param = _hiveBox.get("prayerParams");
    if (param != null) {
      prayerParams =
          CalculationMethod.values[param.methodIndex].getParameters();
      prayerParams.madhab = Madhab.values[param.madhabIndex];
    } else {
      prayerParams = CalculationMethod.values[0].getParameters();
      prayerParams.madhab = Madhab.values[0];
      _hiveBox.put(
          "prayerParams", PrayerParameter(methodIndex: 0, madhabIndex: 0));
    }

    return prayerParams;
  }

  _saveCoordinates(Coordinates coord) async {
    Box<SavedCoordinate> _hiveBox =
        Hive.box<SavedCoordinate>('savedCoordinate');
    _hiveBox.put("coordinate",
        SavedCoordinate(latitude: coord.latitude, longitude: coord.longitude));
  }

  Coordinates _getSavedCoordinates() {
    Box<SavedCoordinate> _hiveBox =
        Hive.box<SavedCoordinate>('savedCoordinate');
    SavedCoordinate coord = _hiveBox.get("coordinate");
    if (coord != null) {
      return Coordinates(coord.latitude, coord.longitude);
    }

    return Coordinates(0, 0);
  }
}
