import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MethodScreen extends StatefulWidget {
  @override
  _MethodScreenState createState() => _MethodScreenState();
}

class _MethodScreenState extends State<MethodScreen> {
  List<String> methodTitles = [
    'Muslim World League',
    'Egyptian',
    'Karachi',
    'Umm Al-Qura',
    'Dubai',
    'Qatar',
    'Kuwait',
    'Moonsighting Committee',
    'Singapore',
    'North America',
    'Kuwait',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Method')),
      body: SettingsList(
        sections: [
          SettingsSection(
              tiles: methodTitles.map((t) {
            return SettingsTile(
              title: t,
              // trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                Navigator.pop(context, t);
              },
            );
          }).toList()),
        ],
      ),
    );
  }

  // Widget trailingWidget(int index) {
  //   return (languageIndex == index)
  //       ? Icon(Icons.check, color: Colors.blue)
  //       : Icon(null);
  // }

  // void changeLanguage(int index) {
  //   setState(() {
  //     languageIndex = index;
  //   });
  // }
}

// [
//             SettingsTile(
//               title: "Karachi",
//               trailing: trailingWidget(0),
//               onPressed: (BuildContext context) {
//                 Navigator.pop(context, 'Karachi');
//               },
//             ),
//             SettingsTile(
//               title: "Spanish",
//               trailing: trailingWidget(1),
//               onPressed: (BuildContext context) {
//                 changeLanguage(1);
//               },
//             ),
//             SettingsTile(
//               title: "Chinese",
//               trailing: trailingWidget(2),
//               onPressed: (BuildContext context) {
//                 changeLanguage(2);
//               },
//             ),
//             SettingsTile(
//               title: "German",
//               trailing: trailingWidget(3),
//               onPressed: (BuildContext context) {
//                 changeLanguage(3);
//               },
//             ),
//           ]
