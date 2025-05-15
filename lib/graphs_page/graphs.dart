import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(body: Column(children: [Text("Graphs page"), Footer()])),
    );
  }
}
