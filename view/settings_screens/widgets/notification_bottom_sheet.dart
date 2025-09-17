import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/switch_button.dart';
import 'package:sleep_soundscape/model_view/notification_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'bottom_sheet_header.dart';

void NotificationBottomSheet(BuildContext context) {
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

      return Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Avoid extra space
                children: [
                  SizedBox(height: 6.h),

                  Container(
                    width: 115.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: darkTheme
                          ? const Color.fromRGBO(255, 255, 255, 0.10)
                          : const Color.fromRGBO(0, 0, 0, 0.10),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  BottomSheetHeader(
                    imagePath: "assets/icons/cancel.png",
                    title: "Notifications",
                  ),
                  SizedBox(height: 32.h),

                  notificationTile(
                    context: context,
                    title: "Notifications",
                    value: notificationProvider.isNotificationOn,
                    onChange: (bool value) =>
                        context.read<NotificationProvider>().toggleNotificationSwitch(),
                  ),
                  SizedBox(height: 12.h),

                  notificationTile(
                    context: context,
                    title: "Ring on Silent",
                    value: notificationProvider.isRingOnSilent,
                    onChange: (bool value) =>
                        context.read<NotificationProvider>().toggleRingOnSilentSwitch(),
                  ),
                  SizedBox(height: 12.h),

                  notificationTile(
                    context: context,
                    title: "Pop-up Alert",
                    value: notificationProvider.isPopupAlertOn,
                    onChange: (bool value) =>
                        context.read<NotificationProvider>().togglePopupAlertSwitch(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}




Widget notificationTile({
  required BuildContext context,
  required String title,
  required bool value,
  required ValueChanged<bool> onChange,
}) {

  final darkTheme = context.watch<ThemeProvider>().isDarkMode;

  return Container(
    width: double.infinity,
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: darkTheme ? const Color.fromRGBO(255, 255, 255, 0.04) :  Color.fromRGBO(0, 0, 0, 0.04),
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: darkTheme ? const Color.fromRGBO(255, 255, 255, 0.08):Color.fromRGBO(0, 0, 0, 0.08)),
    ),
    child: Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontFamily: "Lexend",
          ),
        ),
        const Spacer(),
        SwitchButton(onChange: onChange, isSwitchOn: value),
      ],
    ),
  );
}
