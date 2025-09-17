import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleep_soundscape/view/reminder_screen/reminder_widgets/reminder_widgets.dart';

// ignore: must_be_immutable
class SetTimer extends StatefulWidget{
  int initialHours;
  int initialMinutes;
  String initialAmPam;
  void Function(int) onSelectedHour;
  void Function(int) onSelectedMinute;
  void Function(int) onSelectedAmPm;
  SetTimer({super.key,
    required this.initialHours,
    required this.initialMinutes,
    required this.initialAmPam,
    required this.onSelectedHour,
    required this.onSelectedMinute,
    required this.onSelectedAmPm});

  @override
  State<SetTimer> createState() => _SetTimerState();
}

class _SetTimerState extends State<SetTimer> {


  List<int> hours = List.generate(12, (index) => index + 1); // 1-12
  List<int> minutes = List.generate(60, (index) => index); // 0-59
  List<String> amPm = ['AM', 'PM'];

  @override
  Widget build(BuildContext context) {
    return   Row(
      spacing: 5.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReminderWidgets().buildCupertinoPicker(
          context,
          hours,
          widget.initialHours,
          widget.onSelectedHour,
          false,
        ),
        Text(":"),
        ReminderWidgets().buildCupertinoPicker(
          context,
          minutes,
          widget.initialMinutes,
          widget.onSelectedMinute,
          false,
        ),

        ReminderWidgets().buildCupertinoPicker(
          context,
          amPm,
          widget.initialAmPam,
          widget.onSelectedAmPm,
          true,
        ),
      ],
    );
  }
}