

import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier{

  List<String> categories = [
    "Category 1",
    "Category 2",
    "Category 3",
    "Category 4",
    "Category 5",
    "Category 6",
    "Category 7",
  ];

 double sliderValue=0.3;
  double get getSliderValue => sliderValue;

  void setSliderValue(double value){

    sliderValue = value;
    notifyListeners();

  }

  int _selectedCategory=0;
  int get selectedCategory => _selectedCategory;

  void setSelectedCategory(int index){

    _selectedCategory = index;
    notifyListeners();

  }


}