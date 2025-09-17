import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// AuthStorageService (unchanged from your provided code)
class AuthStorageService {
  // ignore: unused_field
  static const String _tokenKey = "token";



  /// Store token
  static Future<void> saveToSharedPreferences({required String fieldName, required String value,}) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fieldName, value);
    }catch(error){
      debugPrint("\nError while saving token : $error\n");
    }
  }



  /// Get token
  static Future<String?> fetchFromSharedPreferences({required String fieldName}) async {
    final prefs = await SharedPreferences.getInstance();

      String? value = prefs.getString(fieldName);
    return value;
  }

  // static Future<String?> getName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_name);
  // }
  //
  // static Future<String?> getEmail() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_email);
  // }
  //
  // static Future<String?> getImage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_image);
  // }

  /// Delete token
  static Future<void> removeToken({required String fieldName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(fieldName);
  }


}