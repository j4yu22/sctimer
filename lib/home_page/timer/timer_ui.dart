import 'package:flutter/material.dart';
import 'timer_logic.dart';

class TimerUI extends StatefulWidget {
  const TimerUI({super.key});

  @override
  State<TimerUI> createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> {
  bool _isHolding = false;
  bool _primed = false;
  bool _timerStarted = false;
  final Duration _holdDuration = const Duration(milliseconds: 300);
  DateTime? _timerStartTime;
  final Duration _minRunTime = const Duration(milliseconds: 200);
  late TimerLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = TimerLogic();
  }

  void _onTapDown(TapDownDetails details) {
    _isHolding = true;
    _primed = false;
    Future.delayed(_holdDuration, () {
      if (mounted && !_timerStarted && _isHolding) {
        setState(() {
          _primed = true;
          _logic.reset(); // reset timer on hold
        });
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    _isHolding = false;
    if (_primed && !_timerStarted) {
      setState(() {
        _timerStarted = true;
        _primed = false;
        _timerStartTime = DateTime.now();
        _logic.start();
      });
    }
  }

  void _onTap() {
    _isHolding = false;
    if (_timerStarted) {
      final now = DateTime.now();
      if (_timerStartTime != null &&
          now.difference(_timerStartTime!) >= _minRunTime) {
        setState(() {
          _timerStarted = false;
          _primed = false;
          _logic.stop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: GestureDetector(
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
                    : Colors.grey[400],
            alignment: Alignment.center,
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
        ),
      ),
    );
  }
}
