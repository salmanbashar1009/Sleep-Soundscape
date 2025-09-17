import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sleep_soundscape/api_services/hive_service.dart';
import 'package:sleep_soundscape/model/reminder.dart';
import '../notification_services/notification_services.dart';


@pragma('vm:entry-point') //  Required for release mode
void notificationCallback(NotificationResponse response) async {
  debugPrint(" Notification Clicked with payload: ${response.payload}");

  if (response.actionId == "STOP_ALARM") {
    debugPrint("\nStop button clicked!\n");
    await stopAlarm();
  } else if (response.actionId == "SNOOZE_ALARM") {
    debugPrint("\nSnooze button clicked!\n");
    await snoozeAlarm();
  }
}

Future<void> stopAlarm() async {
  debugPrint("\nStopping Alarm...\n");
  FlutterBackgroundService service = FlutterBackgroundService();
  service.invoke("stop_audio");
  FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  await _localNotificationsPlugin.cancel(0); //  Dismiss notification
}

Future<void> snoozeAlarm() async {
  debugPrint("\n Snoozing Alarm for 5 minutes...\n");

  // Cancel the current alarm notification
  FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await _localNotificationsPlugin.cancel(0);
  FlutterBackgroundService service = FlutterBackgroundService();
  service.invoke("stop_audio");

  // Get the current time and add 5 minutes for snooze
  DateTime snoozeTime = DateTime.now().add(Duration(minutes: 1));
  int snoozeAlarmId = DateTime.now().millisecondsSinceEpoch.remainder(100000); // Generate a unique ID for snooze

  // Schedule a new alarm after 5 minutes
  bool snoozeScheduled = await AndroidAlarmManager.oneShotAt(
    snoozeTime,
    snoozeAlarmId,
    alarmCallback,
    exact: true,
    wakeup: true,
    alarmClock: true,
    allowWhileIdle: true,
    rescheduleOnReboot: true,
    params: {
      "title": "Snoozed Alarm",
      "body": "Your alarm has been snoozed!",
    },
  );

  // Schedule a new notification for the snoozed alarm
  NotificationServices.scheduledNotification(
    "Sleep Soundscape",
    "Your alarm will ring again in 1 minutes!",
    Duration(minutes: 1),
    snoozeAlarmId,
  );
  if (snoozeScheduled) {
    debugPrint("\nSnoozed Alarm Scheduled for: $snoozeTime\n");
  } else {
    debugPrint("\nFailed to schedule snooze alarm.\n");
  }
}




/// Initialize background service
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(onForeground: onStart),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: false,
    ),
  );

  // service.startService();
}


String ringtonePath = "musics/alarm-01.mp3";

void changeAlarm({required String assetAlarmPath}){
  ringtonePath = assetAlarmPath;
  debugPrint("\nRingtone path : $ringtonePath\n");
}

/// Runs when the alarm triggers
@pragma('vm:entry-point') // Required for AOT compilation
void onStart(ServiceInstance service) async {
  debugPrint("\nbackground service's onStart method started\n");
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Listen for commands (only play audio when alarmCallback() invokes it)
  service.on("play_audio").listen((event) async {
    debugPrint("\nAlarm Triggered: Playing Sound!\n");

    String demoAudioPath = ringtonePath;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(demoAudioPath), volume: 1);
    } catch (e) {
      debugPrint("\nError playing audio: $e/n");
    }
  });

  service.on("stop_audio").listen((event) async {
    debugPrint("Stopping Alarm Sound...");
    try {
      await _audioPlayer.stop();
      // await _audioPlayer.dispose();
      debugPrint("\nSuccessfully alarm stopped.\n");
    } catch (error) {
      debugPrint("\nError while stopping alarm audio : $error\n");
    }
  });


  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }
}

/// Alarm callback method, should be called when alarm triggered
@pragma('vm:entry-point') // Required for AOT compilation
void alarmCallback(int id, Map<String, dynamic> params) async {
  FlutterBackgroundService service = FlutterBackgroundService();
  bool isRunning = await service.isRunning();

  // ignore: unused_local_variable
  final String title = params["title"];
  // ignore: unused_local_variable
  final String body = params["body"];
  final int alarmID = id;

  ///Canceling the alarm immediately after it fires
  await AndroidAlarmManager.cancel(alarmID);

  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("\nAlarm triggered!\n");
    debugPrint("\nBackground Service Starting...\n");

    if (!isRunning) {
      await service.startService();
    }

    service.invoke('play_audio');

    Timer(Duration(minutes: 1), () {
      service.invoke("stop_audio");
    });
  } catch (error) {
    debugPrint("\nError while triggering alarm : $error\n");
  }

  // final AudioPlayer _audioPlayer = AudioPlayer();
  // String demoAudioPath = "musics/waves-02.mp3";
  //
  // try {
  //    _audioPlayer.play(AssetSource(demoAudioPath), volume: 1,);
  //    final notificationService = NotificationServices();
  //    initializeTimeZones();
  //     notificationService.initialize();
  //
  //    NotificationServices.scheduledNotification("Manual Alarm triggered", "This is alarm body");
  //   //  Future.delayed(Duration(seconds: 10));
  //     //_audioPlayer.stop();
  // } catch (e) {
  //   print("\nError playing audio: $e/n");
  // }
  //FlutterBackgroundService().invoke("play_audio");
}

class ReminderScreenProvider with ChangeNotifier {
  ReminderScreenProvider() {
    getReminders();
  }

  /// Reminders model instances
  ReminderModel? _reminders;
  ReminderModel? get reminders => _reminders;

  /// Reminder that will edit (Setup screen)
  ReminderList? _reminderToSetup;
  ReminderList? get reminderToSetup => _reminderToSetup;

  // ignore: unused_field
  int _setupReminderIndex = -1;
  /// On setup button pressed
  void onSetup(int index) {
    _setupReminderIndex = index;
    _reminderToSetup = _reminders!.reminderList![index];
    debugPrint(
      "\nReminder to setup : ${_reminderToSetup
          ?.timer}\nReminder id  : ${_reminderToSetup?.reminderId}\norginal reminder id : ${_reminders!.reminderList![index].reminderId}\n",
    );
    _repetitionDay = List<bool>.filled(7, false);
    if (_reminderToSetup?.repeatingDays != null ||
        _reminderToSetup!.repeatingDays!.isNotEmpty)
      {
      for (var day in _reminderToSetup!.repeatingDays!) {
        if (day == 'Sunday') {
          _repetitionDay[0] = true;
        }
        else if (day == 'Monday') {
          _repetitionDay[1] = true;
        }
        else if (day == 'Tuesday') {
          _repetitionDay[2] = true;
        }

        else if (day == 'Wednesday') {
          _repetitionDay[3] = true;
        }
        else if (day == 'Thursday') {
          _repetitionDay[4] = true;
        }
        else if (day == 'Friday') {
          _repetitionDay[5] = true;
        }
        else if (day == 'Saturday') {
          _repetitionDay[6] = true;
        }
      }
      }
    debugPrint("\nRepetition days : ${_reminderToSetup?.repeatingDays}\n");
    notifyListeners();
  }

  /// Fetch reminder list from local storage
  Future<void> getReminders() async {
    var rawReminderDataFromHive = await HiveServices.fetchHiveData(
      boxName: 'reminderBox',
      modelName: 'ReminderModel',
    );
    if (rawReminderDataFromHive != null) {
      _reminders = ReminderModel.fromJson(rawReminderDataFromHive);
    }
    notifyListeners();
  }

  int _selectedHour =
      DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour;
  int get selectedHour => _selectedHour;
  int _selectedMinute =
      DateTime.now().minute >= 50
          ? DateTime.now().minute
          : DateTime.now().minute + 10;
  int get selectedMinute => _selectedMinute;
  String _selectedAmPm = DateTime.now().hour > 12 ? 'PM' : 'AM';
  String get selectedAmPm => _selectedAmPm;
  String _reminderType = "Focus";
  final List<String> _reminderTypeList = ['Focus', 'Sleep', 'Breath', 'Meditation', 'Nap', 'General',];
  List<String> get reminderTypeList => _reminderTypeList;

  /// Reminder type or title
  void onReminderTypeSelect(String type) {
    _reminderType = type;
    notifyListeners();
  }

  List<bool> _repetitionDay = List<bool>.filled(7, false);
  List<bool> get repetitionDay => _repetitionDay;

  /// on select repeating day in dropdown
  void onSelectRepeat(int index, bool value) {
    if (value == true) {
      debugPrint("\n$index number day will repeat.\n");
    } else {
      debugPrint("\n$index number day will not repeat.\n");
    }
    _repetitionDay[index] = value;
    notifyListeners();

    if (index == 0) {
      updateRepeatDays('Sunday', value);
    }
    else if (index == 1) {
      updateRepeatDays('Monday', value);
    }
    else if (index == 2) {
      updateRepeatDays('Tuesday', value);
    }
    else if (index == 3) {
      updateRepeatDays('Wednesday', value);
    }
    else if (index == 4) {
      updateRepeatDays('Thursday', value);
    }
    else if (index == 5) {
      updateRepeatDays('Friday', value);
    }
    else if (index == 6) {
      updateRepeatDays('Saturday', value);
    }
  }

  void onAutoRepetition(){
    for(int index = 0; index<_repetitionDay.length; index++){
      if (index == 0) {
        updateRepeatDays('Sunday', _repetitionDay[index]);
      }
      else if (index == 1) {
        updateRepeatDays('Monday', _repetitionDay[index]);
      }
      else if (index == 2) {
        updateRepeatDays('Tuesday', _repetitionDay[index]);
      }
      else if (index == 3) {
        updateRepeatDays('Wednesday', _repetitionDay[index]);
      }
      else if (index == 4) {
        updateRepeatDays('Thursday', _repetitionDay[index]);
      }
      else if (index == 5) {
        updateRepeatDays('Friday', _repetitionDay[index]);
      }
      else if (index == 6) {
        updateRepeatDays('Saturday', _repetitionDay[index]);
      }
    }
  }

  List<String> _selectedRepeatDays = [];

  void updateRepeatDays(String day, bool isSelected) {
    if (isSelected) {
      if (!_selectedRepeatDays.contains(day)) {
        _selectedRepeatDays.add(day);
        notifyListeners();
      }
    } else {
      _selectedRepeatDays.remove(day);
      notifyListeners();
    }
    debugPrint("\nDays to repeat : $_selectedRepeatDays\n");
  }

  ///Set alarm hour
  void setHour(int selectedH) {
    _selectedHour = selectedH;
    debugPrint("\nSelected hour : $selectedH\n");
    notifyListeners();
  }

  ///Set alarm minute
  void setMinute(int selectedM) {
    _selectedMinute = selectedM;
    debugPrint("\nSelected minute : $selectedM\n");
    notifyListeners();
  }

  ///Set alarm am/pm
  void setAmPm(int selectedAmPm) {
    if (selectedAmPm == -1) {
      _selectedAmPm = 'AM';
    } else if (selectedAmPm == -2) {
      _selectedAmPm = 'PM';
    }
    debugPrint("\nSelected am / pm : $selectedAmPm\n");
    notifyListeners();
  }



  Future<void> addReminder(DateTime time) async {
    String daysShortForm = "";
    if (_selectedRepeatDays.isNotEmpty) {
      for (String day in _selectedRepeatDays) {
        daysShortForm += day[0];
      }
    }
    else {
      daysShortForm = "Ring Once";
    }
    debugPrint("\nDays to repeat : $daysShortForm\n");
    //  Ensure _reminders is initialized
    _reminders ??= ReminderModel(reminderList: []);

    //  Ensure reminderList is initialized
    _reminders!.reminderList ??= [];
    debugPrint(
      "\nAdding this time to reminder : ${DateFormat('hh:mma').format(time).toLowerCase()}\n",
    );

    int convertedHour = _selectedHour > 12 ? _selectedHour - 12 : _selectedHour;
    int reminderId = DateTime.now().millisecondsSinceEpoch.remainder(100000) + Random().nextInt(11000);
    _reminders?.reminderList?.add(
      ReminderList(
        title: _reminderType,
        timer: DateFormat('hh:mma').format(time).toLowerCase(),
        hours: convertedHour,
        minutes: _selectedMinute,
        amPm: _selectedAmPm,
        reminderId: reminderId,
        reminderType: _reminderType,
        daysShortForm: daysShortForm,
        repeatingDays: _selectedRepeatDays,
        alarmId: _alarmId
      ),
    );

    debugPrint(
      "\nReminder list length : ${_reminders?.reminderList?.length}\n",
    );

    _alarmId = [];
    notifyListeners();

    await HiveServices.saveToHive(
      boxName: 'reminderBox',
      modelName: 'ReminderModel',
      encodedJsonData: jsonEncode(
        ReminderModel(reminderList: _reminders?.reminderList).toJson(),
      ),
    );

  }

  List<int> _alarmId  = [];

  int _wakeUpAlarmId = 0;
  Future<void> cancelWakeAlarm() async {
    try{
      debugPrint("\nwake up alarm id : $_wakeUpAlarmId\n");
      await AndroidAlarmManager.cancel(_wakeUpAlarmId);
      await FlutterLocalNotificationsPlugin().cancel(_wakeUpAlarmId);
      debugPrint("\n Wake up Alarm and notification cancel successful!\n");
      _wakeUpAlarmId = 0;
    }catch(error){
      debugPrint("\nError while cancelling wake up alarm : $error\n");
    }

  }


  ///convert user inputted time to DateTime object
  Future<void> setAlarm({required bool isWakeUp,}) async {
    try {
      if(!isWakeUp){
        onAutoRepetition();
      }

      debugPrint(
        "\n_Selected hour : $_selectedHour, minute : $_selectedMinute\n",
      );

      _selectedHour =
          ((_selectedAmPm == "PM") && (_selectedHour != 12))
              ? _selectedHour + 12
              : (_selectedAmPm == "AM" && _selectedHour == 12)
              ? 0
              : _selectedHour; // Handle midnight (12 AM → 00:00)

      DateTime now = DateTime.now();

      ///set the exact alarm time
      _selectedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedHour,
        _selectedMinute,
      );

      /// If the selected time is in the past, schedule for tomorrow
      if (_selectedTime.isBefore(now)) {
        _selectedTime = _selectedTime.add(Duration(days: 1));
      }
      debugPrint("\n selected time : $_selectedTime\n");


    //  await addReminder(_selectedTime);

      debugPrint("\nBefore starting repetition alarm, repetition list length : ${_selectedRepeatDays.length}\n");


      if(isWakeUp == false){
        if (_selectedRepeatDays.isNotEmpty) {
          for (String day in _selectedRepeatDays) {
            int tempAlarmId = DateTime.now().millisecondsSinceEpoch.remainder(100000) + Random().nextInt(10000);
            _alarmId.add(tempAlarmId);

            debugPrint("\nAlarm id : $tempAlarmId\n}");
            //72091
            DateTime nextAlarm = _getNextOccurrence(
              day,
              _selectedHour,
              _selectedMinute,
            );
            debugPrint("\nNext alarm : $nextAlarm\n");
            ///difference between now and alarm time
            Duration difference = nextAlarm.difference(now);
            debugPrint("\nDifference between now and alarm time : $difference\n");

            ///Initialize time zone for showing alarm notification using local time zone
            ///   initializeTimeZones();

            ///Initialize notification
            //    final notificationService = NotificationServices();
            //  notificationService.initialize();


            NotificationServices.scheduledNotification(
                "Sleep Soundscape",
                _reminderType,
                difference,
                tempAlarmId
            );
            debugPrint(
                "\nScheduling one-time alarm for dat : ${nextAlarm.day} and today is ${now.day} at $nextAlarm\n");
            if (nextAlarm.day == now.day && nextAlarm.isAfter(now)) {
              debugPrint(
                  "\nScheduling one-time alarm for ${nextAlarm.day} and today is ${now.day} at $nextAlarm\n");

              bool scheduledToday = await AndroidAlarmManager.oneShotAt(
                nextAlarm,
                tempAlarmId,
                alarmCallback,
                exact: true,
                wakeup: true,
                allowWhileIdle: true,
                alarmClock: true,
                rescheduleOnReboot: true,
                params: {
                  "title": "Alarm Title",
                  "body": "Alarm Body",
                },
              );

              if (scheduledToday) {
                debugPrint(
                    "\nOne-time Alarm Scheduled for today at $nextAlarm\n");
              } else {
                debugPrint("\nFailed to schedule one-time alarm for today.\n");
              }
            }

            bool scheduled = await AndroidAlarmManager.periodic(
              Duration(days: 7),
              tempAlarmId,
              alarmCallback,
              startAt: nextAlarm,
              exact: true,
              wakeup: true,
              rescheduleOnReboot: true,

              ///This parameter will pass to alarmCallBack
              params: {
                "title": "Alarm Title",
                "body": "Alarm Body",
              },
            );
            debugPrint(
              scheduled
                  ? "\nRepeating Alarm Scheduled for $day from $nextAlarm\n"
                  : "\nFailed to schedule alarm for $day\n",
            );
          }
        }
        else {
          int tempAlarmId = DateTime.now().millisecondsSinceEpoch.remainder(100000) + Random().nextInt(10000);
          _alarmId.add(tempAlarmId);
          debugPrint("\nAlarm id : $tempAlarmId\n}");
          ///difference between now and alarm time
          Duration difference = _selectedTime.difference(now.subtract(Duration(milliseconds: 100)));

          ///Initialize time zone for showing alarm notification using local time zone
          ///initializeTimeZones();

          ///Initialize notification
          // final notificationService = NotificationServices();
          // notificationService.initialize();

          NotificationServices.scheduledNotification(
              "Sleep Soundscape",
              _reminderType,
              difference,
              tempAlarmId
          );




          ///Alarm scheduling
          bool scheduled = await AndroidAlarmManager.oneShotAt(
            ///This is alarm time (When alarm should triggered)
            _selectedTime,

            ///This is alarm id (alarm id should be unique for each alarm)
            tempAlarmId,

            ///This is background service, when alarm time comes, this method will trigger
            alarmCallback,

            ///Turn on alarm clock
            alarmClock: true,

            ///Ring alarm when phone is in idle
            allowWhileIdle: true,

            ///Re-schedule alarm after the mobile re-boot or re-start, if it false, the alarm will not re-scheduled after
            ///re-boot or power off - on
            rescheduleOnReboot: true,

            ///This parameter will pass to alarmCallBack
            params: {
              "title": "Alarm Title",
              "body": "Alarm Body",
            },

            ///If true, the alarm will trigger at the exact specified time.
            /// If false, the system may delay the alarm slightly to optimize battery performance.
            exact: true,

            ///If true, the alarm wakes up the device if it’s sleeping.
            /// If false, the alarm only triggers when the device is already awake.
            wakeup: true,
          );

          debugPrint("\nAlarm Scheduled : $scheduled\n");
        }
      }
      else{
        int tempAlarmId = DateTime.now().millisecondsSinceEpoch.remainder(100000) + Random().nextInt(10000);
        _wakeUpAlarmId = tempAlarmId;
        debugPrint("\nAlarm id : $tempAlarmId\n}");
        ///difference between now and alarm time
        Duration difference = _selectedTime.difference(now.subtract(Duration(milliseconds: 100)));

        ///Initialize time zone for showing alarm notification using local time zone
        ///initializeTimeZones();

        ///Initialize notification
        // final notificationService = NotificationServices();
        // notificationService.initialize();

        NotificationServices.scheduledNotification(
            "Sleep Soundscape",
            "Wake up time",
            difference,
            tempAlarmId
        );




        ///Alarm scheduling
        bool scheduled = await AndroidAlarmManager.oneShotAt(
          ///This is alarm time (When alarm should triggered)
          _selectedTime,

          ///This is alarm id (alarm id should be unique for each alarm)
          tempAlarmId,

          ///This is background service, when alarm time comes, this method will trigger
          alarmCallback,

          ///Turn on alarm clock
          alarmClock: true,

          ///Ring alarm when phone is in idle
          allowWhileIdle: true,

          ///Re-schedule alarm after the mobile re-boot or re-start, if it false, the alarm will not re-scheduled after
          ///re-boot or power off - on
          rescheduleOnReboot: true,

          ///This parameter will pass to alarmCallBack
          params: {
            "title": "Alarm Title",
            "body": "Alarm Body",
          },

          ///If true, the alarm will trigger at the exact specified time.
          /// If false, the system may delay the alarm slightly to optimize battery performance.
          exact: true,

          ///If true, the alarm wakes up the device if it’s sleeping.
          /// If false, the alarm only triggers when the device is already awake.
          wakeup: true,
        );

        debugPrint("\nAlarm Scheduled : $scheduled\n");
      }


      if(isWakeUp == false){
        await addReminder(_selectedTime);
      }



        debugPrint("\nSelected hour before subtruct : $_selectedHour\n");
        _selectedHour = _selectedHour > 12 ? _selectedHour - 12 : _selectedHour;
        _selectedRepeatDays.clear();
        notifyListeners();


    } catch (error) {
      debugPrint("\nerror while saving alarm : $error\n");
    }
  }

  void clearRepeatingDay(){
    _selectedRepeatDays.clear();
    _repetitionDay = List<bool>.filled(7, false);
    notifyListeners();
  }

  /// Get next occurrence of a given day with time
  DateTime _getNextOccurrence(String dayName, int hour, int minute) {
    DateTime now = DateTime.now();
    int todayWeekday = now.weekday; // Monday = 1, Sunday = 7
    int targetWeekday = _getWeekdayFromName(dayName);

    // ✅ If today is the selected repeat day AND the time is still in the future, schedule for today
    if (todayWeekday == targetWeekday) {
      DateTime todayAlarm = DateTime(now.year, now.month, now.day, hour, minute);
      if (todayAlarm.isAfter(now)) {
        return todayAlarm;
      }
    }

    // ✅ Otherwise, schedule for the next occurrence of the selected day
    int daysUntilNext = (targetWeekday - todayWeekday) % 7;
    if (daysUntilNext == 0) {
      daysUntilNext = 7; // If today has passed, move to next week
    }

    DateTime targetDate = now.add(Duration(days: daysUntilNext));
    return DateTime(targetDate.year, targetDate.month, targetDate.day, hour, minute);
  }

  /// Convert day name to weekday number
  int _getWeekdayFromName(String dayName) {
    const Map<String, int> weekdays = {
      "sunday": DateTime.sunday,
      "monday": DateTime.monday,
      "tuesday": DateTime.tuesday,
      "wednesday": DateTime.wednesday,
      "thursday": DateTime.thursday,
      "friday": DateTime.friday,
      "saturday": DateTime.saturday,
    };

    return weekdays[dayName.toLowerCase()] ?? DateTime.monday;
  }


  /// Cancel a alarm
  Future<void> cancelAlarm(int alarmId) async {
    bool success = await AndroidAlarmManager.cancel(alarmId);
    if (success) {
      debugPrint("\nAlarm $alarmId cancelled successfully.\n");
    } else {
      debugPrint("\nFailed to cancel alarm $alarmId.\n");
    }
  }

  Future<void> cancelAndDeleteAlarm() async {
    for(int id in _reminderToSetup!.alarmId!){
      bool success = await AndroidAlarmManager.cancel(id);
      _reminders!.reminderList!.removeWhere((alarm)=>alarm.reminderId == _reminderToSetup!.reminderId);
      if (success) {
        debugPrint("\nFor reminder ${_reminderToSetup!.reminderId} Alarm $id cancelled successfully.\n");
      } else {
        debugPrint("\nFor reminder ${_reminderToSetup!.reminderId} Failed to cancel alarm $id.\n");
      }
    }



    notifyListeners();
  }

  ///Setting Alarm/Reminder
  DateTime _selectedTime = DateTime.now().add(Duration(seconds: 5));
  DateTime get selectedTime => _selectedTime;
}
