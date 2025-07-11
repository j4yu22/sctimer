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
  int? _selectedSessionId; // <-- already present

  final GlobalKey<ScrambleUIWidget> _scrambleKey =
      GlobalKey<ScrambleUIWidget>();

  void _handleScrambleRefresh() {
    print('[HomePage] _handleScrambleRefresh called');
    _scrambleKey.currentState?.refreshScramble();
  }

  void _setFullscreen(bool value) {
    setState(() {
      _showFullscreenTimer = value;
    });
  }

  void _onSessionChanged(int? sessionId) {
    setState(() {
      _selectedSessionId = sessionId;
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
                  HeaderUI(
                    selectedSessionId: _selectedSessionId,
                    onSessionChanged: _onSessionChanged,
                  ),
                  ScrambleUI(key: _scrambleKey),
                  Expanded(
                    child: TimerUI(
                      sessionId: _selectedSessionId, // <-- pass sessionId here
                      onFullscreenChange: _setFullscreen,
                      onScrambleRefresh: _handleScrambleRefresh,
                    ),
                  ),
                  TimeDisplayUI(),
                  Footer(),
                ],
              ),
              if (_showFullscreenTimer)
                Positioned.fill(
                  child: TimerUI(
                    isFullscreen: true,
                    sessionId:
                        _selectedSessionId, // <-- pass sessionId here too
                    onFullscreenChange: _setFullscreen,
                    onScrambleRefresh: _handleScrambleRefresh,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
