// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointSystem {
  static const int initialPoints = 20;
  static const int adPoints = 20;
  static const int maxPoints = 20;
  static const int minutesPerHour = 60; // should be 60 min

  late SharedPreferences _prefs;

  static final PointSystem _instance = PointSystem._internal();

  factory PointSystem() {
    return _instance;
  }

  PointSystem._internal() {
    // Initialize the point system
    // _initialize();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get currentPoints => _prefs.getInt('conversationPoints') ?? initialPoints;
  // int get currentPoints => 0 ?? initialPoints;

  Future<void> deductPoint() async {
    int newPoints = currentPoints - 1;
    if (newPoints < 0) newPoints = 0;
    await _prefs.setInt('conversationPoints', newPoints);
  }

  // Future<void> addPointsFromAd() async {
  //   int currentMinutes = DateTime.now().minute;
  //   int minutesRemaining = minutesPerHour - currentMinutes;
  //   int waitingTimeSeconds = minutesRemaining * 60;

  //   int newPoints = currentPoints + adPoints;
  //   await _prefs.setInt('conversationPoints', newPoints);
  //   await _prefs.setInt(
  //       'adPointsTimestamp', DateTime.now().millisecondsSinceEpoch);
  //   await _prefs.setInt('adPointsWaitingTime', waitingTimeSeconds);
  // }

  Future<void> saveDateTime(DateTime dateTime) async {
    if (!_prefs.containsKey('dateTimeWhenFinishPoints')) {
      await _prefs.setString(
          'dateTimeWhenFinishPoints', dateTime.toIso8601String());
    }
  }

  Future<void> restartPointSystem(BuildContext context) async {
    await _prefs.setInt('conversationPoints', initialPoints);
    await _prefs.remove('dateTimeWhenFinishPoints');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لقد تمّ منحك 20 نقطة إضافية')));
    }
  }

  bool get hasRemainingAdPointsTime {
    String? adPointsTimestamp = _prefs.getString('dateTimeWhenFinishPoints');
    if (adPointsTimestamp == null) {
      return false;
    }
    var remainDur = remainingdurationTime;
    if (remainDur.inSeconds <= 0) {
      return false;
    } else {
      return true;
    }
  }

  Duration get remainingdurationTime {
    String? dateTimeString = _prefs.getString('dateTimeWhenFinishPoints');
    Duration duration = const Duration(minutes: minutesPerHour);
    if (dateTimeString != null) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateTime currentTime = DateTime.now();
      duration = currentTime.difference(dateTime);
      // Use the retrieved DateTime value as needed
    }
    if (duration.isNegative == false) {
      duration = const Duration(minutes: minutesPerHour) - duration;
    }
    return duration.isNegative ? const Duration() : duration;
  }

  bool get hasConversationPoints => currentPoints > 0;

  bool get isMaxPointsReached => currentPoints >= maxPoints;

  bool get hasDateTimeEntry => _prefs.containsKey('dateTimeWhenFinishPoints');
}
