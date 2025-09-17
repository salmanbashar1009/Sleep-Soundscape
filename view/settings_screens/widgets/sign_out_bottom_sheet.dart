import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/api_services/hive_service.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';

import '../../../api_services/local_storage_services.dart';
void signOutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    //backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6.h,),
            Container(
              width: 115.w,
              height: 6.h,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100.r)
              ),
            ),
            SizedBox(height: 10.h,),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Are you sure you want to \n",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      // color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "Logout ?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Color(0xffFAD051),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Preferred Earphones
            Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/question_mark.png",height: 146.h,width: 146.w,),
            ),
            SizedBox(height: 30.h),

            CustomButton(text: "Sign out", onPressed: ()async{
              await  AuthStorageService.removeToken(fieldName: 'userToken');
              await HiveServices.clearData(
                boxName:"userData" ,
                modelName: "user",
              );
              Navigator.pushNamedAndRemoveUntil(context, RouteName.signInScreen, (_)=>false);

              debugPrint("Log out Successfully");


            }),
            SizedBox(height: 24.h),
            CustomButton(text: "Cancel", onPressed: (){
              Navigator.pop(context);

            },

              backgroundColor:Theme.of(context).colorScheme.onSecondary,
              textColor: Theme.of(context).colorScheme.onSecondary,

            ),
            SizedBox(height: 24.h),

          ],
        ),
      );
    },
  );
}
