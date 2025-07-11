import 'package:flutter/material.dart';
import 'timer_logic.dart';

class FullscreenTimerPage extends StatefulWidget {
  final TimerLogic logic;
  final void Function(int)? onTimerStop;
  final VoidCallback? onScrambleRefresh;

  const FullscreenTimerPage({
    super.key,
    required this.logic,
    required this.onTimerStop,
    this.onScrambleRefresh,
  });

  @override
  State<FullscreenTimerPage> createState() => _FullscreenTimerPageState();
}

class _FullscreenTimerPageState extends State<FullscreenTimerPage> {
  @override
  void initState() {
    super.initState();
    print('[FullscreenTimerPage] initState');

    // Fix: Schedule refresh AFTER first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onScrambleRefresh?.call();
      print('[FullscreenTimerPage] Called onScrambleRefresh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Stop the timer and return to the previous screen
        widget.logic.stop();

        // Send the result back
        final finalMilliseconds = widget.logic.timeNotifier.value;
        widget.onTimerStop?.call(finalMilliseconds);

        Navigator.of(context).pop();
      },
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
