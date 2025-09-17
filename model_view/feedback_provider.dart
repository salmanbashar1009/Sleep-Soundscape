import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../api_services/api_end_point.dart';
import '../api_services/local_storage_services.dart';

class FeedbackProvider extends ChangeNotifier {
  int _selectedIndex = 2;
  int _selectedStars = 5;
  final ScrollController _scrollController = ScrollController();

  List<String> get emojiNames => [
    "angry.png",
    "sad.png",
    "happy.png",
    "neutral.png",
    "not_bad.png",
  ];

  int get selectedIndex => _selectedIndex;
  ScrollController get scrollController => _scrollController;

  String _selectedFeedback = "happy";
  String get selectedFeedback => _selectedFeedback;

  int get selectedStars => _selectedStars;

  String? _selectedBox;
  String? get selectedBox => _selectedBox;

  String _reviewText = "";
  String get reviewText => _reviewText;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  /// Initialize provider and reset selections
  FeedbackProvider() {
    resetAllValues();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedEmoji();
    });
  }

  /// Reset all feedback-related values
  void resetAllValues() {
    _selectedIndex = 2;
    _selectedFeedback = "happy";
    _selectedStars = 5;
    _selectedBox = null;
    _reviewText = "";
    _isSubmitting = false;
    notifyListeners();
    _centerSelectedEmoji();
  }

  void selectEmoji(int index) {
    _selectedIndex = index;
    _selectedFeedback = emojiNames[index].replaceAll(".png", "");
    notifyListeners();
    _centerSelectedEmoji();
  }

  void updateStars(int stars) {
    _selectedStars = stars;
    notifyListeners();
  }

  void selectFeedbackBox(String text) {
    _selectedBox = text;
    notifyListeners();
  }

  void updateReviewText(String text) {
    _reviewText = text;
    notifyListeners();
  }

  /// Center the selected emoji in the list
  void _centerSelectedEmoji() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double screenWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
            WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
        double itemWidth = 73.h + 20.w;
        double selectedSizeOffset = (117.h - 73.h) / 2;
        double offset = (_selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2) - selectedSizeOffset;

        _scrollController.animateTo(
          offset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Calculate emoji size for dynamic selection
  double getEmojiSize(int index) {
    bool isSelected = _selectedIndex == index;
    bool isThirdFromSelected = (index == _selectedIndex - 2 || index == _selectedIndex + 2);
    bool isFourthOrFifthFromSelected =
    (index == _selectedIndex - 3 || index == _selectedIndex + 3 || index == _selectedIndex - 4 || index == _selectedIndex + 4);

    if (isSelected) return 117.h;
    if (isThirdFromSelected) return 43.h;
    if (isFourthOrFifthFromSelected) return 30.h;
    return 73.h;
  }

  /// Submit feedback asynchronously using Isolate
  Future<void> sendFeedback() async {
    if (_isSubmitting) return; // Prevent multiple submissions

    _isSubmitting = true;
    notifyListeners();

    try {
      final token = await AuthStorageService.fetchFromSharedPreferences(fieldName: "userToken");

      if (token == null || token.isEmpty) {
        debugPrint("Error: No authentication token found.");
        _showToast("Authentication error. Please log in again.", Colors.red);
        _isSubmitting = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> feedbackData = {
        "reading": _selectedStars,
        "emoji": _selectedFeedback,
        "category": _selectedBox ?? "No category selected",
        "description": _reviewText.isNotEmpty ? _reviewText : "No review provided",
      };

      final apiParams = {
        "url": AppUrls.feedbackCreate,
        "token": token,
        "feedbackData": jsonEncode(feedbackData),
      };

      /// Call API in an Isolate
      final result = await Isolate.run(() => _performApiCall(apiParams));

      if (result["status"] == "success") {
        debugPrint("Feedback submitted successfully!");
        _showToast("Feedback submitted successfully!", Colors.green);
        resetAllValues(); // Reset form after successful submission
      } else {
        debugPrint("Failed to submit feedback: ${result['message']}");
        _showToast("Failed to submit feedback. Try again!", Colors.red);
      }
    } catch (e) {
      debugPrint("Error submitting feedback: $e");
      _showToast("Something went wrong. Try again!", Colors.red);
    }

    _isSubmitting = false;
    notifyListeners();
  }

  /// Perform API call in an Isolate
  static Future<Map<String, dynamic>> _performApiCall(Map<String, dynamic> params) async {
    try {
      final Uri url = Uri.parse(params["url"]);
      final String token = params["token"];
      final String feedbackData = params["feedbackData"];

      final headers = {
        "Content-Type": "application/json",
        "Authorization": token,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: feedbackData,
      );

      final responseData = jsonDecode(response.body);
      debugPrint("API Response (Isolate): $responseData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success"};
      } else {
        return {"status": "error", "message": response.body};
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  /// Show a toast message
  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
