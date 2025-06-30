import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolveData {
  final int solveNumber;
  final int puzzleId;
  final int solveTime; // in milliseconds
  final bool isDNF;
  final bool plusTwo;
  final DateTime dateTime;
  final String scramble;
  final String reconstruction;
  final String comment;

  SolveData({
    required this.solveNumber,
    required this.puzzleId,
    required this.solveTime,
    required this.isDNF,
    required this.plusTwo,
    required this.dateTime,
    required this.scramble,
    required this.reconstruction,
    required this.comment,
  });

  factory SolveData.fromMap(Map<String, dynamic> map) {
    return SolveData(
      solveNumber: map['solve_number'] as int? ?? 0, // Default to 0 if null
      puzzleId: map['puzzle_id'] as int,
      solveTime: map['solve_time'] as int,
      isDNF: (map['is_dnf'] as int) == 1,
      plusTwo: (map['plus_two'] as int) == 1,
      dateTime: DateTime.parse(map['date_time'] as String),
      scramble: map['scramble'] as String,
      reconstruction:
          map['reconstruction'] as String? ?? '', // Default to empty
      comment: map['comment'] as String? ?? '', // Default to empty
    );
  }
}

class GraphPage extends StatefulWidget {
  final List<SolveData> solveData;
  final ZoomPanBehavior zoomController;
  const GraphPage({
    super.key,
    required this.solveData,
    required this.zoomController,
  });

  @override
  GraphPageState createState() => GraphPageState();
}

enum GraphType { raw, ao5, ao12 }

class GraphPageState extends State<GraphPage> {
  late ZoomPanBehavior _zoomPanBehavior;
  int? _selectedPuzzleId;
  bool _showRaw = true;
  bool _showAo5 = false;
  bool _showAo12 = false;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = widget.zoomController;
  }

  /// All unique puzzle IDs
  List<int> get _puzzleIds =>
      widget.solveData.map((s) => s.puzzleId).toSet().toList()..sort();

  /// Data filtered by selected puzzle
  List<SolveData> get _puzzleFiltered {
    if (_selectedPuzzleId == null) return widget.solveData;
    return widget.solveData
        .where((s) => s.puzzleId == _selectedPuzzleId)
        .toList();
  }

  /// Rolling average calculator
  List<SolveData> _calculateRollingAverage(
    List<SolveData> data,
    int windowSize,
  ) {
    final averaged = <SolveData>[];
    for (var i = windowSize - 1; i < data.length; i++) {
      final window = data.sublist(i + 1 - windowSize, i + 1);
      final avg =
          window.map((s) => s.solveTime).reduce((a, b) => a + b) ~/ windowSize;
      averaged.add(
        SolveData(
          solveNumber: window.last.solveNumber,
          puzzleId: window.last.puzzleId,
          solveTime: avg,
          isDNF: false,
          plusTwo: false,
          dateTime: window.last.dateTime,
          scramble: '',
          reconstruction: window.last.reconstruction,
          comment: 'Ao$windowSize',
        ),
      );
    }
    return averaged;
  }

  @override
  Widget build(BuildContext context) {
    // Prepare series data
    final rawData = _puzzleFiltered;
    final ao5Data = _calculateRollingAverage(_puzzleFiltered, 5);
    final ao12Data = _calculateRollingAverage(_puzzleFiltered, 12);

    final series = <CartesianSeries<SolveData, DateTime>>[];
    if (_showRaw) {
      series.add(
        LineSeries<SolveData, DateTime>(
          dataSource: rawData,
          xValueMapper: (d, _) => d.dateTime,
          yValueMapper: (d, _) => d.solveTime,
          name: 'RAW',
        ),
      );
    }
    if (_showAo5) {
      series.add(
        LineSeries<SolveData, DateTime>(
          dataSource: ao5Data,
          xValueMapper: (d, _) => d.dateTime,
          yValueMapper: (d, _) => d.solveTime,
          name: 'AO5',
        ),
      );
    }
    if (_showAo12) {
      series.add(
        LineSeries<SolveData, DateTime>(
          dataSource: ao12Data,
          xValueMapper: (d, _) => d.dateTime,
          yValueMapper: (d, _) => d.solveTime,
          name: 'AO12',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Rubik's Cube Solve Times")),
      body: Column(
        children: [
          // Puzzle filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: DropdownButton<int?>(
              hint: const Text('Select Puzzle'),
              value: _selectedPuzzleId,
              onChanged: (val) => setState(() => _selectedPuzzleId = val),
              items: [
                const DropdownMenuItem<int>(
                  value: -1,
                  child: Text('All Puzzles'),
                ),
                ..._puzzleIds.map(
                  (id) => DropdownMenuItem<int>(
                    value: id,
                    child: Text('Puzzle $id'),
                  ),
                ),
              ],
            ),
          ),

          /// Checkboxes for graph types
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Raw'),
                    value: _showRaw,
                    onChanged: (v) => setState(() => _showRaw = v ?? false),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ao5'),
                    value: _showAo5,
                    onChanged: (v) => setState(() => _showAo5 = v ?? false),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ao12'),
                    value: _showAo12,
                    onChanged: (v) => setState(() => _showAo12 = v ?? false),
                  ),
                ),
              ],
            ),
          ),
          // Chart
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: 'Solve Times Over Date'),
              primaryXAxis: DateTimeAxis(),
              zoomPanBehavior: _zoomPanBehavior,
              legend: Legend(isVisible: true),
              series: series,
            ),
          ),
        ],
      ),
    );
  }
}
