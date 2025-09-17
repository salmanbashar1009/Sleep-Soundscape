import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_soundscape/api_services/api_end_point.dart';
import '../model/sound_model.dart';

class SoundScreenProvider with ChangeNotifier {
  SoundScreenProvider() {
    fetchMusics(categories.first); // Fetch initial category
  }

  List<SoundModel> _soundList = [];
  List<SoundModel> get soundList => _soundList;

  List<String> categories = ["Oceans", "Nature", "Rain", "Map", "Fire"];
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  bool isLoading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Fetch Sounds for the Selected Category

  void musicClear(){

    _soundList.clear();
    notifyListeners();
  }

  // Future<void> fetchMusics(String category) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final url = AppUrls.sound(category);
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       _soundList = SoundModel.listFromJson(jsonData);
  //       debugPrint("\nMusic list loaded: ${_soundList.length} items\n");
  //     } else {
  //       debugPrint("\nFailed to load sounds. Status Code: ${response.statusCode}\n");
  //     }
  //   } catch (error) {
  //     debugPrint('\nError fetching sounds: $error\n');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchMusics(String category) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = AppUrls.sound(category);
      debugPrint('\nFetching URL: $url\n');

      debugPrint("\ncategory is selected =====$category\n");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        debugPrint("\nRay music list : $jsonData\n");
        _soundList = SoundModel.listFromJson(jsonData);
      } else {
        debugPrint(
          '\nFailed to load sounds. Status Code: ${response.statusCode}\n',
        );
      }
    } catch (error) {
      debugPrint('\nError fetching sounds: $error\n');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> musicSearch(String search) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = AppUrls.musicSearch(search);
      debugPrint('\nFetching URL: $url\n');

      debugPrint("\ncategory is selected =====$search\n");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        debugPrint("\nRay music list : $jsonData\n");
        _soundList = SoundModel.listFromJson(jsonData);
      } else {
        debugPrint(
          '\nFailed to load sounds. Status Code: ${response.statusCode}\n',
        );
      }
    } catch (error) {
      debugPrint('\nError fetching sounds: $error\n');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int _playedMusic = -1;
  int get playedMusic => _playedMusic;
  Future<void> playMusic(int index) async {
    try {
      // If the same music is clicked, stop it
      if (_playedMusic == index) {
        await _audioPlayer.stop();
        _playedMusic = -1;
        notifyListeners();
        return;
      } else {
        // Stop any currently playing music before starting a new one
        await _audioPlayer.stop();
        String musicUrl = _soundList[index].audioPath!;
        await _audioPlayer.play(UrlSource(musicUrl), volume: 1);
        _playedMusic = index;
        _isPlaying = true;
        notifyListeners();
        debugPrint("\nAudio played\nindex : $_playedMusic\n");
      }
    } catch (e) {
      debugPrint("\nError playing audio: $e\n");
    }
  }
  // Future<void> playMusic(int index) async {
  //   try {
  //     if (_soundList.isEmpty || index < 0 || index >= _soundList.length) {
  //       debugPrint("\nInvalid index or empty sound list. Index: $index\n");
  //       return;
  //     }
  //
  //     if (_playedMusic == index) {
  //       // Stop the current music if the same index is pressed again
  //       await _audioPlayer.stop();
  //       _playedMusic = -1;
  //       _isPlaying = false;
  //       notifyListeners();
  //       debugPrint("\nMusic stopped. No music playing now.\n");
  //       return;
  //     }
  //
  //     // Stop previous music before playing a new one
  //     await _audioPlayer.stop();
  //     _playedMusic = -1;
  //     notifyListeners();
  //
  //     String? musicUrl = _soundList[index].audioPath;
  //     if (musicUrl == null || musicUrl.isEmpty) {
  //       debugPrint("\nInvalid audio URL at index $index\n");
  //       return;
  //     }
  //
  //     debugPrint("\nTrying to play: $musicUrl\n");
  //
  //     // Ensure network connection before playing
  //     if (!await isConnectedToInternet()) {
  //       debugPrint("\nNo internet connection. Cannot play audio.\n");
  //       return;
  //     }
  //
  //     // Try to play the audio
  //     await _audioPlayer.play(UrlSource(musicUrl), volume: 1).timeout(
  //       Duration(seconds: 0),
  //       onTimeout: () {
  //         debugPrint("\nAudio play request timed out: $musicUrl\n");
  //         return;
  //       },
  //     );
  //
  //     _playedMusic = index;
  //     _isPlaying = true;
  //     notifyListeners();
  //     debugPrint("\nAudio played successfully\nIndex: $_playedMusic\n");
  //   } catch (e) {
  //     debugPrint("\nError playing audio: $e\n");
  //   }
  // }
  // Future<bool> isConnectedToInternet() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }



}
