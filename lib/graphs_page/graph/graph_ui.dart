// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'graph_logic.dart';
// // import 'path to solve data';
//
//
// final ZoomPanBehavior zoomController = ZoomPanBehavior(
//   enablePinching: true,
//   enablePanning: true,
//   zoomMode: ZoomMode.xy,
// );
//
// class GraphUI extends StatelessWidget {
//   final List<SolveData> solveData;
//   const GraphUI({super.key, required this.solveData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Rubik's Cube Solve Times"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Title
//             const Text(
//               'Solve Times Over Time',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//
//             // Reset button
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 onPressed: () => zoomController.reset(),
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Reset Zoom'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Graph
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: SfCartesianChart(
//                   zoomPanBehavior: zoomController,
//                   title: ChartTitle(
//                     text: 'Rubik\'s Cube Solve Time (ms)',
//                     alignment: ChartAlignment.near,
//                     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   primaryXAxis: DateTimeAxis(),
//                   primaryYAxis: NumericAxis(
//                     title: AxisTitle(text: 'Time (ms)'),
//                   ),
//                   tooltipBehavior: TooltipBehavior(enable: true),
//                   legend: Legend(isVisible: true),
//                   series: <CartesianSeries<SolveData, DateTime>>[
//                     LineSeries<SolveData, DateTime>(
//                       dataSource: solveData,
//                       xValueMapper: (data, _) => data.dateTime,
//                       yValueMapper: (data, _) => data.solveTime,
//                       name: 'Solve Time',
//                       dataLabelSettings: const DataLabelSettings(isVisible: false),
//                       markerSettings: const MarkerSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
//

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_logic.dart';

final ZoomPanBehavior zoomController = ZoomPanBehavior(
  enablePinching: true,
  enablePanning: true,
  zoomMode: ZoomMode.xy,
);

class GraphUI extends StatefulWidget {
  final List<SolveData> solveData;
  final List<SolveData> ao5Data;
  final List<SolveData> ao12Data;

  const GraphUI({
    super.key,
    required this.solveData,
    required this.ao5Data,
    required this.ao12Data,
  });

  @override
  State<GraphUI> createState() => _GraphUIState();
}

class _GraphUIState extends State<GraphUI> {
  bool showRaw = true;
  bool showAo5 = true;
  bool showAo12 = true;

  @override
  Widget build(BuildContext context) {
    final List<CartesianSeries<SolveData, DateTime>> seriesList = [];

    if (showRaw) {
      seriesList.add(
        LineSeries<SolveData, DateTime>(
          dataSource: widget.solveData,
          xValueMapper: (data, _) => data.dateTime,
          yValueMapper: (data, _) => data.solveTime,
          name: 'Solve Time',
          color: Colors.blueGrey,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      );
    }

    if (showAo5) {
      seriesList.add(
        LineSeries<SolveData, DateTime>(
          dataSource: widget.ao5Data,
          xValueMapper: (data, _) => data.dateTime,
          yValueMapper: (data, _) => data.solveTime,
          name: 'Average of 5',
          color: Colors.green,
          dashArray: <double>[5, 3],
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      );
    }

    if (showAo12) {
      seriesList.add(
        LineSeries<SolveData, DateTime>(
          dataSource: widget.ao12Data,
          xValueMapper: (data, _) => data.dateTime,
          yValueMapper: (data, _) => data.solveTime,
          name: 'Average of 12',
          color: Colors.orange,
          dashArray: <double>[2, 3],
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rubik's Cube Times"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Chart
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
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
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  primaryXAxis: DateTimeAxis(),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Time (ms)'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  series: seriesList,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Toggle Switches
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                _buildToggle('Solve Time', showRaw, (val) => setState(() => showRaw = val)),
                _buildToggle('Average of 5', showAo5, (val) => setState(() => showAo5 = val)),
                _buildToggle('Average of 12', showAo12, (val) => setState(() => showAo12 = val)),
              ],
            ),

            const SizedBox(height: 16),

            // Reset Zoom Button
            ElevatedButton.icon(
              onPressed: () => zoomController.reset(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Zoom'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(value: value, onChanged: onChanged),
        Text(label),
      ],
    );
  }
}
