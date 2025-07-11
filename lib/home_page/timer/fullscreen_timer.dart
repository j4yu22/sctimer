import 'package:flutter/material.dart';
import 'timer_logic.dart';

class FullscreenTimerPage extends StatelessWidget {
  final TimerLogic logic;
  final void Function(int)? onTimerStop;

  const FullscreenTimerPage({super.key, required this.logic, this.onTimerStop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.stop();
        final finalMilliseconds = logic.timeNotifier.value;
        onTimerStop?.call(finalMilliseconds);
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: logic.timeNotifier,
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
