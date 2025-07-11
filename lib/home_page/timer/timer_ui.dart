import 'package:flutter/material.dart';
import '../../data/database_helper.dart';
import 'timer_logic.dart';
import 'fullscreen_timer.dart';

class TimerUI extends StatefulWidget {
  final bool isFullscreen;
  final void Function(bool)? onFullscreenChange;
  final int? sessionId;
  final VoidCallback? onScrambleRefresh;
  final ValueNotifier<int> updateNotifier; // Added

  const TimerUI({
    super.key,
    this.isFullscreen = false,
    this.onFullscreenChange,
    this.sessionId,
    this.onScrambleRefresh,
    required this.updateNotifier, // Added
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

  @override
  void dispose() {
    _logic.endTimer();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isHolding = true;
      _primed = false;
    });

    Future.delayed(_holdDuration, () {
      if (mounted && _isHolding) {
        setState(() {
          _primed = true;
          _logic.prepareStart();
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
    if (!_primed) {
      setState(() => _isHolding = false);
      widget.onScrambleRefresh?.call();
      return;
    }

    setState(() => _primed = false);
    _logic.start();

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:
            (_) => FullscreenTimerPage(
              logic: _logic,
              onTimerStop: _onTimerStop,
              onScrambleRefresh: widget.onScrambleRefresh,
              updateNotifier: widget.updateNotifier, // Added
            ),
      ),
    );
  }

  Future<void> _onTimerStop(int milliseconds) async {
    if (widget.sessionId == null) {
      print('TimerUI: No sessionId provided, skipping insertion');
      return;
    }

    print(
      'TimerUI: Attempting to insert solve for sessionId = ${widget.sessionId}, time = $milliseconds ms',
    );
    try {
      final sessionExists = await DatabaseHelper.instance.getSession(
        widget.sessionId!,
      );
      print(
        'TimerUI: Session exists = ${sessionExists != null}, session = $sessionExists',
      );
      if (sessionExists == null) {
        print('TimerUI: Invalid sessionId = ${widget.sessionId}, no insertion');
        return;
      }
      final solveData = {
        'session_id': widget.sessionId!,
        'solve_time': milliseconds,
        'is_dnf': 0,
        'plus_two': 0,
        'scramble': 'N/A',
        'comment': '',
        'reconstruction': '',
        'date_time': DateTime.now().toIso8601String(),
      };
      print('TimerUI: Solve data = $solveData');
      final db = await DatabaseHelper.instance.database;
      final solveId = await db.insert('solve', solveData);
      print('TimerUI: Solve inserted with solve_id = $solveId');
      widget.updateNotifier.value++;
    } catch (e, stackTrace) {
      print('TimerUI: Error inserting solve: $e, stackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _primed ? Colors.yellow : Colors.grey[400],
          child: Stack(
            children: [
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
                        fontSize: 50,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ),
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
