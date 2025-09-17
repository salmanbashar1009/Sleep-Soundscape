import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/snooze_screen.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/sound_scape_screen.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/section_title.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/setting_header.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/setting_list_tile.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/setting_rington.dart';
import 'package:sleep_soundscape/view/alarm_setting_screen/widget/setting_toggle_list_tile.dart';
import '../../model_view/sound_setting_provider.dart';
import '../home_screen/audio_timer_bottom_sheet.dart';

void alarmSetting(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: MediaQuery.of(context).size.height * 0.96,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.h),
              buildHeader(context),

              SizedBox(height: 35.h),
              sectionTitle(context, "Alarm"),
              Consumer<SoundSettingProvider>(
                builder: (_, soundSettingProvider, _) {
                  return buildSwitchRow(
                    context,
                    "Alarm",
                    soundSettingProvider.soundSettings.alarm.enabled ,
                    soundSettingProvider.toggleAlarm,
                  );
                },
              ),
              // Consumer<SoundSettingProvider>(
              //   builder: (_, soundSettingProvider, child) {
              //     return buildSwitchRow(
              //       context,
              //       "Vibration",
              //       soundSettingProvider.soundSettings.alarm.vibration ?? false,
              //       soundSettingProvider.toggleVibration,
              //     );
              //   },
              // ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Consumer<SoundSettingProvider>(
                      builder: (_, soundSettingProvider, _) {
                        return Slider(
                          value: soundSettingProvider.currentVolume,
                          onChanged: (value) {
                            soundSettingProvider.setVolume(value);
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 100, // More divisions for smoothness
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),

              Align(
                alignment:
                    Alignment.centerLeft, // Aligns the container to the left
                child: Consumer<SoundSettingProvider>(
                  builder: (_, soundSettingProvider, _) {
                    return buildSoundPreview(
                      context,
                      soundSettingProvider.soundSettings.alarm.ringtone.name ,
                      () => soundScapeScreen(context, "ringTon"),
                    );
                  },
                ),
              ),

              SizedBox(height: 18.h),

             // Divider(color: Theme.of(context).colorScheme.onSecondary),
              //SizedBox(height: 18.h),
              // sectionTitle(context, "Sleep Analysis"),0
              // SizedBox(height: 18.h),
              //
              // sectionTitle1(context, "Sounds Detection"),
              // SizedBox(height: 4.h),
              // Consumer<SoundSettingProvider>(
              //   builder: (_, soundSettingProvider, _) {
              //     return infoRow(
              //       context,
              //       "To keep running in low battery, Sleep will stop detection when the battery is below 20% and finish analysis when the battery is below 10%.",
              //       soundSettingProvider
              //               .soundSettings
              //               .sleepAnalysis
              //               .soundsDetection
              //               .enabled ??
              //           false,
              //       () => soundDetectionScreen(context),
              //     );
              //   },
              // ),
              Divider(color: Theme.of(context).colorScheme.onSecondary),
              sectionTitle(context, "Soundscapes"),
              SizedBox(height: 18.h),

              buildInfoRow(
                context,
                "Soundscapes",
                "Calm Light",
                () => soundScapeScreen(context, "music"),
              ),
              SizedBox(height: 35.h),
              Align(alignment: Alignment.topLeft, child: Text("Alarm")),
              //  _buildSectionTitle(context, "Alarm"),
              Consumer<SoundSettingProvider>(
                builder: (_, soundSettingProvider, _) {
                  return buildSwitchRow(
                    context,
                    "Autoplay sounds while sleeping",
                    soundSettingProvider
                            .soundSettings
                            .soundscapes
                            .alarmAutoplay ??
                        false,
                    soundSettingProvider.toggleAutoPlay,
                  );
                },
              ),
              SizedBox(height: 21.h),

              Consumer<SoundSettingProvider>(
                builder: (_, soundSettingProvider, _) {
                  return buildInfoRow(
                    context,
                    "Audio timer",
                    soundSettingProvider.soundSettings.soundscapes.audioTimer ,
                    () => audioTimerBottomSheet(context),
                    // themeProvider,
                  );
                },
              ),
              SizedBox(height: 18.h,),
              Divider(color: Theme.of(context).colorScheme.onSecondary),
              SizedBox(height: 18.h),
              sectionTitle(context, "Advanced"),
              SizedBox(height: 21.h),
              Consumer<SoundSettingProvider>(
                builder: (_, soundSettingProvider, _) {
                  return buildInfoRow(
                    context,
                    "Snooze",
                    soundSettingProvider.soundSettings.advanced.snooze,
                    () => snoozeScreen(context),
                    // themeProvider,
                  );
                },
              ),
              // buildInfoRow(
              //   context,
              //   "Alarm mode",
              //   "Always use",
              //   () => alarmModeScreen(context),
              //   // themeProvider,
              // ),
              // buildInfoRow(
              //   context,
              //   "Get-up Challenge",
              //   "None",
              //   () => getupChallengeScreen(context),
              //   // themeProvider,
              // ),

            ],
          ),
        ),
      );
    },
  );
}
