import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget sectionTitle(BuildContext context, String title) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      title,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        color:
        Theme.of(context).colorScheme.onSecondary, // Using secondary color
      ),
    ),
  );
}