import 'package:flutter/material.dart';
import 'timer_logic.dart';

class FullscreenTimerPage extends StatefulWidget {
  final TimerLogic logic;

  const FullscreenTimerPage({super.key, required this.logic});

  @override
  State<FullscreenTimerPage> createState() => _FullscreenTimerPageState();
}

class _FullscreenTimerPageState extends State<FullscreenTimerPage> {
  DateTime? _timerStartTime;
  final Duration _minRunTime = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _timerStartTime = DateTime.now();
    widget.logic.start();
  }

  void _stopTimerAndExit() {
    final now = DateTime.now();
    if (_timerStartTime != null &&
        now.difference(_timerStartTime!) >= _minRunTime) {
      widget.logic.stop();
      Navigator.of(context).pop(); // Go back to main view
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopTimerAndExit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: widget.logic.timeNotifier,
            builder: (context, milliseconds, _) {
              final seconds = (milliseconds / 1000).floor();
              final ms = (milliseconds % 1000) ~/ 10;
              final timeString = '$seconds.${ms.toString().padLeft(2, '0')}';

              return Text(
                timeString,
                style: const TextStyle(fontSize: 72, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
