import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'timer/timer_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //The PopScope object for this project disables the android back button which causes some weird behavior.
      //It will be changed a little bit in the future to be more useful.
      //It is also present on all the other pages for the same reason
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              HeaderUI(),
              ScrambleUI(),
              TimerUI(),
              TimeDisplayUI(),
              Footer(),
            ], // Fixed: class name should match what's in timer_ui.dart
          ),
        ),
      ),
    );
  }
}
