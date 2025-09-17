import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';
import 'package:sleep_soundscape/model_view/sound_screen_provider.dart';
import 'package:sleep_soundscape/model_view/sound_setting_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/ready_to_sleep.dart';
import 'package:sleep_soundscape/view/home_screen/widget/header.dart';
import 'package:sleep_soundscape/view/home_screen/widget/sleep_time_body.dart';
import 'package:sleep_soundscape/view/home_screen/widget/wake_up_time_body.dart';
import '../../model_view/home_screen_provider.dart';
import '../../model_view/reminder_screen_provider.dart';
import '../parent_screen/screen/parent_screen.dart';

import '../reminder_screen/reminder_widgets/set_time_widget.dart';
import 'sound_bottom_sheet_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    debugPrint("\n\nRe-building home screen ...\n");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          if (themeProvider.themeMode == ThemeMode.dark)
            Positioned.fill(
              child: Image.asset(
                "assets/images/home_screen_img.png",
                fit: BoxFit.cover,
              ),
            ),

          /// Foreground view
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Column(
                children: [
                  /// Home Screen Header
                  HomeScreenHeader(),
                  Spacer(),

                  /// Show when sleep soundscape is not started
                  Consumer<HomeScreenProvider>(
                    builder: (_, homeScreenProvider, child) {
                      return Column(
                        children: [
                          homeScreenProvider.isStartPressed
                              ?
                          SleepTimeBody()
                              :
                          /// Wake up time body
                          Consumer<SoundSettingProvider>(
                            builder: (_, alarmSettingProvider, _) {
                              return alarmSettingProvider.soundSettings.alarm.enabled ? WakeUpTimeBody()
                              :
                                  Column(
                                    spacing: 16.h,
                                    children: [
                                      Icon(Icons.alarm_off_outlined,weight: 1,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      size: 45.r,),
                                      Text("Alarm off",
                                      style: Theme.of(context).textTheme.bodyMedium,)
                                    ],
                                  )
                              ;
                            }
                          ),

                          SizedBox(height: 80.h),

                          homeScreenProvider.isStartPressed
                              ? Column(
                                children: [
                                  SizedBox(
                                    width: 100.w,
                                    child: LinearProgressIndicator(
                                      trackGap: 0,
                                      value: homeScreenProvider.progressValue,
                                      minHeight: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundColor:
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondary, // Set the uncompleted color here
                                    ),
                                  ),

                                  SizedBox(height: 10.h),
                                  GestureDetector(
                                    onTap:
                                        () => homeScreenProvider.startProgress(
                                          context,
                                        ),
                                    child:
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(19.r),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Theme.of(context).colorScheme.onSecondary,
                                              width: 1,
                                            ),
                                          ),
                                          child: Container(
                                            width: 18.w,
                                            height: 18.h,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: Theme.of(context).colorScheme.onSecondary,
                                                width: 1,
                                              ),
                                         //     shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(4)
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "Tap to end",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              )
                              :
                              /// Sleep SoundScape start button
                              Consumer<SoundSettingProvider>(
                                builder: (_, alarmSettingProvider, _) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (homeScreenProvider.isDontRemindMe) {
                                        await homeScreenProvider
                                            .onBackToHomeAndPlayMusic();
                                        homeScreenProvider.startProgressTimer();
                                        if(alarmSettingProvider.soundSettings.alarm.enabled){
                                          await context
                                              .read<ReminderScreenProvider>()
                                              .setAlarm(isWakeUp: true);
                                        }

                                        debugPrint('\nSleep soundscape started\n');
                                      } else {
                                        readyToSleep(context);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/start_img.png",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Start",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),
                        ],
                      );
                    },
                  ),

                  Spacer(),
                ],
              ),
            ),
          ),

          /// Bottom Navigation bar
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Consumer<HomeScreenProvider>(
              builder: (_, homeScreenProvider, _) {
                return homeScreenProvider.isStartPressed
                    ? SafeArea(
                      child: Container(
                        margin: EdgeInsets.only(left: 24.w, right: 24.w),
                        width:
                            double
                                .infinity, // Ensure this width works well with your screen size.
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListTile(
                          leading: ClipOval(
                            child: Image.asset(
                              'assets/images/calm.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            "Calm Light",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text("lorem ipsum"),
                          trailing: SizedBox(
                            width: 90.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Consumer<HomeScreenProvider>(
                                  builder: (
                                    context,
                                    homeScreenProvider,
                                    child,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        homeScreenProvider.togglePlayPause(togglePlayPauseWithNewMusic: false);
                                      },
                                      child: Icon(
                                        homeScreenProvider.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<SoundScreenProvider>()
                                        .musicClear();
                                    soundBottomSheet(context);
                                  },
                                  child: Image.asset(
                                    'assets/icons/collection.png',
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    : CustomBottomBar();
              },
            ),
          ),
        ],
      ),
    );
  }
}
