import 'package:flutter/material.dart';

class FaqProvider with ChangeNotifier {
  List<Map<String, String>> _questions = [
    {
      "question": "What is Sleep Soundscape and how does it work?",
      "ans":
          "Sleep Soundscape is a relaxation app that provides a variety of soothing sounds designed to help you fall asleep faster, improve sleep quality, and reduce stress. You can choose from nature sounds, white noise, meditation tracks, and more."
    },
    {
      "question": "Does the app work offline?",
      "ans":
          "Yes! Once you download your favorite sound packs, you can play them anytime without an internet connection."
    },
    {
      "question": "How can I set a sleep timer?",
      "ans":
          "You can set a sleep timer by selecting the clock icon on the sound player. Choose how long you want the sound to play before it stops automatically."
    },
    {
      "question": "Can I use Sleep Soundscape while using other apps?",
      "ans":
          "Yes! Sleep Soundscape can run in the background, so you can continue using other apps while listening to your favorite sounds."
    },
  ];

  List<Map<String, String>> _filteredQuestions = [];

  
  List<Map<String, String>> get questions => _filteredQuestions;

  
  Map<int, bool> _expansionStates = {};

  
  Map<int, bool> get expansionStates => _expansionStates;

  
  String _searchText = "";
  String get searchText => _searchText;

  
  FaqProvider() {
    _filteredQuestions = List.from(_questions); 
    _expansionStates = {for (var i = 0; i < _questions.length; i++) i: false};
  }

  void onExpanded(int index) {
    _expansionStates[index] = !_expansionStates[index]!;
    notifyListeners();
  }

  void updateSearch(String word) {
    _searchText = word;
    if (_searchText.isEmpty) {
      _filteredQuestions = List.from(_questions); 
    } else {
      _filteredQuestions = _questions
          .where((element) =>
              element["question"]!.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
    _expansionStates = {for (var i = 0; i < _filteredQuestions.length; i++) i: false};
    notifyListeners();
  }
}