import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import 'package:sleep_soundscape/view/settings_screens/widgets/bottom_sheet_header.dart';
import 'package:url_launcher/url_launcher.dart';

// 🔗 Define the URL
final Uri _url = Uri.parse("https://www.backbencher.studio");

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final isSelected = false;


  Future<void> _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final darkTheme = context.watch<ThemeProvider>().isDarkMode;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (themeProvider.themeMode == ThemeMode.dark)
              Positioned.fill(
                child: Image.asset(
                  "assets/images/home_screen_img.png",
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(
                        imagePath: "assets/icons/back.png",
                        title: "About",
                      ),
                      SizedBox(height: 110.h),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Sleep \n",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "Soundscape \n",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xffFAD051),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "Version 1.0.0 \n",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: "Build 3",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "Developer Team:",
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              //color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ) ??
                            TextStyle(
                             // color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Nahidul Islam Shakin \nAbdul Wahab \nSafrid Bhueyan\nHabibul Bashar \nMD Shahriar Asif Rezan",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                             // color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ) ??
                            TextStyle(
                             // color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _launchURL,
                          child: Text(
                            "www.backbencher.studio",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.blue,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                  decoration:
                                      TextDecoration
                                          .underline, // ✨ Underline to look like a hyperlink
                                ) ??
                                TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          "Made with Love from Bangladesh",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                              //  color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ) ??
                              TextStyle(
                               // color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "2025 Sleep Soundscape",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                //color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ) ??
                              TextStyle(
                               // color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
