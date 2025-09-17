import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../view_model/category_provider.dart';

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final ValueNotifier<int> selectedCategory = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Category List')),
      body: Column(
        children: [
          Text("The category data"),

          SizedBox(height: 20.h),
          ValueListenableBuilder<int>(
            valueListenable: selectedCategory,
            builder: (context, selectedIndex, child) {
              return Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryProvider.categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                selectedCategory.value = index;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      isSelected
                                          ? Colors.grey
                                          : Colors.transparent,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Text(categoryProvider.categories[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 50),

          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: categoryProvider.categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          categoryProvider.selectedCategory == index;
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () {
                            categoryProvider.setSelectedCategory(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                              color: isSelected ? Colors.amber : Colors.black87,
                            ),
                            child: Text(categoryProvider.categories[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),

          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return Slider(
                value: categoryProvider.getSliderValue,
                onChanged: (value) {
                  categoryProvider.setSliderValue(value);
                },
                divisions: 200,
              );
            },
          ),

          SizedBox(height: 30),

          DropdownMenu(
            onSelected: (value) {
             debugPrint("Selected Value =====>${value}");
            },
            dropdownMenuEntries: List.generate(9, (index) {

              return DropdownMenuEntry(

                  value: index+1, label: (index + 1).toString());
            }),
          ),
        ],
      ),
    );
  }
}
