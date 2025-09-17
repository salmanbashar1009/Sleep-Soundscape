import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../model_view/parent_screen_provider.dart';
import '../../../model_view/sound_screen_provider.dart';
import '../../../model_view/theme_provider.dart';
import '../../alarm_setting_screen/alarm_setting_screen.dart';
import '../../home_screen/sound_bottom_sheet_screen.dart';
import '../../home_screen/audio_timer_bottom_sheet.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = context.watch<ThemeProvider>();
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only( left: 24.w, right: 24.w),
        width: double.infinity, // Ensure this width works well with your screen size.
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem(
              context,
              index: 0,
              icon: Icons.alarm,
              label: "Alarm",
            ),
            _buildNavItem(
              context,
              index: 1,
              icon: Icons.surround_sound_sharp,
              label: "Sounds",
            ),
            _buildNavItem(
              context,
              index: 3,
              icon: Icons.alarm_on_rounded,
              label: "Audio",
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable method to build each bottom navigation item.
  Widget _buildNavItem(BuildContext context,
      {required int index, required IconData icon, required String label}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Open corresponding bottom sheet based on index.
          if (index == 0) {
            alarmSetting(context);
          } else if (index == 1) {
             context.read<SoundScreenProvider>().musicClear();
             soundBottomSheet(context);
          } else if (index == 3) {
            audioTimerBottomSheet(context);
          }
          // Update the provider with the selected index.
          context.read<ParentScreensProvider>().onSelectedIndex(index);
        },
        child: Consumer<ParentScreensProvider>(
          builder: (_, provider, child) {
            bool isSelected = provider.selectedIndex == index;
            return Container(
            //  height: 69.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                // Optionally add a shadow if selected
                boxShadow: isSelected ? [] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
