import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'package:sctimer/data/database_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  SettingsPageState();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

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
                // var puzzleNames = _dbHelper.getPuzzles().then((var puzzles) {
                //   for (var item in puzzles)
                //   {
                //     var dispItem = item["puzzle_id"];
                //     print('Puzzle: $dispItem');
                //   }
                // });

                _dbHelper.getPuzzles().then((puzzles) {
                  for (var item in puzzles) {
                    var puzzleId = item["puzzle_id"];
                    var puzzleName = item["puzzle_name"];
                    print('Puzzle ID: $puzzleId, Name: $puzzleName');
                  }
                });
              },
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}

class Solve {
  late int _solveTime;
  late bool _dnf;
  late int _plus2;
  late String _scramble;
  late String? _comment;
  late DateTime _date;
  late String? _reconstruction;
  Solve(
    int solveTime,
    String scramble,
    DateTime date,
    String? comment,
    String? reconstruction, [
    bool dnf = false,
    int plus2 = 0,
  ]) {
    _solveTime = solveTime;
    _dnf = dnf;
    _plus2 = plus2;
    _scramble = scramble;
    _comment = comment;
    _date = date;
    _reconstruction = reconstruction;
  }

  Map<String, dynamic> GetDBMap() {
    Map<String, dynamic> dbValues = {};
    dbValues["solve_time"] = _solveTime;
    dbValues["is_dnf"] = _dnf;
    dbValues["plus_two"] = _plus2;
    dbValues["scramble"] = _scramble;
    dbValues["comment"] = _comment;
    dbValues["date_time"] = _date;
    dbValues["reconstruction"] = _reconstruction;
    return dbValues;
  }
}

Future<List<String>> readLinesFromFile() async {
  try {
    // Get the path to the app's documents directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inserts.txt');

    // Check if the file exists
    if (await file.exists()) {
      // Read the file and split into lines
      List<String> lines = await file.readAsLines();
      return lines;
    } else {
      print('File does not exist');
      return [];
    }
  } catch (e) {
    print('Error reading file: $e');
    return [];
  }
}
