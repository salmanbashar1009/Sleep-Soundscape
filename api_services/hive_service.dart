import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../model/sound_setting_model.dart';

class HiveServices {
  // Clear user data
  static Future<void> clearData({required String boxName, required String modelName}) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.delete(modelName); // This will delete the user data
      debugPrint("\nUser data cleared from Hive.");
    } catch (error) {
      debugPrint("\nError while clearing user data: $error\n");
    }
  }


  static Future<void> saveToHive ({required String boxName, required String modelName,
  required var encodedJsonData}) async {
    try{
      await Hive.openBox(boxName);
      var box =  Hive.box(boxName);
      await box.put(modelName, encodedJsonData);
      debugPrint("\n Save the data in hive successfully!\n");
    }catch(error){
      debugPrint("\nError while saving hive data : $error\n");
    }

  }


  static Future<dynamic> fetchHiveData({required String boxName, required String modelName,}) async {
    try {
       await Hive.openBox(boxName);
      var box = Hive.box(boxName);
      var data =await box.get(modelName);

      if(data != null){
       if(data is String){
         var decodedData = jsonDecode(data);
         debugPrint("\nData fetched successful: $decodedData\n");
         return decodedData;
       }
       else if(data is Map<String, dynamic>){
         debugPrint("\nData fetched successful (Already Map): $data\n");
         return data; // Directly return if it's already a Map
       }
      }


    } catch (error) {
      debugPrint("Error while retrieving from Hive: $error");
      return SoundSettingModel();
    }
    return null;
  }



}



