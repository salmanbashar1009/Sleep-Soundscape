import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/home_screen_provider.dart';
import 'package:sleep_soundscape/model_view/sound_setting_provider.dart';

import '../../../model_view/reminder_screen_provider.dart';

class SleepTimeBody extends StatelessWidget{
  const SleepTimeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return     Column(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: context.watch<HomeScreenProvider>().currentTimeNotifier,
          builder: (_, formattedTime, __) {
            return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    "${formattedTime.split(' ')[0]} \n", // Hours
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 36.sp),
                  ),
                  TextSpan(
                    text:
                    "${formattedTime.split(' ')[1]}   ", // Minutes
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      color: Color(0xffFAD051),
                      fontSize: 36.sp,
                    ),
                  ),
                  TextSpan(
                    text:
                    "${formattedTime.split(' ')[2]} ", // AM/PM
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
              Theme.of(
                context,
              ).colorScheme.secondary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.r),
            color:
            Theme.of(
              context,
            ).colorScheme.secondary,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 17.w,
            vertical: 13.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<SoundSettingProvider>(
                builder: (_, alarmSettingProvider, _) {
                  return Icon(
                    alarmSettingProvider.soundSettings.alarm.enabled ?
                    Icons.alarm : Icons.alarm_off_outlined,
                    color:
                    Theme.of(
                      context,
                    ).colorScheme.onSecondary,
                    size: 24.r,
                  );
                }
              ),
              SizedBox(width: 10.w),
              Consumer2<ReminderScreenProvider, SoundSettingProvider>(
                builder: (
                    _,
                    reminderScreenProvider,
                    alarmSettingProvider,
                    _,
                    ) {
                  return Text(
                          alarmSettingProvider.soundSettings.alarm.enabled
                              ? "${reminderScreenProvider.selectedHour.toString()}:${                          reminderScreenProvider
                              .selectedMinute
                              .toString()} ${reminderScreenProvider.selectedAmPm.toString()}": "Alarm Off",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary
                    ),
                      );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}