import 'dart:async';
import 'package:flutter/widgets.dart';

enum TimerState {
  idle, running, stopped
}

class TimerLogic {
  TimerState _state = TimerState.idle;
  TimerState get currentState => _state;

  void _updateState(TimerState newState) {
    _state = newState;
    // TODO: Notify UI or Listeners about change in state
  }

  late Stopwatch _stopwatch;
  Timer? _tickTimer;
  int _milliseconds = 0;

  void prepareStart() {
    _stopwatch.reset();
    _milliseconds = 0;
    timeNotifier.value = 0;
    _updateState(TimerState.idle);
  }

  void start() {
    if (_state != TimerState.idle) return;

    _stopwatch.start();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      _onTick;
    });
  }

  void stop() {
    _stopwatch.stop();
    _milliseconds = _stopwatch.elapsedMilliseconds;
    timeNotifier.value = _milliseconds;
    _updateState(TimerState.stopped);
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();

    _tickTimer?.cancel();
    _tickTimer = null;

    _milliseconds = 0;
    timeNotifier.value = 0;

    _updateState(TimerState.idle);
  }

  final ValueNotifier<int> timeNotifier = ValueNotifier<int>(0);
  // Used to notify other widgets to update timer values in real time
  // UI can can listen to this to automatically update displayed time without manual calls

  void _onTick() {
    _milliseconds = _stopwatch.elapsedMilliseconds;
    timeNotifier.value = _milliseconds;
  //   Used to check time passed, update internal ms counter, push value to timeNotifier
  //   Heartbeat of the timer, ensures display is accurate & responsive
  }

  void endTimer() {
    _tickTimer?.cancel();
    timeNotifier.dispose();
  //   Used to safely shut down timer instance & listeners
  //   Call when app no longer needs timer (leaving the screen, shutting down app, etc)
  }
  // Constructor
  TimerLogic() {
    _stopwatch = Stopwatch();
  }
}