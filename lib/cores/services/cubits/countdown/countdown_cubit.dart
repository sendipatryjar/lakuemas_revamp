import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownCubit extends Cubit<String?> {
  CountdownCubit() : super('00:00');

  Timer? _timer;
  Duration? myDuration;

  @override
  Future<void> close() {
    stopCountdown();
    return super.close();
  }

  void startCountdown(int duration, [bool isHour = false]) {
    myDuration = Duration(seconds: duration);
    var result = _result(isHour);
    emit(result);
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => _setCountDown(isHour));
  }

  void stopCountdown() => _timer?.cancel();

  void _setCountDown(bool isHour) {
    const reduceSecondsBy = 1;
    if (myDuration != null) {
      final secondsRemaining = myDuration!.inSeconds - reduceSecondsBy;
      if (secondsRemaining < 0) {
        stopCountdown();
        emit(null);
      } else {
        myDuration = Duration(seconds: secondsRemaining);
        var result = _result(isHour);
        emit(result);
      }
    }
  }

  String _result(bool isHour) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration!.inMinutes.remainder(60));
    final seconds = strDigits(myDuration!.inSeconds.remainder(60));
    if (isHour) {
      final hour = strDigits(myDuration!.inHours.remainder(12));
      return '$hour:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
