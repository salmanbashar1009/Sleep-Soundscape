class SoundSettingModel {
  Alarm alarm;
  SleepAnalysis sleepAnalysis;
  Soundscapes soundscapes;
  Advanced advanced;

  SoundSettingModel({
    Alarm? alarm,
    SleepAnalysis? sleepAnalysis,
    Soundscapes? soundscapes,
    Advanced? advanced,
  })  : alarm = alarm ?? Alarm(),
        sleepAnalysis = sleepAnalysis ?? SleepAnalysis(),
        soundscapes = soundscapes ?? Soundscapes(),
        advanced = advanced ?? Advanced();

  SoundSettingModel.fromJson(Map<String, dynamic> json)
      : alarm = Alarm.fromJson(json['alarm'] ?? {}),
        sleepAnalysis = SleepAnalysis.fromJson(json['sleep_analysis'] ?? {}),
        soundscapes = Soundscapes.fromJson(json['soundscapes'] ?? {}),
        advanced = Advanced.fromJson(json['advanced'] ?? {});

  Map<String, dynamic> toJson() {
    return {
      'alarm': alarm.toJson(),
      'sleep_analysis': sleepAnalysis.toJson(),
      'soundscapes': soundscapes.toJson(),
      'advanced': advanced.toJson(),
    };
  }
}

class Alarm {
  bool enabled;
  bool vibration;
  double volume;
  Ringtone ringtone;

  Alarm({bool? enabled, bool? vibration, double? volume, Ringtone? ringtone})
      : enabled = enabled ?? false,
        vibration = vibration ?? false,
        volume = volume ?? 1.0,
        ringtone = ringtone ?? Ringtone();

  Alarm.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] ?? false,
        vibration = json['vibration'] ?? false,
        volume = (json['volume'] as num?)?.toDouble() ?? 1.0,
        ringtone = Ringtone.fromJson(json['ringtone'] ?? {});

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'vibration': vibration,
      'volume': volume,
      'ringtone': ringtone.toJson(),
    };
  }
}

class Ringtone {
  String name;
  String ringTonPath;

  Ringtone({String? name, String? ringTonPath})
      : name = name ?? "ringtone",
        ringTonPath = ringTonPath ??
            "http://192.168.40.10:1000/uploads/1740800265639-fire-01.mp3";

  Ringtone.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? "ringtone",
        ringTonPath = json['file'] ?? "http://192.168.40.10:1000/uploads/default.mp3";

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file': ringTonPath,
    };
  }
}

class SleepAnalysis {
  SoundsDetection soundsDetection;

  SleepAnalysis({SoundsDetection? soundsDetection})
      : soundsDetection = soundsDetection ?? SoundsDetection();

  SleepAnalysis.fromJson(Map<String, dynamic> json)
      : soundsDetection = SoundsDetection.fromJson(json['sounds_detection'] ?? {});

  Map<String, dynamic> toJson() {
    return {'sounds_detection': soundsDetection.toJson()};
  }
}

class SoundsDetection {
  bool enabled;
  bool audioRecordingClean;
  String description;

  SoundsDetection({bool? enabled, bool? audioRecordingClean, String? description})
      : enabled = enabled ?? false,
        audioRecordingClean = audioRecordingClean ?? false,
        description = description ?? "";

  SoundsDetection.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] ?? false,
        audioRecordingClean = json['audioRecordingClean'] ?? false,
        description = json['description'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'audioRecordingClean': audioRecordingClean,
      'description': description,
    };
  }
}

class Soundscapes {
  String current;
  bool alarmAutoplay;
  int audioTimer;
  String audioPath;

  Soundscapes({String? current, bool? alarmAutoplay, int? audioTimer, String? audioPath})
      : current = current ?? "default",
        alarmAutoplay = alarmAutoplay ?? false,
        audioTimer = audioTimer ?? 60,  // Set default value to 60 seconds
        audioPath = audioPath ?? "http://default-audio.mp3";

  Soundscapes.fromJson(Map<String, dynamic> json)
      : current = json['current'] ?? "default",
        alarmAutoplay = json['alarm_autoplay'] ?? false,
        audioTimer = json['audio_timer'] ?? 60,  // Set default value to 60 seconds
        audioPath = json['audio_path'] ?? "http://default-audio.mp3";


  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'alarm_autoplay': alarmAutoplay,
      'audio_timer': audioTimer,
      'audio_path': audioPath,
    };
  }
}

class Advanced {
  int snooze;
  int shakeTime;
  String alarmMode;
  bool getUpChallenge;

  Advanced({int? snooze, int? shakeTime, String? alarmMode, bool? getUpChallenge})
      : snooze = snooze ?? 5,
        shakeTime = shakeTime ?? 5,
        alarmMode = alarmMode ?? "normal",
        getUpChallenge = getUpChallenge ?? false;

  Advanced.fromJson(Map<String, dynamic> json)
      : snooze = json['snooze'] ?? 5,
        shakeTime = json['shakeTime'] ?? 5,
        alarmMode = json['alarm_mode'] ?? "normal",
        getUpChallenge = json['get_up_challenge'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'snooze': snooze,
      'shakeTime': shakeTime,
      'alarm_mode': alarmMode,
      'get_up_challenge': getUpChallenge,
    };
  }
}
