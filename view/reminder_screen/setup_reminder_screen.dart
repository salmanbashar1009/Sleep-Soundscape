import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/view/reminder_screen/reminder_widgets/add_reminder_header.dart';
import 'package:sleep_soundscape/view/reminder_screen/reminder_widgets/dropdown_widget.dart';
import 'package:sleep_soundscape/view/reminder_screen/reminder_widgets/set_time_widget.dart';

import '../../model_view/reminder_screen_provider.dart';

class SetupReminderScreen extends StatelessWidget{
  const SetupReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 785.h,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 58.h),
      child: SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(6.r),
                width: 115.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            ///Header
            Consumer<ReminderScreenProvider>(
              builder: (_, reminderScreenProvider, child) {
                return AddReminderHeader(
                  headerText: reminderScreenProvider.reminderToSetup!.title,
                  onSave:  () async {
                    debugPrint("\nSetup reminder id that would be cancel : ${reminderScreenProvider.reminderToSetup!.reminderId}\n");
                   await reminderScreenProvider.cancelAndDeleteAlarm();
                    await reminderScreenProvider.setAlarm(
                      isWakeUp: false,
                    );
                   Navigator.pop(context);
                   },

                );
              }
            ),
            SizedBox(height: 25.h),
            Text("Reminder Time"),
            SizedBox(height: 24.h),

            ///Set timer widget
            Consumer<ReminderScreenProvider>(
                builder: (_, reminderScreenProvider, child) {
                  return SetTimer(
                    initialHours: reminderScreenProvider.reminderToSetup!.hours,
                    initialMinutes: reminderScreenProvider.reminderToSetup!.minutes,
                    initialAmPam: reminderScreenProvider.reminderToSetup!.amPm!,

                    onSelectedHour: reminderScreenProvider.setHour,
                    onSelectedMinute: reminderScreenProvider.setMinute,
                    onSelectedAmPm: reminderScreenProvider.setAmPm,
                  );
                }
            ),

            SizedBox(height: 32.h,),
            Text("Advanced"),
            SizedBox(height: 24.h,),

            Consumer<ReminderScreenProvider>(
                builder: (_, reminderScreenProvider, child) {
                return ReminderDropDownButton(
                  hintText: reminderScreenProvider.reminderToSetup?.title,
                  uniqueItemList: reminderScreenProvider.reminderTypeList,
                  onSingleChoice: reminderScreenProvider.onReminderTypeSelect,
                );
              }
            ),

            SizedBox(height: 12.h,),

            Consumer<ReminderScreenProvider>(
              builder: (_,reminderScreenProvider, child) {
                return ReminderDropDownButton(
                  hintText : "Select repeat",
                  uniqueItemList: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
                  isMultipleChoice: true,
                  onMultipleChoice: reminderScreenProvider.onSelectRepeat,
                );
              }
            ),

            SizedBox(height: 50.h,),
          ],
        ),
      ),
    );
  }
}