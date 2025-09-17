import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../api_services/hive_service.dart';
import '../model/SettingsModel.dart';

class NotificationProvider with ChangeNotifier {
  late SettingsModel _settingsModel;

  SettingsModel get settingsModel => _settingsModel;

  bool get isNotificationOn =>
      _settingsModel.settings.notificationSettings.notificationOn;

  bool get isRingOnSilent =>
      _settingsModel.settings.notificationSettings.ringOnSilent;

  bool get isPopupAlertOn =>
      _settingsModel.settings.notificationSettings.popUpAlert;

  NotificationProvider() {
    _settingsModel = SettingsModel(
      settings: Settings(
        notificationSettings: NotificationSettings(
          notificationOn: false,
          ringOnSilent: false,
          popUpAlert: false,
        ),
        language: Language(appLanguage: "English"),
      ),
    );

    loadSettings();
  }

  Future<void> loadSettings() async {
    dynamic rawData = await HiveServices.fetchHiveData(
      boxName: 'notificationBox',
      modelName: 'notificationSettings',
    );

    debugPrint("data from hive: $rawData");

    if (rawData != null && rawData is Map<String, dynamic>) {
      try {
        _settingsModel = SettingsModel.fromJson(rawData);
        debugPrint("\n Loaded settings from Hive: $_settingsModel\n");
      } catch (e) {
        debugPrint("\n Error decoding settings from Hive: $e\n");
      }
      notifyListeners();
    } else {
      debugPrint("\n No saved settings found, using defaults.\n");
    }
  }

  Future<void> saveSettings() async {
    try {
      String encodedData = jsonEncode(_settingsModel.toJson());
      await HiveServices.saveToHive(
        boxName: 'notificationBox',
        modelName: 'notificationSettings',
        encodedJsonData: encodedData,
      );
      debugPrint("\n Settings saved successfully to Hive!\n");
    } catch (e) {
      debugPrint("\n Error saving settings to Hive: $e\n");
    }
    notifyListeners();
  }

  void toggleNotificationSwitch() {
    _settingsModel.settings.notificationSettings.notificationOn =
        !_settingsModel.settings.notificationSettings.notificationOn;
    saveSettings();
    notifyListeners();
  }

  void toggleRingOnSilentSwitch() {
    _settingsModel.settings.notificationSettings.ringOnSilent =
        !_settingsModel.settings.notificationSettings.ringOnSilent;
    saveSettings();
    notifyListeners();
  }

  void togglePopupAlertSwitch() {
    _settingsModel.settings.notificationSettings.popUpAlert =
        !_settingsModel.settings.notificationSettings.popUpAlert;
    saveSettings();
    notifyListeners();
  }
}
