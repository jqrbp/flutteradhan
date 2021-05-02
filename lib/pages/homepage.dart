import 'package:flutter/material.dart';
import '../widgets/prayerTimesWidget.dart';
import '../widgets/settingWidget.dart';
import '../widgets/calendarWidget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
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
            physics: BouncingScrollPhysics(),
            children: [
              PrayerTimesWidget(),
              CalendarPage(),
              SettingWidget(),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Jam'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Kalender'),
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

  void _onPageControllerChanged(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
  }
}
