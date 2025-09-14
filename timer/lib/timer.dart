import 'dart:async';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  late double _percent;
  bool _isActive = false;
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;
  void startWork() {
    readSettings();
    _percent = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void startBreak(bool isShort) {
    readSettings();
    _percent = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }

  late Timer timer;
  late Duration _time;
  late Duration _fullTime;
  double get percent => _percent;
  Duration get time => _time;
  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    return '$minutes : $seconds';
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        _time = _time - Duration(seconds: 1);
        _percent = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time: time, percent: _percent);
    });
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (!this._isActive && (_time.inSeconds > 0)) {
      this._isActive = true;
    }
  }

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = (prefs.getInt('workTime') == null) ? 30 : prefs.getInt('workTime')!;
    shortBreak =
        (prefs.getInt('shortBreak') == null) ? 5 : prefs.getInt('shortBreak')!;
    longBreak =
        (prefs.getInt('longBreak') == null) ? 20 : prefs.getInt('longBreak')!;
  }
}