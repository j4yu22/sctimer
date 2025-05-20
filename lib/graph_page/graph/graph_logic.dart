import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolveData {
  final DateTime date;
  final double timeInMS;

  SolveData(this.date, this.timeInMS);
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
                  yValueMapper: (data, _) => data.timeInMS,
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
