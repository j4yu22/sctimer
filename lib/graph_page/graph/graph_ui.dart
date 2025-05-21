import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_logic.dart';
// import 'path to solve data';


final ZoomPanBehavior zoomController = ZoomPanBehavior(
  enablePinching: true,
  enablePanning: true,
  zoomMode: ZoomMode.xy,
);

class GraphUI extends StatelessWidget {
  final List<SolveData> solveData;
  const GraphUI({super.key, required this.solveData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rubik's Cube Solve Times"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Solve Times Over Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Reset button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => zoomController.reset(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Zoom'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Graph
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: SfCartesianChart(
                  zoomPanBehavior: zoomController,
                  title: ChartTitle(
                    text: 'Rubik\'s Cube Solve Time (ms)',
                    alignment: ChartAlignment.near,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Time (ms)'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  series: <CartesianSeries<SolveData, DateTime>>[
                    LineSeries<SolveData, DateTime>(
                      dataSource: solveData,
                      xValueMapper: (data, _) => data.date,
                      yValueMapper: (data, _) => data.timeInMS,
                      name: 'Solve Time',
                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

