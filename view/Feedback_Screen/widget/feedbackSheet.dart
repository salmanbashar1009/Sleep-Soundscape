import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/view/Feedback_Screen/widget/customBox.dart';
import 'package:sleep_soundscape/view/Feedback_Screen/widget/inputdecor.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';

import '../../../Utils/route_name.dart';
import '../../../model_view/feedback_provider.dart';
import '../../../model_view/theme_provider.dart';

void showFeedbackSheet({
  required BuildContext context,

}) {
  final darkTheme = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

  showModalBottomSheet(
    context: context,

   // backgroundColor: Color(0xFF212121),
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
    ),
    builder: (context) {
      return Consumer<FeedbackProvider>(
        builder: (context, provider, child) {
         // final FeedbackProvider provider = feedbackProvider;

          return Container(
            width: double.infinity,
            height: 830,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Column(
                    children: [
                      // Drag Indicator
                      Container(
                        height: 6.h,
                        width: 115.w,
                        decoration: BoxDecoration(
                        //  color: Color.fromARGB(255, 44, 47, 49),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Close Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                               // color: const Color.fromARGB(255, 126, 126, 126),
                                width: 1,
                              ),
                            ),
                            child: Image.asset("assets/icons/cancel.png",color: darkTheme ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // Title
                      RichText(
                        text: TextSpan(
                          text: "User Feedback",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            //color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Subtitle
                      Text(
                        "Any problems faced so far?",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          //color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SizedBox(height: 52.h),

                      // Selectable Issue Boxes
                      SizedBox(
                        width: 260.w,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            "Slow loading",
                            "Customer service",
                            "App crash",
                            "Navigation",
                            "Not functional",
                            "Security issues",
                          ].map((text) {
                            return Custombox(
                              text: text,
                              isSelected: provider.selectedBox == text,
                              onTap: () {
                                provider.selectFeedbackBox(text);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Feedback Input Field
                      SizedBox(
                        width: 345.w,
                        height: 194.h,
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          onChanged: provider.updateReviewText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal
                          ),
                          decoration: inputDecoration2(
                            context,
                            null,
                            "Write a review here..",
                            Image.asset(
                              "assets/icons/pencil.png",
                              height: 16.h,
                              width: 16.w, color: darkTheme ? Colors.white : Colors.black
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),


                      Mybutton(
                        text: "Submit",
                        color: Color(0xFFFAD051),
                        ontap: () {
                          context.read<FeedbackProvider>().sendFeedback();
                          Navigator.pushNamed(context, RouteName.homeScreen);

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
