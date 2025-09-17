import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_soundscape/model_view/reminder_screen_provider.dart';
import 'package:sleep_soundscape/model_view/sound_setting_provider.dart';
import 'package:vibration/vibration.dart';

class HomeScreenProvider extends ChangeNotifier {

  final SoundSettingProvider? _soundSettingProvider;


  HomeScreenProvider(this._soundSettingProvider) {
    // _initializeAudio();
    _startClock();
    _loadDontRemindPreference();
    getTotalMinutes();
  }

  String _hour = "8";
  String _minute = '22';
  String? _mM;
  Timer? _timer;
  // bool _isRepeat = false;
  DateTime? _endTime;
  bool _isStartPressed = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer here

  // Getter methods
  String get hour => _hour;
  String get minute => _minute;
  String? get mM => _mM;
  Timer? get timer => _timer;
  // bool get isRepeat => _isRepeat;
  DateTime? get endTime => _endTime;
  bool get isStartPressed => _isStartPressed;


// wahab code
//   Duration _totalDuration = Duration.zero;
//   Duration _currentPosition = Duration.zero;
//   double _audioProgressBarCount = 0.0;
//   double get audioProgressBarCount => _audioProgressBarCount;

  // Future<void> _initializeAudio() async {
  //   _audioPlayer.onDurationChanged.listen((duration) {
  //     _totalDuration = duration ;
  //     notifyListeners();
  //   });
  //
  //   _audioPlayer.onPositionChanged.listen((position) {
  //     _currentPosition = position ;
  //     _updateProgressBar();
  //   });
  //
  //   _audioPlayer.onPlayerComplete.listen((event) {
  //     _audioProgressBarCount = 0.0;
  //     notifyListeners();
  //   });
  // }
  //
  //
  // void _updateProgressBar() {
  //   if (_totalDuration.inMilliseconds > 0) {
  //     _audioProgressBarCount = _currentPosition.inMilliseconds / _totalDuration.inMilliseconds  ;
  //     notifyListeners();
  //   }
  // }



  void setHour(String newHour) {
    _hour = newHour;
    notifyListeners();
  }

  void setMinute(String newMinute) {
    _minute = newMinute;
    notifyListeners();
  }

  void setMm(String newMm) {
    _mM = newMm;
    notifyListeners();
  }



  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }


  int _selectedHour = 0;
  int _selectedMinute = 5;
  // ignore: unused_field
  double? _audioProgrssBarCount;


  // Getter methods
  int get selectedHour => _selectedHour;
  int get selectedMinute => _selectedMinute;

  double _progressValue = 0.0;
  double get progressValue => _progressValue;

  Timer? _progressTimer; // Make the timer a class member

  void startProgressTimer() {
    // Cancel any existing timer
    _progressTimer?.cancel();
    _progressTimer = null;

    // Reset progress value
    _progressValue = 0.0;
    notifyListeners();

    final now = DateTime.now();
    _endTime = _endTime ?? now.add(Duration(minutes: 30));
    final totalDuration = _endTime?.difference(now);

    // Calculate the increment value per second
    final incrementPerSecond = 1.0 / totalDuration!.inSeconds;

    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      if (currentTime.isBefore(_endTime!)) {
        _progressValue += incrementPerSecond;
        // Ensure progressValue does not exceed 1.0
        _progressValue = _progressValue.clamp(0.0, 1.0);
        notifyListeners();
      } else {
        // Stop the timer when the end time is reached
        _progressTimer?.cancel();
        _progressTimer = null;
        _progressValue = 1.0; // Ensure progress is exactly 1.0 at the end
        notifyListeners();
      }
    });
  }

  void stopProgressTimer(){
    _progressTimer?.cancel();
    _progressTimer = null;

    // Reset progress value
    _progressValue = 0.0;
    notifyListeners();
  }


  void setSelectedHour(int hour){
    _selectedHour = hour;
    setEndTime();
    notifyListeners();
  }

  void setSelectedMinute(int minute){
    _selectedMinute = minute;
    setEndTime();
    notifyListeners();
  }
 // Audio timer total minute
  int getTotalMinutes() {
    debugPrint( "Total audio timer === ${(_selectedHour * 60) + _selectedMinute}");
    return (_selectedHour * 60) + _selectedMinute;
  }

  int _totalMinutes = 30;
  int get totalMinutes => _totalMinutes;
  void updateTotalMinute() {
    _totalMinutes = (selectedHour * 60) + _selectedMinute;
    notifyListeners();
    debugPrint("\nTotal Minutes update: $_totalMinutes\n");
  }

  void setEndTime() {
    _audioProgrssBarCount = selectedHour * 3600 + selectedMinute * 60;

    final now = DateTime.now();
    _endTime = now.add(Duration(
      hours: _selectedHour, // Use 0 if null
      minutes: _selectedMinute, // Use 0 if null
    ));

    notifyListeners();
  }



  void startAudio() async {
    setEndTime(); // Set the end time before starting the timer
    if (_endTime == null) return; // Ensure end time is set

    // _isRepeat = true;


    // debugPrint("\nRepeat: $_isRepeat");
    debugPrint("\nEndTime: $_endTime");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_endTime != null && DateTime.now().isAfter(_endTime!)) {
        stopAudio();
        stopProgressTimer();
        // debugPrint("\nRepeat: $_isRepeat");
        toggleStartPressed();


      }
    });
  }


  // method write by wahab


  bool _isPlaying = true; // Track play/pause state
  // bool _isPaused = false; // Track pause state

  bool get isPlaying => _isPlaying;
  // bool get isPaused => _isPaused;

  // bool _isVibrating = false;
  // bool get isVibrating => _isVibrating;

  Future<void> togglePlayPause({ required bool togglePlayPauseWithNewMusic}) async {
    if (_isPlaying && !togglePlayPauseWithNewMusic) {
      // Pause audio and stop vibration
      await _audioPlayer.pause();
      _isPlaying = false;
    } else if(!_isPlaying && !togglePlayPauseWithNewMusic){
      // Resume audio and restart vibration
      await _audioPlayer.resume();
      _isPlaying = true;

    }
    else if(togglePlayPauseWithNewMusic){
      await playMusic();
      _isPlaying = true;
    }
    notifyListeners();
  }
  // void _startVibration() async {
  //   if (await Vibration.hasVibrator()) {
  //     Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
  //   }
  // }




 // on hold long press linear progress
  double _deleteProgress = 0.0;
  double get deleteProgress => _deleteProgress;

  Timer? _holdTimer;
  static const int holdDuration = 1500; // 1.5 seconds

  final ValueNotifier<bool> _canSubmit = ValueNotifier(true);
  ValueNotifier<bool> get canSubmit => _canSubmit;

  void startProgress(BuildContext context) {

    _checkSubmit(); // Call stopMusic when progress completes
    context.read<ReminderScreenProvider>().cancelWakeAlarm();
    _progressTimer?.cancel();
    _progressTimer = null;

    // _holdTimer?.cancel();
    // _deleteProgress = 0.0;
    // notifyListeners();
    //
    // int interval = 1; // 1ms intervals
    // int totalSteps = holdDuration ~/ interval;
    //
    // _holdTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
    //   _deleteProgress += 1 / totalSteps;
    //   notifyListeners();
    //
    //   if (_deleteProgress >= 1.0) {
    //     _holdTimer?.cancel();
    //     _deleteProgress = 0.0;
    //
    //     if(_progressTimer != null){
    //       _progressTimer?.cancel();
    //       _progressTimer = null;
    //     }
    //     _checkSubmit(); // Call stopMusic when progress completes
    //      context.read<ReminderScreenProvider>().cancelWakeAlarm();
    //   }
    // });
  }

  void cancelProgress() {
    _holdTimer?.cancel();
    _deleteProgress = 0.0;
    notifyListeners();
    stopProgressTimer();
  }

  void _checkSubmit() {
    stopMusic();
    notifyListeners();
  }

  // void stopMusic() {
  //   print("Music stopped"); // Replace this with actual logic to stop music
  // }

  // void enableSubmit(bool value) {
  //   _canSubmit.value = value;
  //   notifyListeners();
  // }

  // method write by wahab

  void stopAudio() {
    _timer?.cancel();
    _timer = null;
    // _isRepeat = false;
    _endTime = null;
    _audioProgrssBarCount = 0;
    notifyListeners();
    _audioPlayer.stop();
    debugPrint("Music Stopped!");
  }

  String? _selectedSoundScreenMusicUrl;
  Future<void> setMusicToPlay(String networkURL) async {
    _selectedSoundScreenMusicUrl = networkURL;
    debugPrint("\nMusic selected. Path : $networkURL\n");
    if(isStartPressed && _isPlaying){
      await playMusic();
    }
    else if(isStartPressed && !_isPlaying){
     await _audioPlayer.stop();
    }
  }


  Future<void> onBackToHomeAndPlayMusic() async {
    toggleStartPressed();
    await playMusic();
  }

  Future<void> playMusic()async{
    try {
      String? networkMusicPath = _selectedSoundScreenMusicUrl ?? _soundSettingProvider?.soundSettings.soundscapes.audioPath;
      debugPrint("\nPlaying Soundscape music...\n");
      // if (isRepeat) {
      //   _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // }
      await _audioPlayer.stop();

      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      final String defaultMusicPath = 'musics/music1.mp3';

      _audioPlayer.setReleaseMode(ReleaseMode.loop);

      /// If music path is not null play network music
      if(networkMusicPath!=null){
        await _audioPlayer.play(UrlSource(networkMusicPath),volume: 1);
      }
      /// Else play a default music
      else{
        await _audioPlayer.play(
          AssetSource(defaultMusicPath),
          volume: 1.0,
        );
      }
      debugPrint("\nMusic played.\n");
    } catch (e) {
      debugPrint("\nError playing music: $e\n");
    }
  }

  Future<void> stopMusic() async {
    // await _audioPlayer.stop();
    // debugPrint('\nMusic stopped\n');
    toggleStartPressed();
    // // if(_isRepeat == true){
    // //   _isRepeat = false;
    // //   notifyListeners();
    // // }
    await _audioPlayer.stop();
    // _audioProgressBarCount = 0.0;
    notifyListeners();
    debugPrint('\nMusic stopped\n');
    debugPrint('\n Stop Music\n');
  }

  void toggleStartPressed() {
    _isStartPressed = !_isStartPressed;
    notifyListeners(); // Notify listeners to update the UI
  }



  bool _isDontRemindMe = false;
  bool get isDontRemindMe => _isDontRemindMe;

  // Constructor to load saved preference

  ValueNotifier<String> currentTimeNotifier = ValueNotifier<String>("");

  Timer? _clockTimer;

  void _startClock() {
    currentTimeNotifier.value = DateFormat('hh mm a').format(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(seconds: 20), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    DateTime now = DateTime.now();
    currentTimeNotifier.value = DateFormat('hh mm a').format(now);
  }



  Future<void> _loadDontRemindPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDontRemindMe = prefs.getBool('dontRemindMe') ?? false;
    notifyListeners();
  }

  // Toggle and save preference
  Future<void> toggleDontRemindMe() async {
    _isDontRemindMe = !_isDontRemindMe;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dontRemindMe', _isDontRemindMe);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressTimer?.cancel();
    _progressTimer = null;
    super.dispose();
  }



}