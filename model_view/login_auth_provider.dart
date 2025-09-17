import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/local_storage_services.dart';

import '../api_services/api_end_point.dart';
import '../api_services/api_services.dart';
import '../api_services/hive_service.dart';
import '../model/login_data_model.dart';

class LoginAuthProvider with ChangeNotifier {

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;

  void onObscure(){
    _isObscureText = !_isObscureText;
    notifyListeners();
  }

  bool _isLoginProgress = false;
  bool _isSuccess = false;

  bool get isLoginProgress => _isLoginProgress;
  bool get isSuccess => _isSuccess;

  // Store login data
  LoginDataModel? _loginData;
  LoginDataModel? get loginData => _loginData;

  // Store user data
  User? _userData;
  User? get userData => _userData;

  String? _userToken;
  String? get userToken => _userToken;



  // Fetch user data from Hive
  Future<void> fetchUserData() async {

    var rawJsonDecodedData = await HiveServices.fetchHiveData(
        boxName: 'userData',
        modelName: 'user'
    );

    _userToken = await AuthStorageService.fetchFromSharedPreferences(fieldName: 'userToken');

    if(rawJsonDecodedData != null && rawJsonDecodedData.toString().isNotEmpty){
      debugPrint("\nfetched user data : $rawJsonDecodedData\n");
      _loginData = LoginDataModel.fromJson(rawJsonDecodedData);
    }
    else{
      _loginData = LoginDataModel();
      _userData = User();
    }
    notifyListeners();
  }




  // Future<void> userLogin(String? email, String? password) async {
  //   _isLoginProgress = true;
  //   notifyListeners(); // Notify UI that login is in progress
  //
  //   // Request body for login API
  //   Map<String, dynamic> requestBody = {"email": email, "password": password};
  //
  //   try {
  //     // Call API service
  //     http.Response response = await ApiServices.postApi(
  //       url: AppUrls.loginUrl,
  //       body: requestBody,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //
  //     var jsonResponse = jsonDecode(response.body);
  //     debugPrint("\n\nLogin response : ${jsonResponse}\n\n");
  //
  //     if (response.statusCode == 200 && jsonResponse['success'] == true) {
  //       debugPrint("\njson response success : ${jsonResponse['success']}");
  //       fetchUserData();
  //       _isSuccess = true;
  //
  //       // Create LoginDataModel from the response and assign to _loginData
  //       _loginData = LoginDataModel.fromJson(jsonResponse);
  //
  //       debugPrint("Token data after login ${_loginData?.token}");
  //
  //       // Save the user data to Hive
  //     ///  await HiveServices.saveUserdata(_loginData!);  // Save login data to Hive
  //
  //       await HiveServices.saveToHive(
  //           boxName: 'userData',
  //           modelName: 'user',
  //           encodedJsonData: jsonEncode(jsonResponse)
  //       );
  //
  //       // Update userData with the logged-in user data
  //       await fetchUserData();
  //       _userData = _loginData?.user;
  //       notifyListeners(); // Notify listeners to update the UI
  //
  //       debugPrint("\nUser name name: ${_loginData?.user?.name}");
  //     } else {
  //       _isSuccess = false;
  //     }
  //   } catch (e) {
  //     _isSuccess = false;
  //     debugPrint("Error : $e");
  //   } finally {
  //     // Ensure loading state is updated after API call
  //     _isLoginProgress = false;
  //     notifyListeners();
  //   }
  // }
  //



  /// NAHIDUL ISLAM SHAKIN LOGIN CODE
  ///
  bool _isSuccessfullyLogin = false;
  bool get isSuccessfullyLogin => _isSuccessfullyLogin;

  bool _isLoginInProgress = false;
  bool get isLoginInProgress => _isLoginInProgress;

  File? _assetProfilePicturePath;
  File? get assetProfilePicturePath => _assetProfilePicturePath;

  Future<void> login({required String email, required String password}) async {
    _assetProfilePicturePath = null;
    _isSuccessfullyLogin = false;
    _isLoginInProgress = true;
    notifyListeners();

    try{
      final rawBody = {"email": email, "password": password};
      http.Response response = await ApiServices.postApi(
        url: AppUrls.loginUrl,
        body: rawBody,
        headers: {"Content-Type": "application/json"},
      );

      var decodedResponse = jsonDecode(response.body);
      debugPrint("\nLogin response : $decodedResponse\n");

      if (response.statusCode == 200 && decodedResponse['success'] == true) {


        // Create LoginDataModel from the response and assign to _loginData
        _loginData = LoginDataModel.fromJson(decodedResponse);
        _userToken = _loginData?.token;

        debugPrint("\n User Token ${_loginData?.token}\n");

        await AuthStorageService.saveToSharedPreferences(fieldName: 'userToken', value: _loginData?.token ?? 'N/A');
       // await AuthStorageService.saveToSharedPreferences(fieldName: 'userPassword', value: _loginData?.user?. ?? 'N/A');

        await HiveServices.saveToHive(
            boxName: 'userData',
            modelName: 'user',
            encodedJsonData: jsonEncode(decodedResponse)
        );
        debugPrint("\nUser name name: ${_loginData?.user?.name}");
        _isSuccessfullyLogin = true;
      }
      else{
        debugPrint("\nLogin failed!\n");
        _isSuccessfullyLogin = false;
      }

    }catch(error){
      debugPrint("\nError while login : $error\n");
    }finally{
      _isLoginInProgress = false;
      notifyListeners();
    }
  }

  void updateUserData({String? userName, File? profilePicture}){
    _loginData?.user?.name = userName ?? _loginData?.user?.name;
    _assetProfilePicturePath = profilePicture;
    notifyListeners();
  }

}
