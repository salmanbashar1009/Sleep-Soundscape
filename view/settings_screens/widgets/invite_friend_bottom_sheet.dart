import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';
import 'package:sleep_soundscape/model_view/reffarel_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: non_constant_identifier_names
void InviteFriendBottomSheet(BuildContext context) {


void _copy(BuildContext context) {
  final refCode = context.read<ReffarelProvider>().refCode; 
  Clipboard.setData(ClipboardData(text: refCode));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Referral Code Copied: $refCode')),
  );
}


void sendSms({required String phoneNumber, String? message}) async {
  final Uri smsUri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message ?? "Hey, join me on Sleep Soundscape!")}");

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    throw 'Could not launch SMS app';
  }
}

void sendEmail({required String recipient, String? subject, String? body}) async {
  final Uri emailUri = Uri.parse(
    'mailto:$recipient?subject=${Uri.encodeComponent(subject ?? "Join me on Sleep Soundscape!")}&body=${Uri.encodeComponent(body ?? "Hey! Use my referral code: ROBER007.")}'
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("No email client found");
  }
}

  
  showModalBottomSheet(
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.w),
        topRight: Radius.circular(10.w),
      ),
    ),
    context: context,
    isScrollControlled: true,
    // backgroundColor: Color(0xFF0F0F13),
    builder: (context) {

      final darkTheme = context.watch<ThemeProvider>().isDarkMode;
      // final tokenCode = LoginAuthProvider().userToken;
      

      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                width: 115.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.10) : Color.fromRGBO(0, 0, 0, 0.10),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              SizedBox(height: 12.h),
              AppBar(
                backgroundColor: Colors.transparent,
                leadingWidth: 32.w,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ImageIcon(
                    AssetImage("assets/icons/back.png"),
                    color: darkTheme ? Colors.white : Colors.black,
                    size: 32.r,
                  ),
                ),
                centerTitle: true,
                title: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontFamily: "Lexend",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: "Get-up  "),
                      TextSpan(
                        text: "Challenge ",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium!.copyWith(
                          fontFamily: "Lexend",
                          color: Color(0xFFFAD051),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        "Invite friends and get reward",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          // color: Color.fromRGBO(255, 255, 255, 0.60),
                          fontFamily: "Lexend",
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      Image.asset(
                        darkTheme ? "assets/images/challenge-reward.png" : "assets/images/reward-light.png",
                        width: 345.w,
                        height: 330.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 32.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Referral code",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          width: double.infinity,
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.08) : Color.fromRGBO(0, 0, 0, 0.08),
                            ),
                            color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.04) : Color.fromRGBO(0, 0, 0, 0.04),
                          ),
    //========================================================================================================================
                          child: Row(
                            children: [
                              Consumer<ReffarelProvider>(
                                builder: (context, reffarelProvider,_) {
                                  
                                  return
                                  
                                  
                                   SelectableText (
                                    reffarelProvider.refCode,
                                    style: Theme.of(
                                      
                                      context,
                                    ).textTheme.bodyMedium
                                  );
                                }
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _copy(context);
                                },
                                child: ImageIcon(
                                  AssetImage("assets/icons/copy.png"),
                                  size: 24.r,
                                  color: darkTheme ? Color.fromRGBO(255, 255, 255, 1) : Colors.black,
                                ),
                              ),
                            ],
                          ),
//==================================================================================================================================
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Send or share to your friends",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),
                      shareItemTile(context: context, imagePath: "assets/icons/msg.png",title: "SMS", onTap: (){ sendSms(phoneNumber: "",message: "Hi\nyour invited to join the sleeepy sleepy app ");}),
                      SizedBox(height: 12.h),
                      shareItemTile(context: context, imagePath: "assets/icons/email.png",title: "Email", onTap: (){ sendEmail(recipient: "",subject:"Welcome to SLeep Sleepy app",body: "man just download this shid aight" );}),

                      SizedBox(height: 24.h),
                      CustomButton(text: "Done", onPressed: () {Navigator.pop(context);}),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget shareItemTile({required BuildContext context, required String imagePath, required String title, required VoidCallback onTap}) {
  final darkTheme = context.watch<ThemeProvider>().isDarkMode;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.08) : Color.fromRGBO(0, 0, 0, 0.08)),
        color: darkTheme ? Color.fromRGBO(255, 255, 255, 0.04) : Color.fromRGBO(0, 0, 0, 0.04),
      ),
      child: Row(
        children: [
          ImageIcon(
            AssetImage(imagePath),
            size: 18.r,
            color: darkTheme ?  Color.fromRGBO(255, 255, 255, 1) : Colors.black,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: ImageIcon(
              AssetImage("assets/icons/arrow-right.png"),
              size: 24.r,
              color: darkTheme ?  Color.fromRGBO(255, 255, 255, 1) : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

