import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import '../Utils/AppConfig.dart';
import '../api_services/api_end_point.dart';
import '../api_services/api_services.dart';
import '../model/downloadModel.dart';

class DownloadProvider extends ChangeNotifier {
  final Dio dio = Dio();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Map<String, int> downloadProgress = {};
  Map<String, String> downloadedFiles = {};
  final int _notificationId = 100;
  String fileTitle = "dummy_file";

  final List<Sounds> _sounds = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Sounds> get sounds => _sounds;

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  DownloadProvider() {
  //  _initNotifications();
  }

  // Future<void> _initNotifications() async {
  //   print("Initializing Notifications...");
  //
  //   const AndroidInitializationSettings androidSettings =
  //       AndroidInitializationSettings('assets/brand_logo.png');
  //
  //   const InitializationSettings settings = InitializationSettings(
  //     android: androidSettings,
  //   );
  //
  //   await flutterLocalNotificationsPlugin.initialize(
  //     settings,
  //     onDidReceiveNotificationResponse: (NotificationResponse response) async {
  //       if (response.payload != null) {
  //         _openDownloadedFile(response.payload!);
  //       }
  //     },
  //   );
  //
  //   print("Notifications Initialized.");
  // }

  /// Fetch sounds using Isolate and implement pagination
  Future<void> fetchSounds() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    debugPrint("Fetching sounds...");

    try {
      final String url = AppUrls.getSounds(
        page: _currentPage,
        limit: AppConfig.downloadSoundDataLimit,
      );
      debugPrint("API URL: $url");

      /// Call `_performApiCall` inside an Isolate
      final result = await Isolate.run(() => _performApiCall(url));

      if (result["status"] == "success") {
        final DownloadModel data = result["data"];

        if (data.sounds != null) {
          _sounds.addAll(data.sounds!);
          debugPrint("Fetched ${data.sounds!.length} sounds.");
        }

        _hasMore = data.hasMore ?? false;
        _currentPage++;
      } else {
        debugPrint("API Error: ${result['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching sounds: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Perform API call inside an Isolate
  static Future<Map<String, dynamic>> _performApiCall(String url) async {
    try {
      final response = await ApiServices.getApi(url: url);

      if (response.statusCode == 200) {
        debugPrint("API Response: ${response.body}");

        final parsedData = jsonDecode(response.body);
        final DownloadModel data = DownloadModel.fromJson(parsedData);
        return {"status": "success", "data": data};
      } else {
        debugPrint("API Call Failed: ${response.body}");
        return {"status": "error", "message": response.body};
      }
    } catch (e) {
      debugPrint("Exception during API call: $e");
      return {"status": "error", "message": e.toString()};
    }
  }

  /// Reset pagination
  void reset() {
    _sounds.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }
/// Show a progress notification during file download.
  Future<void> _showProgressNotification(String fileName, int progress) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      onlyAlertOnce: false,
      maxProgress: 100,
      progress: progress,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      _notificationId,
      'Downloading $fileName',
      '$progress% completed',
      details,
    );
  }

  /// Cancel the progress notification after download completion.
  Future<void> _cancelProgressNotification() async {
    await flutterLocalNotificationsPlugin.cancel(_notificationId);
    print("Progress notification dismissed.");
  }

  Future<void> _showDownloadCompleteNotification(
    String filePath,
    String fileName,
  ) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      _notificationId + 1,
      'Download Complete',
      'Tap to open $fileName',
      details,
      payload: filePath,
    );
  }

  /// Request storage permission for Android devices.
  Future<bool> requestStoragePermission() async {
    print("Checking Storage Permission...");

    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        print("Storage Permission Granted.");
        return true;
      }
      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        print("Permission Permanently Denied. Opening Settings...");
        await openAppSettings();
        return false;
      }
    }

    return false;
  }

  /// Get the appropriate download path based on the platform.
  Future<String> _getDownloadPath() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Sleep_Soundscape");
      if (!await directory.exists()) {
        print("Creating Sleep_Soundscape folder...");
        await directory.create(recursive: true);
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    print("Download Path: ${directory.path}");
    return directory.path;
  }

  /// Generate a unique file path to avoid overwriting existing files.
  Future<String> _getUniqueFilePath(String directoryPath) async {
    String baseName = fileTitle;
    String newFilePath = "$directoryPath/$baseName.mp3";
    int counter = 1;

    while (await File(newFilePath).exists()) {
      newFilePath = "$directoryPath/${baseName}($counter).mp3";
      counter++;
    }

    print("Unique File Path: $newFilePath");
    return newFilePath;
  }

  /// Initiate the file download process.
  Future<void> downloadFile(String audioPath, String title) async {
    String url = audioPath;
    fileTitle = title.toLowerCase();

    print("Starting download for: $fileTitle.mp3");

    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      print("Download aborted due to missing storage permission.");
      return;
    }

    String directoryPath = await _getDownloadPath();
    String savePath = await _getUniqueFilePath(directoryPath);

    ReceivePort receivePort = ReceivePort();
    Isolate.spawn(_downloadFileInIsolate, [
      receivePort.sendPort,
      url,
      savePath,
    ]);

    receivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        if (message.containsKey("progress")) {
          int progress = message["progress"];
          downloadProgress[fileTitle] = progress;
          notifyListeners();
          _showProgressNotification(fileTitle, progress);
        } else if (message.containsKey("filePath")) {
          String filePath = message["filePath"];
          print("File successfully downloaded: $filePath");

          _cancelProgressNotification();
          downloadProgress.remove(fileTitle);
          downloadedFiles[fileTitle] = filePath;
          notifyListeners();
          _showDownloadCompleteNotification(filePath, fileTitle);
        }
      } else if (message is String && message.startsWith("error")) {
        print("Download failed: $message");
        downloadProgress.remove(fileTitle);
        notifyListeners();
      }
    });
  }

  /// Perform the actual file download inside an Isolate.
  static Future<void> _downloadFileInIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    String url = args[1];
    String savePath = args[2];

    try {
      Dio dio = Dio();

      print("Final Save Path in Isolate: $savePath");

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            int percentage = ((received / total) * 100).toInt();
            sendPort.send({"progress": percentage});
          }
        },
      );

      sendPort.send({"filePath": savePath});
    } catch (e) {
      sendPort.send("error: $e");
    }
  }

  Future<void> _openDownloadedFile(String filePath) async {
    print("Opening file: $filePath");
    OpenFile.open(filePath);
  }
}
