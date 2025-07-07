import 'dart:convert';
import 'package:flutter/services.dart';
import '../settings_page/settings.dart';

Future<List<Solve>> loadSolveDataFromText() async {
  final rawText = await rootBundle.loadString('assets/solve_times.txt');
  final lines = LineSplitter().convert(rawText);

  return lines.map((line) {
    final parts = line.split(';');

    final puzzle = parts[0].trim();
    final category = parts[1].trim();
    final timeMs = int.parse(parts[2].trim());
    final dateMs = double.parse(parts[3].trim());
    final date = DateTime.fromMillisecondsSinceEpoch(dateMs.toInt());
    final scramble = parts[4].trim();
    int penalty = int.parse(parts[5].trim());
    final comment = parts[6].trim();

    late bool dnf = false;
    if (penalty == 2)
    {
      dnf = true;
      penalty = 0;
    }
    else
    {
      dnf = false;
    }    

//int solveTime, String scramble, DateTime date, String? comment, String? reconstruction, [bool dnf = false, int plus2 = 0]

    return Solve(
    timeMs,
    scramble,
    date,
    comment,
    null,
    dnf,
    penalty
    );
  }).toList();
}