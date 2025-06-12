import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'timer/timer_ui.dart';
import 'time_display/time_display_ui.dart';
import 'scramble/scramble_ui.dart';
import '../header/header_ui.dart';
import '/data/database_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              HeaderUI(),
              ScrambleUI(),
              Expanded(child: TimerUI()), // Fills remaining space
              TimeDisplayUI(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
