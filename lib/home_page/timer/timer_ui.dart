import 'package:flutter/material.dart';
import 'timer_logic.dart';

class TimerUI extends StatefulWidget {
  const TimerUI({super.key});

  @override
  State<TimerUI> createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> {
  bool _primed = false;
  bool _timerStarted = false;
  Duration _holdDuration = const Duration(milliseconds: 800);
  late TimerLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = TimerLogic();
  }

  void _onTapDown(TapDownDetails details) {
    _primed = false;
    Future.delayed(_holdDuration, () {
      if (mounted && !_timerStarted) {
        setState(() => _primed = true);
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    if (_primed && !_timerStarted) {
      setState(() {
        _timerStarted = true;
        _logic.start();
      });
    }
  }

  void _onTap() {
    if (_timerStarted) {
      setState(() {
        _timerStarted = false;
        _primed = false;
        _logic.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color:
            _timerStarted
                ? Colors.black
                : _primed
                ? Colors.yellow
                : Colors.grey[300],
        alignment: Alignment.center,
        width: _timerStarted ? double.infinity : 200,
        height: _timerStarted ? double.infinity : 200,
        child: ValueListenableBuilder<int>(
          valueListenable: _logic.timeNotifier,
          builder: (context, milliseconds, _) {
            final seconds = (milliseconds / 1000).floor();
            final ms = (milliseconds % 1000) ~/ 10;
            final timeString = '$seconds.${ms.toString().padLeft(2, '0')}';
            return Text(
              timeString,
              style: TextStyle(
                fontSize: _timerStarted ? 64 : 32,
                color: _timerStarted ? Colors.white : Colors.black87,
              ),
            );
          },
        ),
      ),
    );
  }
}
