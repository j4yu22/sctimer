import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          // ← wrap body in SafeArea
          child: Column(children: [Text("Stats page"), Footer()]),
        ),
      ),
    );
  }
}
