import 'package:flutter/material.dart';
import 'timer_logic.dart';
import 'fullscreen_timer.dart';

class TimerUI extends StatefulWidget {
  final bool isFullscreen;
  final void Function(bool)? onFullscreenChange;

  const TimerUI({
    super.key,
    this.isFullscreen = false,
    this.onFullscreenChange,
  });

  @override
  State<TimerUI> createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> {
  bool _isHolding = false;
  bool _primed = false;
  final Duration _holdDuration = const Duration(milliseconds: 300);
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
      if (mounted && _isHolding) {
        setState(() {
          _primed = true;
          _logic.reset(); // reset time to 0.00 when primed
        });
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    _isHolding = false;

    if (_primed) {
      setState(() => _primed = false);

      // navigate to fullscreen timer and start
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => FullscreenTimerPage(logic: _logic),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _primed ? Colors.yellow : Colors.grey[400],
          alignment: Alignment.center,
          child: ValueListenableBuilder<int>(
            valueListenable: _logic.timeNotifier,
            builder: (context, milliseconds, _) {
              final seconds = (milliseconds / 1000).floor();
              final ms = (milliseconds % 1000) ~/ 10;
              final timeString = '$seconds.${ms.toString().padLeft(2, '0')}';

              return Text(
                timeString,
                style: const TextStyle(fontSize: 32, color: Colors.black87),
              );
            },
          ),
        ),
      ),
    );
  }
}
