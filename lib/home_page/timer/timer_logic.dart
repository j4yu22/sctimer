import 'dart:async';
import 'package:flutter/widgets.dart';

enum TimerState {
  idle, running, stopped
}

class TimerLogic {
  final ValueNotifier<int> timeNotifier = ValueNotifier<int>(0);
  final ValueNotifier<TimerState> stateNotifier = ValueNotifier<TimerState>(TimerState.idle);
  // Used to notify other widgets to update timer values in real time
  // UI can can listen to this to automatically update displayed time without manual calls

  TimerState _state = TimerState.idle;
  TimerState get currentState => _state;

  void _updateState(TimerState newState) {
    _state = newState;
    stateNotifier.value = newState;
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
    _stopwatch.start();
    _updateState(TimerState.running);
    _tickTimer = Timer.periodic(const Duration(milliseconds: 10), (_) => _onTick());
  }

  void stop() {
    _stopwatch.stop();
    _updateState(TimerState.stopped);
    _milliseconds = _stopwatch.elapsedMilliseconds;
    timeNotifier.value = _milliseconds;
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

  void _onTick() {
    _milliseconds = _stopwatch.elapsedMilliseconds;
    timeNotifier.value = _milliseconds;
  //   Used to check time passed, update internal ms counter, push value to timeNotifier
  //   Heartbeat of the timer, ensures display is accurate & responsive
  }

  void endTimer() {
    _tickTimer?.cancel();
    timeNotifier.dispose();
    stateNotifier.dispose();
  //   Used to safely shut down timer instance & listeners
  //   Call when app no longer needs timer (leaving the screen, shutting down app, etc)
  }

  // Constructor
  TimerLogic() {
    _stopwatch = Stopwatch();
  }
}