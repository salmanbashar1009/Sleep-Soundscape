import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget buildSoundPreview(BuildContext context, String ringtone,  Function()? onTap,) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r), // Rounded corners
        image: DecorationImage(
          image: AssetImage(
            "assets/images/white_sound.png",
          ), // Replace with your image path
          fit: BoxFit.cover, // Adjust to cover the entire container
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ringtone",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              Text(
                ringtone,
                style: TextStyle(color: Colors.white54, fontSize: 10.sp),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white54,size: 20.sp,),
        ],
      ),
    ),
  );
}
