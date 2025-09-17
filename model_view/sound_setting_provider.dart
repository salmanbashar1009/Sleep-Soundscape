import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sleep_soundscape/model_view/home_screen_provider.dart';
import 'package:vibration/vibration.dart';
import '../api_services/api_end_point.dart';
import '../api_services/hive_service.dart';
import '../model/rington_model.dart';
import '../model/sound_scape_model.dart';
import '../model/sound_setting_model.dart';

class SoundSettingProvider extends ChangeNotifier {
  HomeScreenProvider? homeScreenProvider;

  SoundSettingProvider([this.homeScreenProvider]) {
    loadSettings();
    allMusics();
    setTotalMinute();
  }
  int _selectedHour = 0;
  int _selectedMinute = 0;
  int _totalMinute = 0;
  int get selectedHour => _selectedHour;
  int get setSelectedMinute => _selectedMinute;
  int get totalMinute => _totalMinute;

  void setSelectedHour(int hour) {
    _selectedHour = hour;
    notifyListeners();
  }

  void setSelectedMinut(int minute) {
    _selectedMinute = minute;
    notifyListeners();
  }

  void setTotalMinute() {
    _totalMinute = (_selectedHour * 60) + _selectedMinute;
    debugPrint("total minute in sound setting provider.$_totalMinute");
    notifyListeners();
  }

  void setAudioTime() {
    _soundSettings.soundscapes;
    _soundSettings.soundscapes.audioTimer = _totalMinute;
    debugPrint("setAudioTime sound setting.$_totalMinute");

    saveSettings();
  }

  // sound scape api call and method call
  SoundSettingModel _soundSettings = SoundSettingModel();

  SoundSettingModel get soundSettings => _soundSettings;

  List<SoundScapeModel> _musicList = [];
  List<SoundScapeModel> get musicList => _musicList;

  bool _isSuccess = false;
  bool _isLoading = false;

  bool get isSuccess => _isSuccess;
  bool get isLoading => _isLoading;

  int _currentPage = 1;
  final int _limit = 10; // Adjust limit as needed
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool _hasMore = true;
  // Getters
  bool get hasMore => _hasMore;

  Future<void> allMusics({bool isLoadMore = false}) async {
    if (_isLoading || (_isLoadingMore && isLoadMore) || !_hasMore) return;

    if (isLoadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
      _currentPage = 1;
      _musicList.clear();
      _hasMore = true;
    }
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(AppUrls.allMusic(_currentPage, _limit)),
      );

      if (response.statusCode == 200) {
        final responseDecode = jsonDecode(response.body);
        SoundScapeModel soundScapeData = SoundScapeModel.fromJson(
          responseDecode,
        );

        if (soundScapeData.sounds == null || soundScapeData.sounds!.isEmpty) {
          _hasMore = false;
        } else {
          if (isLoadMore) {
            _musicList.first.sounds!.addAll(soundScapeData.sounds!);
          } else {
            _musicList = [soundScapeData];
          }
          _currentPage++;
          _hasMore = soundScapeData.hasMore ?? true; // Use API-provided hasMore
        }

        debugPrint(
          "Success: ${soundScapeData.sounds?.length ?? 0} musics loaded. Total: ${_musicList.first.sounds?.length ?? 0}",
        );
        _isSuccess = true;
      } else {
        debugPrint("Error: API returned ${response.statusCode}");
        _hasMore = false;
      }
    } catch (error) {
      debugPrint("Error fetching musics: $error");
      _isSuccess = false;
      _hasMore = false;
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // select music method wahab

  int _selectedMusicIndex = -1;
  int get selectedMusicIndex => _selectedMusicIndex;

  // Method to select a Audio path
  String? _selectedAudioPath;
  String? get selectedAudioPath => _selectedAudioPath;

  void selectMusic(int index) {
    _selectedMusicIndex = index;
    if (_musicList.isEmpty) {
      debugPrint(" No music available!");
      return;
    }

    var selectedMusic = _musicList.first;

    if (selectedMusic.sounds != null && selectedMusic.sounds!.isNotEmpty) {
      if (index < selectedMusic.sounds!.length) {
        _selectedAudioPath = selectedMusic.sounds![index].audioPath;
      } else {
        debugPrint(" Invalid index: $index");
        _selectedAudioPath = null;
      }
    } else {
      debugPrint("No sounds available!");
      _selectedAudioPath = null;
    }

    debugPrint(" Selected Audio Path: $_selectedAudioPath");
    notifyListeners();
  }

  void saveAudioPath() {
    if (_selectedAudioPath != null) {
      _soundSettings.soundscapes;
      _soundSettings.soundscapes.audioPath = _selectedAudioPath!;
      saveSettings();
      debugPrint(" Saved Audio Path: ${_soundSettings.soundscapes.audioPath}");
    } else {
      debugPrint(" No audio path selected to save!");
    }
  }

  //ring ton setting method wahab

  List<RingTonModel> ringtones = [
    RingTonModel(name: "Relaxing Music", path: "musics/alarm-01.mp3"),
    RingTonModel(name: "Morning Alarm", path: "musics/audio.mp3"),
    RingTonModel(name: "Workout Beat", path: "musics/audio1.mp3"),
    RingTonModel(name: "Nature Sounds", path: "musics/music1.mp3"),
    RingTonModel(name: "Focus Mode", path: "musics/nature-01.mp3"),
    RingTonModel(name: "Working Music", path: "musics/rain-02.mp3"),
    RingTonModel(name: "Evening Music", path: "musics/nature-03.mp3"),
  ];

  //Ring ton start
  bool _isRingTonPlaying = false;
  bool get isRingTonPlaying => _isRingTonPlaying;

  int _playedRingTon = -1;
  int get playedRingTon => _playedRingTon;
  Future<void> playRingTon(int index) async {
    try {
      if (_playedRingTon == index) {
        await _audioPlayer.stop();
        _playedRingTon = -1;
        _isRingTonPlaying = false;
        notifyListeners();
        return;
      } else {
        await _audioPlayer.stop();

        String musicPath = ringtones[index].path;

        if (File(musicPath).existsSync()) {
          await _audioPlayer.play(DeviceFileSource(musicPath), volume: 1);
        } else {
          await _audioPlayer.play(AssetSource(musicPath), volume: 1);
        }

        _playedRingTon = index;
        _isRingTonPlaying = true;
        notifyListeners();
        debugPrint("\nAudio played\nindex : $_playedRingTon\n");
      }
    } catch (e) {
      debugPrint("\n Error playing audio: $e\n");
    }
  }

  //Ring ton start

  int _selectedRingTonIndex = -1;
  int get selectedRingTonIndex => _selectedRingTonIndex;

  String? _selectedRingTonPath;
  String? _selectedRingTonName;
  String? get selectedRingTonPath => _selectedRingTonPath;
  String? get selectedRingTonName => _selectedRingTonName;

  // Method to select a ringtone
  void selectRingTon(int index) {
    if (index < 0 || index >= ringtones.length) {
      debugPrint("Invalid ringtone index: $index");
      return;
    }

    _selectedRingTonIndex = index;
    _selectedRingTonPath = ringtones[index].path; // Get correct path
    _selectedRingTonName = ringtones[index].name;
    debugPrint("Selected Ring Ton Path: $_selectedRingTonPath");
    debugPrint("Selected Rington Name : $_selectedRingTonName");

    notifyListeners();
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
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
        String musicUrl = _musicList.first.sounds![index].audioPath!;
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

  //stop music  &  Ring ton
  void stopMusic() {
    _isRingTonPlaying = false;
    _playedRingTon = -1;
    _isPlaying = false;
    _playedMusic = -1;
    _audioPlayer.stop();
    notifyListeners();
  }

  void saveRingTonPath() {
    if (_selectedRingTonPath != null) {
      _soundSettings.alarm.ringtone;
      _soundSettings.alarm.ringtone.ringTonPath = _selectedRingTonPath!;
      _soundSettings.alarm.ringtone.name = _selectedRingTonName!;
      saveSettings();
      debugPrint(
        " Saved rington Path: ${_soundSettings.alarm.ringtone.ringTonPath}",
      );
    } else {
      debugPrint(" No rington path selected to save!");
    }
  }

  //ring ton setting method wahab

  // Access device sound volume increase and decrease

  double _currentVolume = 0.5; // Default volume level

  double get currentVolume => _currentVolume; // Getter for UI updates

  volumeProvider() {
    getCurrentVolume(); // Get volume when initialized
  }

  Future<void> getCurrentVolume() async {
    double? volume = await FlutterVolumeController.getVolume();
    _currentVolume = volume!;
    notifyListeners(); // Notify UI about changes
  }

  void setVolume(double volume) async {
    await FlutterVolumeController.setVolume(volume); // Update device volume
    _currentVolume = volume;
    notifyListeners(); // Notify UI about changes
  }

  //sound increase and decrease method

  void setSliderValue(double sliderValue) {
    _soundSettings.alarm;
    _soundSettings.alarm.volume = sliderValue;
    saveSettings();

    // _sliderValue =sliderValue;
    // notifyListeners();
  }
  // Access device sound volume increase and decrease  end

  /// Load settings from Hive
  Future<void> loadSettings() async {
    dynamic rawData = await HiveServices.fetchHiveData(
      boxName: 'alarmSettings',
      modelName: 'settings',
    );

    if (rawData != null && rawData is Map<String, dynamic>) {
      // Ensure it's a map before decoding
      try {
        _soundSettings = SoundSettingModel.fromJson(
          rawData,
        ); // Directly use the Map
        debugPrint("\n Loaded settings from Hive: $_soundSettings\n");
      } catch (e) {
        debugPrint("\n Error decoding settings from Hive: $e\n");
      }
      notifyListeners();
    } else {
      debugPrint("\nNo saved settings found, using defaults.\n");
    }
  }

  /// Toggle Alarm
  void toggleAlarm() {
    _soundSettings.alarm;
    _soundSettings.alarm.enabled = !(_soundSettings.alarm.enabled);
    // _soundSettings.alarm!.enabled = !_soundSettings.alarm!.enabled!;
    saveSettings();
  }

  /// Toggle Vibration
  void toggleVibration() {
    _soundSettings.alarm;
    _soundSettings.alarm.vibration = !(_soundSettings.alarm.vibration);
    saveSettings();
  }

  /// Set Volume
  // void setVolume(double volume) {
  //   _soundSettings.alarm ??= Alarm();
  //   _soundSettings.alarm!.volume = volume;
  //   saveSettings();
  // }
  //toggle sound detection
  void toggleSoundDetection() {
    _soundSettings.sleepAnalysis;
    _soundSettings.sleepAnalysis.soundsDetection;

    _soundSettings.sleepAnalysis.soundsDetection.enabled =
        !(_soundSettings.sleepAnalysis.soundsDetection.enabled);

    saveSettings();
    notifyListeners();
  }

  //  audio recording clear method

  void audioRecordingClear() {
    //_soundSettings.sleepAnalysis ??= SleepAnalysis();
    _soundSettings.sleepAnalysis.soundsDetection;

    _soundSettings.sleepAnalysis.soundsDetection.audioRecordingClean =
        !(_soundSettings.sleepAnalysis.soundsDetection.audioRecordingClean);

    saveSettings();
    notifyListeners();
  }

  /// Toggle AutoPlay
  void toggleAutoPlay() {
    _soundSettings.soundscapes;
    _soundSettings.soundscapes.alarmAutoplay =
        !(_soundSettings.soundscapes.alarmAutoplay);
    saveSettings();
  }

  /// Set Snooze Time
  void setSnooze(int value) {
    _soundSettings.advanced;
    _soundSettings.advanced.snooze = value;
    saveSettings();
  }

  /// Set shake  Time
  void setShakeTime(int value) {
    _soundSettings.advanced;
    _soundSettings.advanced.shakeTime = value;
    saveSettings();
  }

  /// Set Alarm Mode
  void setAlarmMode(String mode) {
    _soundSettings.advanced;
    _soundSettings.advanced.alarmMode = mode;
    saveSettings();
  }

  /// Set Get-Up Challenge
  void setGetUpChallenge(bool challenge) {
    _soundSettings.advanced;
    _soundSettings.advanced.getUpChallenge = challenge;
    saveSettings();
  }

  // user shakes time detection and count method
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  final double _shakeThreshold = 15.0;

  // Alarm and shake state variables
  int _shakeCount = 0;
  final int _requiredShakes = 10;
  bool _isAlarmPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Getter methods for the UI
  int get shakeCount => _shakeCount;
  bool get isAlarmPlaying => _isAlarmPlaying;

  // Start the alarm sound
  void _startAlarm() async {
    _isAlarmPlaying = true;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource("alarm.mp3"));
    notifyListeners();
  }

  // Stop the alarm
  void _stopAlarm() async {
    await _audioPlayer.stop();
    _isAlarmPlaying = false;
    _shakeCount = 0; // Reset shake count after alarm stops
    notifyListeners();
  }

  // Listen to accelerometer events and detect shakes
  StreamSubscription? _accelerometerSubscription;
  void startShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double x = event.x, y = event.y, z = event.z;
      double deltaX = (x - _lastX).abs();
      double deltaY = (y - _lastY).abs();
      double deltaZ = (z - _lastZ).abs();

      _lastX = x;
      _lastY = y;
      _lastZ = z;

      if (_isAlarmPlaying &&
          (deltaX > _shakeThreshold ||
              deltaY > _shakeThreshold ||
              deltaZ > _shakeThreshold)) {
        _shakeCount++;
        Vibration.hasVibrator().then((hasVibrator) {
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 100);
          }
        });

        if (_shakeCount >= _requiredShakes) {
          _stopAlarm();
        }

        notifyListeners();
      }
    });
  }

  // Stop listening to accelerometer events
  void stopListening() {
    _accelerometerSubscription?.cancel();
  }

  // Function to initiate the alarm
  void initiateAlarm() {
    _startAlarm();
    startShakeDetection();
  }

  // Dispose of any resources when no longer needed
  @override
  void dispose() {
    _audioPlayer.dispose();
    stopListening();
    super.dispose();
  }

  // user shakes time detection and count method

  /// **Save settings to Hive**
  Future<void> saveSettings() async {
    try {
      String encodedData = jsonEncode(
        _soundSettings.toJson(),
      ); // Convert to JSON string
      await HiveServices.saveToHive(
        boxName: 'alarmSettings',
        modelName: 'settings',
        encodedJsonData:
            encodedData, // Pass JSON string (Hive expects a string)
      );
      debugPrint("\n Settings saved successfully to Hive!\n");
    } catch (e) {
      debugPrint("\n Error saving settings to Hive: $e\n");
    }
    notifyListeners();
  }
}
