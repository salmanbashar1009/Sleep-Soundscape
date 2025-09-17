import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget buildInfoRow(
  BuildContext context,
  String label,
  dynamic value,
  Function()? onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ),
        if (onTap != null)
          Row(
            children: [
              Text(
                (label == "Snooze" || label == "Audio timer") ? "${value.toString() } min" : value.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSecondary,

                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ],
          ),
      ],
    ),
  );
}
