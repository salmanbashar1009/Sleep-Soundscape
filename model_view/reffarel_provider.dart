import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_end_point.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';

class ReffarelProvider with ChangeNotifier{


LoginAuthProvider? loginAuthProvider;
ReffarelProvider(this.loginAuthProvider){
token = loginAuthProvider?.userToken;


fetchRefCode(token ?? "");
debugPrint("\n\n\nUser token for rafferel code is : $token\n\n\n");
}

 String? token;

   bool _isLoading = false;
   bool get isLoading => _isLoading;

   bool _isSuccess = false;
   bool get isSuccess => _isSuccess;

   String _error = "";
   String get error => _error;

   String _refCode = "";
   String get refCode => _refCode;
      

   Future<void> fetchRefCode(String tkn)async{
      _isLoading = true;
      _error ="";
      _isSuccess = false;
      notifyListeners();


    try{
      var response = await http.get(Uri.parse(AppUrls.refCode),
      headers: {"Authorization":tkn},
      );
      debugPrint("\n----${response.body} \n");
           var jsonDecodedata = jsonDecode(response.body);
      if(response.statusCode == 200 ){
               _isSuccess = true;
               _refCode= jsonDecodedata["referralCode"];

               debugPrint("\n   =====  $jsonDecodedata \n");

      }
      notifyListeners();
    }catch(e){
         debugPrint("\n api didnt hit --- $e");
         _error ="$e";

    }
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();

  }
}