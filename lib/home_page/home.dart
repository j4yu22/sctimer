import 'package:flutter/material.dart';
import '../header/header_ui.dart';
import 'scramble/scramble_ui.dart';
import 'timer/timer_ui.dart';
import 'time_display/time_display_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderUI(),
            ScrambleUI(),
            TimerUI(),
            TimeDisplayUI(),
            FooterUI(),
          ],
        ),
      ),
    );
  }
}
