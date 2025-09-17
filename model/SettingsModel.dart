class SettingsModel {
  Settings settings;

  SettingsModel({required this.settings});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      settings: Settings.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settings': settings.toJson(),
    };
  }
}

class Settings {
  NotificationSettings notificationSettings;
  Language language;

  Settings({required this.notificationSettings, required this.language});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      notificationSettings: NotificationSettings.fromJson(json['notificationSettings'] ?? {}),
      language: Language.fromJson(json['language'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationSettings': notificationSettings.toJson(),
      'language': language.toJson(),
    };
  }
}

class NotificationSettings {
  bool notificationOn;
  bool ringOnSilent;
  bool popUpAlert;

  NotificationSettings({
    required this.notificationOn,
    required this.ringOnSilent,
    required this.popUpAlert,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      notificationOn: json['notification_on'] ?? false,
      ringOnSilent: json['ring_on_silent'] ?? false,
      popUpAlert: json['pop_up_alert'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_on': notificationOn,
      'ring_on_silent': ringOnSilent,
      'pop_up_alert': popUpAlert,
    };
  }
}

class Language {
  String appLanguage;

  Language({required this.appLanguage});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      appLanguage: json['app_language'] ?? "English",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_language': appLanguage,
    };
  }
}
