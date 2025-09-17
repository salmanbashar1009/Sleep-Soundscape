import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_end_point.dart';

import '../api_services/hive_service.dart';
import '../model/login_data_model.dart';

class DeleteUserProvider with ChangeNotifier {
  DeleteUserProvider() {
    fetchUserData();
    cleanError();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSucced = false;
  bool get isSucced => _isSucced;

  String? _error;

  void cleanError() {
    _error = "";
    notifyListeners();
  }
  String? get error => _error;

  double _deleteProgress = 0.0;
  double get deleteProgress => _deleteProgress;
  Timer? _timer;
  static const int holdDuration = 1500;

  void startProgress(VoidCallback onCompleted) {
    _timer?.cancel();
    _deleteProgress = 0.0;
    notifyListeners();

    int interval = 50;
    int totalSteps = holdDuration ~/ interval;

    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      _deleteProgress += 1 / totalSteps;
      notifyListeners();

      if (_deleteProgress >= 1.0) {
        _timer?.cancel();
        onCompleted();
      }
    });
  }

  void cancelProgress() {
    _timer?.cancel();
    _deleteProgress = 0.0;
    notifyListeners();
  }

  LoginDataModel? _loginData;
  LoginDataModel? get loginData => _loginData;

  Future<void> fetchUserData() async {
    var rawJsonDecodedData = await HiveServices.fetchHiveData(
      boxName: 'userData',
      modelName: 'user',
    );

    if (rawJsonDecodedData != null &&
        rawJsonDecodedData.toString().isNotEmpty) {
      debugPrint("\nfetched user data : $rawJsonDecodedData\n");
      _loginData = LoginDataModel.fromJson(rawJsonDecodedData);
    } else {
      _loginData = LoginDataModel();
    }
    notifyListeners();
  }

  Future<void> deleteUser(String email, String password) async {
    _isLoading = true;
    _isSucced = false;
    _error = "";
    notifyListeners();

    final body = {"email": email.trim(), "password": password.trim()};

    try {
      final response = await http.delete(
        Uri.parse(AppUrls.deleteAccount),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final decodedata = jsonDecode(response.body);
      debugPrint("\n\n Server Response: $decodedata \n\n");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isSucced = true;
        String message = decodedata['message'] ?? "Account deleted successfully!";
        debugPrint("\n\n Success: $message \n\n");
      } else {
        _error = decodedata['message'] ?? "Failed to delete account. Error: $decodedata";
        debugPrint("\n\n Error: $_error \n\n");
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("\n\n Error: $_error \n\n");
    }

    _isLoading = false;
    notifyListeners();
  }

}
