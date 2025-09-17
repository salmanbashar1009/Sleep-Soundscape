class ReminderModel {
  List<ReminderList>? reminderList;

  ReminderModel({this.reminderList});

  ReminderModel.fromJson(Map<String, dynamic> json) {
    reminderList = (json['reminderList'] as List?)
        ?.map((e) => ReminderList.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderList': reminderList?.map((e) => e.toJson()).toList(),
    };
  }
}

class ReminderList {
  int reminderId;
  String title;
  String timer;
  int hours;
  int minutes;
  String? amPm;
  List<int>? alarmId;
  String? reminderType;
  String? daysShortForm;
  List<String>? repeatingDays;

  ReminderList({
    required this.reminderId,
    required this.title,
    required this.timer,
    required this.hours,
    required this.minutes,
    this.amPm,
    this.alarmId,
    this.reminderType,
    this.daysShortForm,
    this.repeatingDays,
  });

  ReminderList.fromJson(Map<String, dynamic> json)
      : reminderId = json['reminderId'],
        title = json['title'] ?? '',
        timer = json['timer'] ?? '',
        hours = json['hours'] ?? 0,
        minutes = json['minutes'] ?? 0,
        amPm = json['amPm'],
        reminderType = json['reminderType'],
        daysShortForm = json['daysShortForm'],
        alarmId = (json['alarmId'] as List?)?.map((e) => e as int).toList() ?? [],
        repeatingDays = (json['repeatingDays'] as List?)?.map((e) => e as String).toList() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'reminderId' : reminderId,
      'title': title,
      'timer': timer,
      'hours': hours,
      'minutes': minutes,
      'amPm': amPm,
      'alarmId': alarmId,
      'reminderType': reminderType,
      'daysShortForm': daysShortForm,
      'repeatingDays': repeatingDays,
    };
  }
}
