import 'package:flutter/material.dart';
import 'timer_logic.dart';

class FullscreenTimerPage extends StatefulWidget {
  final TimerLogic logic;
  final void Function(int)? onTimerStop;
  final VoidCallback? onScrambleRefresh;
  final ValueNotifier<int> updateNotifier; // Added

  const FullscreenTimerPage({
    super.key,
    required this.logic,
    required this.onTimerStop,
    this.onScrambleRefresh,
    required this.updateNotifier, // Added
  });

  @override
  State<FullscreenTimerPage> createState() => _FullscreenTimerPageState();
}

class _FullscreenTimerPageState extends State<FullscreenTimerPage> {
  @override
  void initState() {
    super.initState();
    print('[FullscreenTimerPage] initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onScrambleRefresh?.call();
      print('[FullscreenTimerPage] Called onScrambleRefresh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.logic.stop();
        final finalMilliseconds = widget.logic.timeNotifier.value;
        widget.onTimerStop?.call(finalMilliseconds);
        widget.updateNotifier.value++; // Added
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
