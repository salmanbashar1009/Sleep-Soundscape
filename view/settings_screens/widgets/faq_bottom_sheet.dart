import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/FAQ_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';
import 'package:sleep_soundscape/view/settings_screens/widgets/bottom_sheet_header.dart';

void faqBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      final darkTheme = context.watch<ThemeProvider>().isDarkMode;
      final faqProvider = Provider.of<FaqProvider>(context);

      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Center(
              child: Container(
                width: 115.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: darkTheme
                      ? Color.fromRGBO(255, 255, 255, 0.10)
                      : Color.fromRGBO(0, 0, 0, 0.10),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            BottomSheetHeader(
              imagePath: "assets/icons/back.png",
              title: "FAQs",
            ),
            SizedBox(height: 24.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: TextFormField(
                onChanged: (value) => faqProvider.updateSearch(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: darkTheme ? Colors.white54 : Colors.black54),
                  hintText: "Search",
                  hintStyle: TextStyle(color: darkTheme ? Colors.white54 : Colors.black54, fontSize: 14.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: faqProvider.questions.length,
                itemBuilder: (context, index) {
                  final questionData = faqProvider.questions[index];
                  final isExpanded = faqProvider.expansionStates[index] ?? false;

                  return Card(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide.none,
                    ),
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide.none,
                      ),
                      title: Text(
                        questionData["question"]!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                      ),
                      onExpansionChanged: (expanded) => faqProvider.onExpanded(index),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          child: Text(
                            questionData["ans"]!,
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Mybutton(text: "Back", color: Color(0xFFFAD051), ontap: () {
              Navigator.pop(context);
            }),
            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}