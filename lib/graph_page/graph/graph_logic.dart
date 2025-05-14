import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolveData {
  final DateTime date;
  final double timeInMS;

  SolveData(this.date, this.timeInMS);
}

class GraphPage extends StatefulWidget {
  final List<SolveData> solveData;

  const GraphPage({super.key, required this.solveData});

  @override
  GraphPageState createState() => GraphPageState();
}

class GraphPageState extends State<GraphPage> {
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rubik's Cube Solve Times")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _zoomPanBehavior.reset();
            },
            child: const Text('Reset Zoom'),
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
