import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleep_soundscape/view/Feedback_Screen/widget/feedbackSheet.dart';
import 'package:sleep_soundscape/view/Feedback_Screen/widget/star_rating_widget.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';

import 'emojies_selactor.dart';

void feedbackshowbottomSheet({
  required BuildContext context,
  dynamic Function()? ontap,
}) {
  showModalBottomSheet(
    context: context,
    //backgroundColor: Color(0xFF212121),
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
    ),
    builder: (context) {
      return Container(
        width: double.infinity,
        height: 600,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  height: 6.h,
                  width: 115.w,
                  decoration: BoxDecoration(
                   // color: Color.fromARGB(255, 44, 47, 49),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),

                // Scrollable & Selectable Emoji Image
                SizedBox(height: 20.h),

                ///Emoji selector widget
                EmojiScrollSelector(),

                SizedBox(height: 20.h),

                RichText(
                  text: TextSpan(
                    text: "Help us ",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    //  color: Color(0xFFFFFFFF),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "improve",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                         // color: Color(0xFFFAD051),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  "Please provide your valuable feedback",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  //  color: Color(0xFFFFFFFF),
                  ),
                ),

                SizedBox(height: 32.h),
                StarRatingWidget(), // Replaced with interactive star rating
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Mybutton(
                    text: "Next",
                    color: Color(0xFFFAD051),
                    ontap: () {
                      Navigator.pop(context);
                      showFeedbackSheet(context: context);
                    },
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}

