import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(children: [Text("Settings page"), Footer()]),
      ),
    );
  }
}
