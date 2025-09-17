import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';

import '../../model_view/home_screen_provider.dart';
import '../../model_view/sound_setting_provider.dart';
import '../reminder_screen/reminder_widgets/reminder_widgets.dart';

void audioTimerBottomSheet(BuildContext context) {
  final soundSettingProvider = Provider.of<SoundSettingProvider>(
    context,
    listen: false,
  );
  int audioTimer = soundSettingProvider.soundSettings.soundscapes.audioTimer;
  int hours = audioTimer ~/ 60;
  int minutes = audioTimer % 60;
  debugPrint("Hours: $hours, Minutes: $minutes");
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Audio Timer",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "   Hour",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 60.w),
                Text(
                  "Minute",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Snooze Time Dropdown using Consumer
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 197.w,
                height: 139.h,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReminderWidgets().buildCupertinoPicker(
                        context,
                        [0, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12],
                        hours,
                        (value) {
                          //homeScreenProvider.setSelectedHour(value);
                          soundSettingProvider.setSelectedHour(value);
                          debugPrint("Selected hour: ${value}");
                        },
                        false,
                      ),
                      Text(":"),
                      ReminderWidgets().buildCupertinoPicker(
                        context,
                        [
                          0,
                          1,
                          2,
                          3,
                          4,
                          5,
                          6,
                          7,
                          8,
                          9,
                          10,
                          11,
                          12,
                          13,
                          14,
                          15,
                          16,
                          17,
                          18,
                          19,
                          20,
                          21,
                          22,
                          23,
                          24,
                          25,
                          26,
                          27,
                          28,
                          29,
                          30,
                          31,
                          32,
                          33,
                          34,
                          35,
                          36,
                          37,
                          38,
                          39,
                          40,
                          41,
                          42,
                          43,
                          44,
                          45,
                          46,
                          47,
                          48,
                          49,
                          50,
                          51,
                          52,
                          53,
                          54,
                          55,
                          56,
                          57,
                          58,
                          59,
                        ],
                        minutes,
                        (value) {
                          soundSettingProvider.setSelectedMinut(value);

                          //homeScreenProvider.setSelectedMinute(value);
                          context.read<SoundSettingProvider>().setAudioTime();
                          debugPrint("Selected Minute: ${value}");
                        },
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            Align(
              alignment: Alignment.center,
              child: Consumer<HomeScreenProvider>(
                builder: (context, homeScreenProvider, child) {
                  return CustomButton(
                    text: "Set Timer",
                    onPressed: () {
                      debugPrint(
                        "\selected hour: ${homeScreenProvider.selectedHour} \n selected minute: ${homeScreenProvider.selectedMinute}  ",
                      );
                      context.read<SoundSettingProvider>().saveSettings();
                      soundSettingProvider.setTotalMinute();
                      soundSettingProvider.setAudioTime();
                      // homeScreenProvider.updateTotalMinute();
                      homeScreenProvider.startAudio();
                      homeScreenProvider.startProgressTimer();

                      Navigator.pop(context); // Return updated timer value
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      );
    },
  );
}
