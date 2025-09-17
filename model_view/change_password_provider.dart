import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_services/api_end_point.dart';
import '../api_services/local_storage_services.dart';

class ChangePasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _issuccessfull = false;
  String? _errorMessage;

  bool _isCurrentPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  bool get isCurrentPasswordObscure => _isCurrentPasswordObscure;
  bool get isNewPasswordObscure => _isNewPasswordObscure;
  bool get isConfirmPasswordObscure => _isConfirmPasswordObscure;

  // Method to toggle visibility for the current password field
  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordObscure = !_isCurrentPasswordObscure;
    notifyListeners();
  }

  // Method to toggle visibility for the new password field
  void toggleNewPasswordVisibility() {
    _isNewPasswordObscure = !_isNewPasswordObscure;
    notifyListeners();
  }

  // Method to toggle visibility for the confirm password field
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
    notifyListeners();
  }


  bool get isLoading => _isLoading;
  bool get issuccessfull => _issuccessfull;

  String? get errorMessage => _errorMessage;

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _issuccessfull = false;
    _errorMessage = null;
    notifyListeners();

    try {
      String? token = await AuthStorageService.fetchFromSharedPreferences(
        fieldName: "userToken",
      );
      if (token == null || token.isEmpty) {
        _errorMessage = "User token is missing";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final body = jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      });

      final headers = {
        "Authorization": token,
        "Content-Type": "application/json",
      };

      final response = await http.patch(
        Uri.parse(AppUrls.changePassword),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Password change successful
        _isLoading = false;
        _issuccessfull = true;
        notifyListeners();
      } else {
        // Handle error
        _errorMessage = "Failed to change password: ${response.body}";
        _isLoading = false;
        _issuccessfull = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Password change failed: $e";
      _isLoading = false;
      notifyListeners();
    }
  }
}
