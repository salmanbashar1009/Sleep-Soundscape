import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model_view/sound_setting_provider.dart';
import '../../../model_view/theme_provider.dart';

Widget buildHeader(BuildContext context) {
  final darkTheme = context.watch<ThemeProvider>().isDarkMode;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: ImageIcon(
          AssetImage("assets/icons/back.png"),
          color: darkTheme ? Colors.white : Colors.black,
          size: 32.r,
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Sleep ",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Setting",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Color(0xffFAD051),
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          await Provider.of<SoundSettingProvider>(
            context,
            listen: false,
          ).saveSettings(); // Save settings before closing
          Navigator.pop(context);
        },

        child: Text(
          "Done",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.red,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
