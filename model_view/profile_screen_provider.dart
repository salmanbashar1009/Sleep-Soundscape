import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_services.dart';
import '../api_services/api_end_point.dart';
import '../api_services/local_storage_services.dart';
import '../model/JoiningDateModel.dart';

class ProfileScreenProvider with ChangeNotifier {
  late Timer _timer;
  Map<String, int> _dailyUsageMap = {};
  String? _joiningDate;
  String _daysAgo = "";

  ProfileScreenProvider() {
    _loadDailyUsage();
    _startTracking();
    fetchJoiningDate();
  }

  Map<String, int> get dailyUsageMap => _dailyUsageMap;
  String? get joiningDate => _joiningDate;
  String get daysAgo => _daysAgo;

  /// Load stored usage data
  Future<void> _loadDailyUsage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dailyUsageMap = Map<String, int>.from(prefs.getStringList('daily_usage')?.asMap().map(
          (key, value) => MapEntry(value.split('|')[0], int.parse(value.split('|')[1])),
    ) ?? {});
    _cleanupOldData(); // Remove data older than 3 months
    notifyListeners();
  }

  /// Start tracking time per day
  void _startTracking() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      String today = DateTime.now().toIso8601String().split("T")[0];

      _dailyUsageMap[today] = (_dailyUsageMap[today] ?? 0) + 1; // Increment usage in minutes
      notifyListeners();

      _saveUsageData();
    });
  }

  /// Fetch joining date from API using Isolate
  Future<void> fetchJoiningDate() async {
    try {
      final token = await AuthStorageService.fetchFromSharedPreferences(fieldName: "userToken");
      if (token == null || token.isEmpty) {
        debugPrint("Error: No authentication token found.");
        return;
      }

      final result = await Isolate.run(() => _performApiCall(token));

      if (result["status"] == "success") {
        _joiningDate = result["joiningDate"];
        _daysAgo = _joiningDate ?? "";
        notifyListeners();
      } else {
        debugPrint("Failed to fetch joining date: ${result['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching joining date: $e");
    }
  }

  /// Perform API call in an Isolate
  static Future<Map<String, dynamic>> _performApiCall(String token) async {
    try {
      final response = await ApiServices.getApi(
        url: AppUrls.joiningDate,
        header: token,
      );

      if (response is http.Response) {
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          debugPrint("API Response created date: $responseData");
          JoiningDateModel joiningDateModel = JoiningDateModel.fromJson(responseData);
          return {"status": "success", "joiningDate": joiningDateModel.joiningDate};
        } else {
          return {"status": "error", "message": response.body};
        }
      }
      return {"status": "error", "message": "Invalid response"};
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  /// Remove data older than 3 months
  void _cleanupOldData() async {
    DateTime threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    _dailyUsageMap.removeWhere((date, _) => DateTime.parse(date).isBefore(threeMonthsAgo));
    _saveUsageData();
  }

  /// Save updated usage data
  Future<void> _saveUsageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usageList = _dailyUsageMap.entries.map((e) => "${e.key}|${e.value}").toList();
    await prefs.setStringList('daily_usage', usageList);
  }

  /// Get heatmap color level based on minutes
  int getUsageLevel(int minutes) {
    if (minutes < 60) return 1;
    if (minutes < 120) return 2;
    if (minutes < 180) return 3;
    return 4;
  }

  /// Stop tracking when disposing
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
