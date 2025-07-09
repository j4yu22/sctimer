import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph/graph_logic.dart';
import '../data/database_helper.dart';
import '../footer/footer_ui.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  int? selectedPuzzleId;
  bool isLoading = false;

  Future<void> _openGraph() async {
    setState(() => isLoading = true);

    final solveDataList = await DatabaseHelper.instance.getSolves(
      selectedPuzzleId as int,
    );
    final solveData = solveDataList.map(SolveData.fromMap).toList();
    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => GraphPage(
              solveData: solveData,
              zoomController: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Graphs')),

      // Wrap the body in SafeArea to avoid OS intrusions
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton<int>(
                value: selectedPuzzleId,
                hint: const Text('Select puzzle type'),
                onChanged: (value) {
                  setState(() => selectedPuzzleId = value);
                },
                items: const [
                  DropdownMenuItem(value: -1, child: Text('All Puzzles')),
                  DropdownMenuItem(value: 1, child: Text('3x3')),
                  DropdownMenuItem(value: 2, child: Text('2x2')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _openGraph,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Show Graph'),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const Footer(),
    );
  }
}
