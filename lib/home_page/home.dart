import 'package:flutter/material.dart';
import 'package:sctimer/footer/footer_ui.dart';
import 'timer/timer_ui.dart';
import 'time_display/time_display_ui.dart';
import 'scramble/scramble_ui.dart';
import '../header/header_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showFullscreenTimer = false;

  void _setFullscreen(bool value) {
    setState(() {
      _showFullscreenTimer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  HeaderUI(),
                  ScrambleUI(),
                  Expanded(child: TimerUI(onFullscreenChange: _setFullscreen)),
                  TimeDisplayUI(),
                  Footer(),
                ],
              ),

              // Fullscreen overlay only when _showFullscreenTimer is true
              if (_showFullscreenTimer)
                Positioned.fill(
                  child: TimerUI(
                    isFullscreen: true,
                    onFullscreenChange: _setFullscreen,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
