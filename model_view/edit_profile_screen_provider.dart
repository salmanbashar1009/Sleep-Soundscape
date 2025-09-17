import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';
import '../api_services/api_end_point.dart';
import '../api_services/hive_service.dart';

class EditProfileProvider extends ChangeNotifier {
  LoginAuthProvider loginAuthProvider;
  EditProfileProvider(this.loginAuthProvider);


  File? _tempImage;
  File? get tempImage => _tempImage;
  String? _name;
  bool _isLoading = false;


  String? get name => _name;
  bool get isLoading => _isLoading;

  void setImage(File image) {
    _tempImage = image;
    notifyListeners();
  }

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  bool _isSuccessfullyEdited = false;
  bool get isSuccessfullyEdited => _isSuccessfullyEdited;
  Future<void> editProfile({ String? name,}) async {
    try {
      _setLoading(true);
      _isSuccessfullyEdited = false;
      notifyListeners();

      final token = loginAuthProvider.userToken;
      if (token == null || token.isEmpty) {
        throw Exception("Token is missing");
      }

      final headers = {
        "Authorization": token,
      };

      final request = http.MultipartRequest("PUT", Uri.parse(AppUrls.editProfile));
      request.headers.addAll(headers);
      request.fields["name"] = name ?? loginAuthProvider.loginData?.user?.name ?? 'N/A';

      if (_tempImage != null) {
        var imageFile = await http.MultipartFile.fromPath(
          'image',
          _tempImage!.path,
        );
        request.files.add(imageFile);
      }

      var response = await request.send();
      final responseData = await http.Response.fromStream(response);
      debugPrint("\nResponse data : ${responseData.body}\nStatus code : ${responseData.statusCode}\n");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("\nEdited success!\n");
        loginAuthProvider.updateUserData(
          userName: name,
          profilePicture: _tempImage
        );
        final decodedResponseBody = jsonDecode(responseData.body);
        await HiveServices.saveToHive(
            boxName: 'userData',
            modelName: 'user',
            encodedJsonData: jsonEncode(decodedResponseBody)
        );
        _isSuccessfullyEdited = true;
        debugPrint("\n_isSuccessfullyEdited : $_isSuccessfullyEdited\n");

        _tempImage = null;
        _isLoading = false;

        notifyListeners();

      } else {
        debugPrint("\nEdited failed! in else condition\n");
        _isLoading = false;
        _isSuccessfullyEdited = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("\nEdited failed! in catch block : $e\n");
      _isLoading = false;
      _isSuccessfullyEdited = false;
      notifyListeners();
    }
  }
}
