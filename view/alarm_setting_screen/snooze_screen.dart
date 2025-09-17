import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';
import '../../model_view/sound_setting_provider.dart';
import '../../model_view/theme_provider.dart';

void snoozeScreen(BuildContext context) {
  final themeProvider = context.read<ThemeProvider>();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
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
                "Snooze",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerRight, // Align dropdown to the right
              child: Consumer<SoundSettingProvider>(
                builder: (context, soundSettingProvider, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ), // Add some padding
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ), // Rounded corners
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween, // Move dropdown to the right
                      children: [
                        Text(
                          "Interval ",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height:
                              50, // Set a fixed height for the dropdown button
                          child: DropdownButton<int>(
                            value:
                                soundSettingProvider
                                    .soundSettings
                                    .advanced
                                    ?.snooze ??
                                1, // Default to 1 min if null
                            dropdownColor:
                                themeProvider.isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors
                                        .white, // Background color of dropdown menu
                            borderRadius: BorderRadius.circular(12),
                            menuMaxHeight:
                                200, // Set max height for dropdown menu
                            underline: SizedBox(), // Remove default underline
                            alignment:
                                AlignmentDirectional
                                    .centerEnd, // Align menu options to the right
                            items: List.generate(
                              59,
                              (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ), // Add padding inside menu items
                                  child: Text(
                                    "${index + 1} min",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                soundSettingProvider.setSnooze(
                                  newValue,
                                ); // Update provider state
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 40.h),

            Align(
              alignment: Alignment.center,
              child: Consumer<SoundSettingProvider>(
                builder: (context, soundSettingProvider, child) {
                  return CustomButton(
                    text: "Save",
                    onPressed: () {
                      Navigator.pop(
                        context,
                        soundSettingProvider.soundSettings.advanced.snooze ??
                            1,
                      ); // Return selected snooze time
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
