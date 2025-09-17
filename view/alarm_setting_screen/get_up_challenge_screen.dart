import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../global_widget/switch_button.dart';
import '../../model_view/sound_setting_provider.dart';
import '../../model_view/theme_provider.dart';

void getupChallengeScreen(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ImageIcon(
                    AssetImage("assets/icons/back.png"),
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    size: 32.r,
                  ),
                ),
                SizedBox(width: 70.w),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Get-up ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "challange",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xffFAD051),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 90),
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                children: [
                  Text(
                    "Shake",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/challange.png',
                    width: 120.w,
                    height: 90.h,
                  ),

                  Text(
                    "Shake your phone 30 times to get up",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Shape phone",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Get-up challenge",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Consumer<SoundSettingProvider>(
                  builder: (context, soundSettingProvider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SwitchButton(
                          isSwitchOn:
                              soundSettingProvider
                                  .soundSettings
                                  .advanced
                                  ?.getUpChallenge ??
                              false,
                          onChange: (bool challenge) {
                            soundSettingProvider.setGetUpChallenge(challenge);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Shake times",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Consumer<SoundSettingProvider>(
                      builder: (_, soundSettingProvider, child) {
                        return Text(
                          "${(soundSettingProvider.soundSettings.advanced.shakeTime ?? 0).toString()} ", // int -> String
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
