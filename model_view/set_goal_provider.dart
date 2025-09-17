import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_end_point.dart';
import 'package:sleep_soundscape/api_services/api_services.dart';
import 'package:sleep_soundscape/api_services/hive_service.dart';
import 'package:sleep_soundscape/api_services/local_storage_services.dart';
import 'package:sleep_soundscape/model/set_goal_data_model.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';

class SetGoalProvider extends ChangeNotifier {
  // late Box goalBox;
  // ignore: prefer_final_fields
  List<String> _selectedGoals = []; // Unused but kept for compatibility
  List<String> get selectedGoals => _selectedGoals;

  // ignore: prefer_final_fields
  List<bool> _goalsList = List<bool>.filled(5, false);

  List<bool> get goalsList => _goalsList;

  final List<Goals> _goals = [
    Goals(userGoals: "Deep Sleep", goalDescriptions: "Get a quality Sleep", img: "assets/icons/1.5.png"),
    Goals(userGoals: "Overcome Stress", goalDescriptions: "Manage stress & Anxiety", img: "assets/icons/1.4.png"),
    Goals(userGoals: "Feel Nature", goalDescriptions: "Hear diverse nature sounds", img: "assets/icons/1.3.png"),
    Goals(userGoals: "Improve Performance", goalDescriptions: "Get a better start", img: "assets/icons/1.2.png"),
    Goals(userGoals: "Boost Concentration", goalDescriptions: "Improve focus", img: "assets/icons/1.1.png"),
  ];

  List<Goals> get goals => _goals;

  // ignore: prefer_typing_uninitialized_variables
  var savedGoals;

  final Set<int> selectedIndices = {};


  bool _isSetGoalInProgress = false;
  bool get isSetGoalInProgress => _isSetGoalInProgress;

  bool _isSuccessfullyGoalSet = false;
  bool get isSuccessfullyGoalSet => _isSuccessfullyGoalSet;

  bool _isGetGoalInProgress = false;
  bool get isGetGoalInProgress => _isGetGoalInProgress;

  bool _isSuccessfullyGoalFetched = false;
  bool get isSuccessfullyGoalFetched => _isSuccessfullyGoalFetched;

  List<dynamic>? _setGoalsData;
  List<dynamic>? get setGoalsData => _setGoalsData;

  List<dynamic>? _getGoalsData;
  List<dynamic>? get getGoalsData => _getGoalsData;



  /// Call select Goal API
  Future<void> setGoal({required List<String> selectedGoals}) async {
    _isSuccessfullyGoalSet = false;
    _isSetGoalInProgress = true;
    notifyListeners();

    try {
      final rawBody = {"userGoals": selectedGoals};
      final token = await AuthStorageService.fetchFromSharedPreferences(
        fieldName: "userToken",
      );

      if (token == null || token.isEmpty) {
        debugPrint("Error: No authentication token found.");
        return;
      }

      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(postGoalToApi, {
        "sendPort": receivePort.sendPort,
        "token": token,
        "body": rawBody
      });

      dynamic result;
      receivePort.listen((data) async {
        result = data;
        debugPrint("\nIsolated result is : $result\n");
        if (result['success'] == true) {
          debugPrint("setGoal: API call successful. Saving to Hive...");
          _setGoalsData = result['goals'];
          debugPrint("setGoal: Goals Data: $_setGoalsData");
          // _saveToHive();
          await HiveServices.saveToHive(boxName: "goalList",
              modelName: "goals",
              encodedJsonData: jsonEncode(_setGoalsData));
          debugPrint("setGoal: save to hive: $_setGoalsData");
          _isSuccessfullyGoalSet = true;
          _isSetGoalInProgress = false;
          notifyListeners();
        } else {
          _isSuccessfullyGoalSet = false;
          _isSetGoalInProgress = false;
          notifyListeners();
          debugPrint("Failed to set goals: ${result['message']}");
        }
      });
    } catch (error) {
      debugPrint("Error setting goals: $error");
    }
  }

/// Fetch GoalData from Hive
  Future<void> loadGoalsFromHive() async {
    _isSuccessfullyGoalFetched = false;
    _isGetGoalInProgress = true;
    notifyListeners();

    try {
      debugPrint("loadGoalsFromHive: Attempting to fetch from Hive");
      final hiveData = await HiveServices.fetchHiveData(
          boxName: "goalList", modelName: "goals");
      debugPrint("\nloadGoalsFromHive: Hive data fetched: $hiveData\n");

      if (hiveData != null) {
        _getGoalsData = hiveData;
        debugPrint("GoalData Loaded from hive: $_getGoalsData");
        initializeSelectedGoals();
        _isSuccessfullyGoalFetched = true;
        notifyListeners();
      } else {
        debugPrint(
            "No goals data found in hive, fetching from API");
        await getGoals();
      }
    } catch (error) {
      debugPrint("Error loading goals from hive: $error");
      await getGoals();
    } finally {
      _isGetGoalInProgress = false;
      notifyListeners();
    }
  }






/// initialize the selected goals
void initializeSelectedGoals(){
    for(int i = 0; i< goals.length ; i++){
      for(var savedGoal in _getGoalsData!){
        if(goals[i].userGoals == savedGoal['userGoals']){
          selectedIndices.add(i);
        }
      }
    }
}


  void toggleGoalSelection(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
      debugPrint("\nselected indices : $selectedIndices ");
    } else {
      selectedIndices.add(index);
      debugPrint("\nselected indices : $selectedIndices ");
    }
    notifyListeners();
  }

  bool isSelected(int index) {
    return selectedIndices.contains(index);
  }



  ///don't remove this code
  Future<void> getGoals() async {
    _isSuccessfullyGoalFetched =false;
    _isGetGoalInProgress = false;
    notifyListeners();

    try {
      final token = await AuthStorageService.fetchFromSharedPreferences(
        fieldName: "userToken",
      );

      if (token == null || token.isEmpty) {
        debugPrint("Error: No authentication token found.");
        return;
      }

      // final result = await Isolate.run(
      //       () => performGetApiCall(token: token),
      // );

      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(getGoalApi, {
        "sendPort" : receivePort.sendPort,
        "token" : token
      } );

      dynamic result;
      receivePort.listen((data){
        result = data;
        debugPrint("\nIsolated result is : $result\n");

        if (result['success'] == true) {
          // Parse the goals data from the result
          if (result['goals'] != null) {
            // final List<dynamic> goalsJson = result['goals'];
            _getGoalsData = result['goals'];
            debugPrint("\nFetched Goals Data: $_getGoalsData");
            // _saveToHive();
            notifyListeners();
            initializeSelectedGoals();
          }
        } else {
          debugPrint("Failed to fetch goals: ${result['message']}");
        }

      });

    } catch (error) {
      debugPrint("Error fetching goals: $error");
    }
  }



  // Future<void> _initializeHive() async {
  //   try {
  //     goalBox = Hive.box('goalBox');
  //     _loadFromHive();
  //   } catch (e) {
  //     debugPrint("Error initializing Hive: $e");
  //     _goalsList = List<bool>.filled(5, false);
  //     notifyListeners();
  //   }
  // }

  // void _loadFromHive() {
  //   final savedGoals = goalBox.get(
  //     'selectedGoals',
  //     defaultValue: _goalsData
  //   );
  //   _goalsList = savedGoals;
  //   debugPrint("Loaded goals from Hive: $_goalsData");
  //   notifyListeners();
  // }

  // void onSelect({required int index}) {
  //   debugPrint("\nSelected index: $index\n");
  //   _goalsList[index] = !_goalsList[index];
  //   // _saveToHive();
  //   notifyListeners();
  // }

  // void _saveToHive() {
  //   try {
  //     // goalBox.put('selectedGoals', _goalsList);
  //     goalBox.put('selectedGoals', _goalsData);
  //     debugPrint("Saved goals to Hive: $_goalsData");
  //   } catch (e) {
  //     debugPrint("Error saving to Hive: $e");
  //   }
  // }

  int _pageID = 1;

  SetGoalProvider(LoginAuthProvider loginAuthProvider);

  int get pageID => _pageID;

  // ignore: non_constant_identifier_names
  void SetPageID(int id) {
    _pageID = id;
  }
}

// ignore: unused_element
SetGoalDataModel? _setGoalDataModel;
// ignore: unused_element
SetGoalDataModel? _getGoalDataModel;

void postGoalToApi(Map<String, dynamic> args,) async {

  SendPort sendPort = args['sendPort'];
  String token = args['token'];
  Map<String, dynamic> body = args['body'];


  try {
    final response = await ApiServices.postApi(
      url: AppUrls.setGoalUrl,
      body: body,
      headers: {"Content-Type": "application/json", "Authorization": token},
    );

    if (response is http.Response) {
      final decodedData = jsonDecode(response.body);
      debugPrint("\nAPI Response : $decodedData\n");
      if (response.statusCode == 200) {
        debugPrint("\nGoal set successful\n");
        _setGoalDataModel = SetGoalDataModel.fromJson(decodedData);
      } else {
        debugPrint("\nGoal set failed\n");
      }
      sendPort.send(decodedData);
    }
  } catch (error) {
   debugPrint("\nError while setting goal : $error\n");
  }
}



/// don't remove this code
void getGoalApi(Map<String,dynamic> args) async {

  SendPort sendPort = args['sendPort'];
  String token = args['token'];

  try {
    final response = await ApiServices.getApi(
      url: AppUrls.getGoalUrl,
      header: token,
    );

    if (response is http.Response) {
      final decodedData = jsonDecode(response.body);
      debugPrint("Get Goals Raw Response: $decodedData");

      if (response.statusCode == 200) {
        debugPrint("\nGoals fetched successfully");
        _getGoalDataModel = SetGoalDataModel.fromJson(decodedData);
      } else {
        debugPrint("\nGoals fetch failed");
      }
      sendPort.send(decodedData);
    }

  } catch (error) {
    debugPrint ("Error while fetching goals: $error");
  }
}



