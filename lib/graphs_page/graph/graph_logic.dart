import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolveData {
  final String puzzle;
  final String session;
  final String category;
  final double timeMs;
  final DateTime date;
  final String scramble;
  final int penalty;
  final String comment;

  SolveData({
    required this.puzzle,
    required this.session,
    required this.category,
    required this.timeMs,
    required this.date,
    required this.scramble,
    required this.penalty,
    required this.comment,
  });
}

class GraphPage extends StatefulWidget {
  final List<SolveData> solveData;
  final ZoomPanBehavior zoomController;
  final String? selectedCategory;
  const GraphPage({super.key, required this.solveData, required this.zoomController, this.selectedCategory});

  @override
  GraphPageState createState() => GraphPageState();
}

enum GraphType { raw, ao5, ao12 }

class GraphPageState extends State<GraphPage> {
  late ZoomPanBehavior _zoomPanBehavior;
  GraphType _selectedGraph = GraphType.raw;

  List<SolveData> get _filteredSolvesBySession {
    if (_selectedSessionCategory == null) return widget.solveData;
    return widget.solveData.where((s) => s.category == _selectedSessionCategory).toList();
  }



  List<SolveData> get _filteredData {
    final baseList = _filteredSolvesBySession;
    switch (_selectedGraph) {
      case GraphType.ao5:
        return _calculateRollingAverage(baseList, 5);
      case GraphType.ao12:
        return _calculateRollingAverage(baseList, 12);
      case GraphType.raw:
      default:
        return baseList;
    }
  }


  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = widget.zoomController;
  }

  List<SolveData> _calculateRollingAverage(List<SolveData> data, int windowSize) {
    List<SolveData> averaged = [];

    for (int i = 0; i < data.length; i++) {
      if (i + 1 < windowSize) continue; // skip until there's enough solves to average

      final window = data.sublist(i + 1 - windowSize, i + 1);
      final average = window.map((s) => s.timeMs).reduce((a, b) => a + b) / windowSize;

      averaged.add(SolveData(
        puzzle: data[i].puzzle,
        session: data[i].session,
        category: data[i].category,
        timeMs: average,
        date: data[i].date, // use the date of the last solve in the window
        scramble: '',
        penalty: 0,
        comment: 'Ao$windowSize',
      ));
    }

    return averaged;
  }

  Set<String> get _sessionCategories {
    return widget.solveData.map((s) => s.category).toSet();
  }

  String? _selectedSessionCategory;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rubik's Cube Solve Times")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<GraphType>(
              value: _selectedGraph,
              onChanged: (GraphType? newValue) {
                setState(() {
                  _selectedGraph = newValue!;
                });
              },
              items: GraphType.values.map((GraphType type) {
                return DropdownMenuItem<GraphType>(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: 'Solve Times Over Date'),
              primaryXAxis: DateTimeAxis(),
              zoomPanBehavior: _zoomPanBehavior,
              series: <CartesianSeries<SolveData, DateTime>>[
                LineSeries<SolveData, DateTime>(
                  dataSource: widget.solveData,
                  xValueMapper: (data, _) => data.date,
                  yValueMapper: (data, _) => data.timeMs,
                  name: _selectedGraph.toString().split('.').last.toUpperCase(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
