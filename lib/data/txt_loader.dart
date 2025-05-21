import 'dart:convert';
import 'package:flutter/services.dart';
import '../graph_page/graph/graph_logic.dart';

Future<List<SolveData>> loadSolveDataFromText() async {
  final rawText = await rootBundle.loadString('assets/solve_times.txt');
  final lines = LineSplitter().convert(rawText);

  return lines.map((line) {
    final parts = line.split(';');

    final puzzle = parts[0].trim();
    final category = parts[1].trim();
    final timeMs = double.parse(parts[2].trim());
    final dateMs = double.parse(parts[3].trim());
    final date = DateTime.fromMillisecondsSinceEpoch(dateMs.toInt());
    final scramble = parts[4].trim();
    final penalty = int.parse(parts[5].trim());
    final comment = parts[6].trim();

    return SolveData(
      puzzle: puzzle,
      category: category,
      timeMs: timeMs,
      date: date,
      scramble: scramble,
      penalty: penalty,
      comment: comment,
    );
  }).toList();
}