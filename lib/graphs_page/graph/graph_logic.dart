import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolveData {
  final String puzzle;
  final String category;
  final double timeMs;
  final DateTime date;
  final String scramble;
  final int penalty;
  final String comment;

  SolveData({
    required this.puzzle,
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
  const GraphPage({super.key, required this.solveData, required this.zoomController});

  @override
  GraphPageState createState() => GraphPageState();
}

class GraphPageState extends State<GraphPage> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = widget.zoomController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rubik's Cube Solve Times")),
      body: Column(
        children: [
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
                  name: 'Solve Time (ms)',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
