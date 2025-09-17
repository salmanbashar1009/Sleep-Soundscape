import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';
import 'package:sleep_soundscape/model_view/home_screen_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model_view/reminder_screen_provider.dart';

void readyToSleep(BuildContext context) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.w),
        topRight: Radius.circular(10.w),
      ),
    ),
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final darkTheme = context.watch<ThemeProvider>().isDarkMode;
      final appLocalization = AppLocalizations.of(context)!;
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                width: 115.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color:
                      darkTheme
                          ? Color.fromRGBO(255, 255, 255, 0.10)
                          : Color.fromRGBO(0, 0, 0, 0.10),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                appLocalization.ready_to_sleep,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: darkTheme ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 24.h),
              Image.asset("assets/images/charger.png"),
              SizedBox(height: 24.h),
              Text(
                appLocalization.ready_to_sleep_description,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      darkTheme
                          ? Color.fromRGBO(255, 255, 255, 0.6)
                          : Color.fromRGBO(0, 0, 0, 0.6),
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 24.h),
              Consumer<HomeScreenProvider>(
                builder: (context, homeScreenProvider, child) {
                  return CustomButton(
                    text: appLocalization.back_to_home,
                    onPressed: () async {
                      await homeScreenProvider.onBackToHomeAndPlayMusic();
                      homeScreenProvider.startProgressTimer();
                      await context.read<ReminderScreenProvider>().setAlarm(
                        isWakeUp: true,
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  context.watch<HomeScreenProvider>().toggleDontRemindMe();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      context.watch<HomeScreenProvider>().isDontRemindMe
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: darkTheme ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      appLocalization.dont_remind_me,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w300,

                        color:
                            darkTheme
                                ? Color.fromRGBO(255, 255, 255, 0.6)
                                : Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
