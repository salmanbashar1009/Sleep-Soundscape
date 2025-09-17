import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoSection(BuildContext context, String title, String description) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            //   color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    ),
  );
}