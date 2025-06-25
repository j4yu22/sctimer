import 'package:flutter/material.dart';
import 'timer_logic.dart';
import 'fullscreen_timer.dart';

// remove time, dnf, +2 seconds, comment
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
  bool _cancelledBySwipe = false;
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
    _handleFingerLift();
  }

  void _onPanEnd(DragEndDetails details) {
    _handleFingerLift();
  }

  void _handleFingerLift() {
    _isHolding = false;

    if (_primed) {
      setState(() => _primed = false);

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
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: AspectRatio(
        aspectRatio: 1, // force a square
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _primed ? Colors.yellow : Colors.grey[400],
          child: Stack(
            children: [
              // Centered timer text
              Center(
                child: ValueListenableBuilder<int>(
                  valueListenable: _logic.timeNotifier,
                  builder: (context, milliseconds, _) {
                    final seconds = (milliseconds / 1000).floor();
                    final ms = (milliseconds % 1000) ~/ 10;
                    final timeString =
                        '$seconds.${ms.toString().padLeft(2, '0')}';

                    return Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ),

              // Icon row at bottom center
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.close),
                        tooltip: 'Cancel time',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.block),
                        tooltip: 'Mark as DNF',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flag),
                        tooltip: '+2 Second Penalty',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.comment),
                        tooltip: 'Add comment',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
