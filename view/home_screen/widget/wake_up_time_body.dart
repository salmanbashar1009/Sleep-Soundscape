import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../model_view/reminder_screen_provider.dart';
import '../../reminder_screen/reminder_widgets/set_time_widget.dart';

class WakeUpTimeBody extends StatelessWidget{
  const WakeUpTimeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return                               Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Wake up ",
                style:
                Theme.of(
                  context,
                ).textTheme.headlineMedium,
              ),
              TextSpan(
                text: "time",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(
                  color:
                  Theme.of(
                    context,
                  ).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 30.h),

        ///Set timer widget
        Consumer<ReminderScreenProvider>(
          builder: (
              _,
              reminderScreenProvider,
              child,
              ) {
            debugPrint(
              "\n\nSelected hour in home screen: ${reminderScreenProvider.selectedHour}\n\n",
            );
            return SetTimer(
              initialHours:
              reminderScreenProvider.selectedHour,
              initialMinutes:
              reminderScreenProvider
                  .selectedMinute,
              initialAmPam:
              reminderScreenProvider.selectedAmPm,

              onSelectedHour:
              reminderScreenProvider.setHour,
              onSelectedMinute:
              reminderScreenProvider.setMinute,
              onSelectedAmPm:
              reminderScreenProvider.setAmPm,
            );
          },
        ),
      ],
    );
  }
}