import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FocusMode { pomodoro, stopwatch }

class FocusController extends GetxController with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final currentMode = FocusMode.pomodoro.obs;
  late TabController tabController;

  // Stopwatch state
  final stopwatchElapsedSeconds = 0.obs;
  final isStopwatchPlaying = false.obs;
  final stopwatchHasStarted = false.obs;
  
  Timer? _stopwatchDartTimer;
  DateTime? _stopwatchLastTickTime;

  CountDownController countDownController = CountDownController();
  final duration = (25 * 60).obs;
  final remainingSeconds = (25 * 60).obs;
  final timerKey = UniqueKey().obs; 
  final initialDurationForUI = 0.obs;
  
  final isPlaying = false.obs;
  final hasStarted = false.obs;
  
  Timer? _dartTimer;
  DateTime? _lastTickTime;

  int get currentElapsed => max(0, duration.value - remainingSeconds.value);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (currentMode.value.index != tabController.index) {
        currentMode.value = FocusMode.values[tabController.index];
        _saveState();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  @override
  void onClose() {
    tabController.dispose();
    _stopDartTimer();
    _stopStopwatchDartTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final savedDuration = prefs.getInt('focus_duration');
    final savedRemaining = prefs.getInt('focus_remaining');
    final savedHasStarted = prefs.getBool('focus_has_started');
    
    final savedMode = prefs.getInt('focus_current_mode');
    if (savedMode != null && savedMode >= 0 && savedMode < FocusMode.values.length) {
      currentMode.value = FocusMode.values[savedMode];
      tabController.index = savedMode;
    }
    
    final savedStopwatchElapsed = prefs.getInt('focus_stopwatch_elapsed');
    final savedStopwatchHasStarted = prefs.getBool('focus_stopwatch_has_started');
    
    if (savedDuration != null) duration.value = savedDuration;
    if (savedRemaining != null) remainingSeconds.value = savedRemaining;
    if (savedHasStarted != null) hasStarted.value = savedHasStarted;
    if (savedStopwatchElapsed != null) stopwatchElapsedSeconds.value = savedStopwatchElapsed;
    if (savedStopwatchHasStarted != null) stopwatchHasStarted.value = savedStopwatchHasStarted;
    
    isPlaying.value = false;
    isStopwatchPlaying.value = false;
    _saveState(); 

    _refreshTimerKey();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('focus_duration', duration.value);
    await prefs.setInt('focus_remaining', remainingSeconds.value);
    await prefs.setBool('focus_is_playing', isPlaying.value);
    await prefs.setBool('focus_has_started', hasStarted.value);
    await prefs.setInt('focus_current_mode', currentMode.value.index);
    await prefs.setInt('focus_stopwatch_elapsed', stopwatchElapsedSeconds.value);
    await prefs.setBool('focus_stopwatch_has_started', stopwatchHasStarted.value);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _saveState();
    } else if (state == AppLifecycleState.resumed) {
      if (isPlaying.value) {
        _catchUpTimer();
        _refreshTimerKey();
      }
      if (isStopwatchPlaying.value) {
        _catchUpStopwatch();
      }
    }
  }

  void _catchUpTimer() {
    if (_lastTickTime != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_lastTickTime!).inSeconds;
      if (elapsed > 0) {
        remainingSeconds.value = max(0, remainingSeconds.value - elapsed);
        // Advance _lastTickTime exactly by elapsed seconds to preserve fractional 
        // milliseconds and avoid gradual time drift/loss over many ticks.
        _lastTickTime = _lastTickTime!.add(Duration(seconds: elapsed));
        _saveState();
        if (remainingSeconds.value <= 0) {
          remainingSeconds.value = 0;
          _stopDartTimer();
          isPlaying.value = false;
          hasStarted.value = false;
        }
      }
    }
  }

  void _catchUpStopwatch() {
    if (_stopwatchLastTickTime != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_stopwatchLastTickTime!).inSeconds;
      if (elapsed > 0) {
        stopwatchElapsedSeconds.value += elapsed;
        _stopwatchLastTickTime = _stopwatchLastTickTime!.add(Duration(seconds: elapsed));
        _saveState();
      }
    }
  }

  void _startDartTimer() {
    _lastTickTime = DateTime.now();
    _dartTimer?.cancel();
    _dartTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPlaying.value) {
        timer.cancel();
        return;
      }
      _catchUpTimer();
    });
  }

  void _stopDartTimer() {
    _dartTimer?.cancel();
    _dartTimer = null;
    _lastTickTime = null;
  }

  void _startStopwatchDartTimer() {
    _stopwatchLastTickTime = DateTime.now();
    _stopwatchDartTimer?.cancel();
    _stopwatchDartTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isStopwatchPlaying.value) {
        timer.cancel();
        return;
      }
      _catchUpStopwatch();
    });
  }

  void _stopStopwatchDartTimer() {
    _stopwatchDartTimer?.cancel();
    _stopwatchDartTimer = null;
    _stopwatchLastTickTime = null;
  }

  void _refreshTimerKey() {
    initialDurationForUI.value = currentElapsed;
    countDownController = CountDownController();
    timerKey.value = UniqueKey();
  }

  void syncTimerUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isPlaying.value) {
        _catchUpTimer();
      }
      if (isStopwatchPlaying.value) {
        _catchUpStopwatch();
      }
      _refreshTimerKey();
    });
  }

  void setDuration(int minutes) {
    duration.value = minutes * 60;
    remainingSeconds.value = duration.value;
    isPlaying.value = false;
    hasStarted.value = false;
    _saveState();
    _stopDartTimer();
    _refreshTimerKey();
  }
  
  void switchMode(FocusMode mode) {
    if (currentMode.value == mode) return;
    currentMode.value = mode;
    tabController.animateTo(mode.index);
    _saveState();
  }

  void startOrResumeTimer() {
    if (currentMode.value == FocusMode.pomodoro) {
      if (!hasStarted.value) {
        countDownController.start();
        hasStarted.value = true;
      } else {
        countDownController.resume();
      }
      isPlaying.value = true;
      _saveState();
      _startDartTimer();
    } else {
      stopwatchHasStarted.value = true;
      isStopwatchPlaying.value = true;
      _saveState();
      _startStopwatchDartTimer();
    }
  }
  
  void pauseTimer() {
    if (currentMode.value == FocusMode.pomodoro) {
      countDownController.pause();
      isPlaying.value = false;
      _saveState();
      _stopDartTimer();
    } else {
      isStopwatchPlaying.value = false;
      _saveState();
      _stopStopwatchDartTimer();
    }
  }
  
  void resetTimer() {
    if (currentMode.value == FocusMode.pomodoro) {
      remainingSeconds.value = duration.value;
      isPlaying.value = false;
      hasStarted.value = false;
      _saveState();
      _stopDartTimer();
      _refreshTimerKey();
    } else {
      stopwatchElapsedSeconds.value = 0;
      isStopwatchPlaying.value = false;
      stopwatchHasStarted.value = false;
      _saveState();
      _stopStopwatchDartTimer();
    }
  }
}
