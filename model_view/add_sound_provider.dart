import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_end_point.dart';
import 'package:sleep_soundscape/model/add_sound_data_model.dart';

class AddSoundProvider extends ChangeNotifier {
  bool _isAddSoundSuccess = false;
  bool get isAddSoundSuccess => _isAddSoundSuccess;

  bool _isAddSoundLoading = false;
  bool get isAddSoundLoading => _isAddSoundLoading;

  // String? _title;
  // String? get title => _title;
  //
  // String? _subtitle;
  // String? get subtitle => _subtitle;


  String? _category;
  String? get category => _category;

  void setCategory(String? category) {
    _category = category;
    notifyListeners();
  }


  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  File? _selectedAudio;
  File? get selectedAudio => _selectedAudio;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AddSoundDataModel? _addSoundData;
  AddSoundDataModel? get addSoundData => _addSoundData;

  /// Sets the selected image file and notifies listeners
  void setImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  /// Sets the selected audio file and notifies listeners
  void setAudio(File? audio) {
    _selectedAudio = audio;
    notifyListeners();
  }

  /// Uploads sound data (title, subtitle, category, image, and audio) to the server
  Future<void> uploadSound({
    required String category,
    required String title,
    required String subtitle,
    required File image,
    required File audio,
  }) async {
    _isAddSoundLoading = true;
    _isAddSoundSuccess = false;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(AppUrls.addSound);

    try {
      var request = http.MultipartRequest("POST", url);
      request.fields['category'] = category;
      request.fields['title'] = title;
      request.fields['subtitle'] = subtitle;

      // Attach image file
        if(_selectedImage != null){
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // Ensure this matches the backend's expected field name
            image.path,
          ),
        );
      }

      // Attach audio file
       if(_selectedAudio != null){
        request.files.add(
          await http.MultipartFile.fromPath(
            'audio', // Ensure this matches the backend's expected field name
            audio.path,
          ),
        );
      }

      // Send the request
      var response = await request.send();
      final responseData = await http.Response.fromStream(response);

      debugPrint('Response Data: ${responseData.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(responseData.body);
        _addSoundData = AddSoundDataModel.fromJson(decodedData);
        _isAddSoundSuccess = true;
        notifyListeners();
        debugPrint("API Response: ${_addSoundData?.message}");
      } else {
        // Handle API errors properly
        final errorResponse = jsonDecode(responseData.body);
        _errorMessage = errorResponse['message'] ?? 'Failed to add sound';
        debugPrint('Add Sound Failed: $_errorMessage');
      }
    } catch (error) {
      // Handle unexpected errors
      _errorMessage = 'Error: ${error.toString()}';
      debugPrint('Exception: $_errorMessage');
    }

    _isAddSoundLoading = false;
    notifyListeners();
  }


}
