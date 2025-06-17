import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'package:sctimer/data/database_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  SettingsPageState();

  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Text("Settings page"),
            IconButton(
              icon: Icon(Icons.access_alarm),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                var puzzleNames;
                var puzzles = _dbHelper.getPuzzles().then(puzzleNames);
              },
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
