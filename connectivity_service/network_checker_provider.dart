import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkCheckerProvider extends ChangeNotifier {

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  NetworkCheckerProvider(){
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    debugPrint("\nConnectivity : $connectivityResult\n");
    if(connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet) || connectivityResult.contains(ConnectivityResult.mobile)){
     _isConnected = true;
     notifyListeners();
    }
    else{
      _isConnected = false;
      notifyListeners();
    }

  }

}