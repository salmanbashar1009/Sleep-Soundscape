import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Utils/route_name.dart';
import '../../../model_view/login_auth_provider.dart';
import '../../../model_view/theme_provider.dart';

class HomeScreenHeader extends StatelessWidget{
  const HomeScreenHeader({super.key});


  @override
  Widget build(BuildContext context) {
    return                   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.profileScreen);
          },
          child: Row(
            spacing: 10.w,
            children: [
              ClipOval(
                child: Consumer<LoginAuthProvider>(
                  builder: (
                      BuildContext context,
                      loginAuthProvider,
                      child,
                      ) {
                    String? imageUrl =
                        loginAuthProvider.loginData?.user?.image;

                    return loginAuthProvider
                        .assetProfilePicturePath !=
                        null
                        ? Image.file(
                      File(
                        loginAuthProvider
                            .assetProfilePicturePath!
                            .path,
                      ),
                      height: 35.h,
                      width: 35.h,
                      fit: BoxFit.cover,
                    )
                        : imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      height: 35.h,
                      width: 35.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                          ) {
                        if (loadingProgress == null) {
                          return child; // Image is fully loaded
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                            loadingProgress
                                .expectedTotalBytes !=
                                null
                                ? loadingProgress
                                .cumulativeBytesLoaded /
                                (loadingProgress
                                    .expectedTotalBytes ??
                                    1)
                                : null,
                            color:
                            Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Image.asset(
                          "assets/images/default_profile_pic.png",
                          height: 35.h,
                          width: 35.h,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      "assets/images/default_profile_pic.png",
                      height: 35.h,
                      width: 35.h,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              Consumer<LoginAuthProvider>(
                builder: (
                    BuildContext context,
                    loginAuthProvider,
                    child,
                    ) {
                  String userName =
                      loginAuthProvider.loginData?.user?.name ??
                          'N/A';

                  return Text(
                    userName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      // color:
                      //     Theme.of(
                      //       context,
                      //     ).colorScheme.onSecondary,
                    ),
                  ); // Display user name
                },
              ),
            ],
          ),
        ),

        /// Theme Switching Button
        GestureDetector(
          onTap: () {
            context.read<ThemeProvider>().toggleTheme();
          },
          child: Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.0,
              ),
            ),
            child:
            Consumer<ThemeProvider>(
              builder: (_, themeProvider, _) {
                return themeProvider.themeMode == ThemeMode.dark
                    ? Icon(
                  Icons.dark_mode_outlined,
                  color:
                  Theme.of(
                    context,
                  ).colorScheme.onSecondary,
                  size: 15.r,
                )
                    : Icon(
                  Icons.light_mode_outlined,
                  color:
                  Theme.of(
                    context,
                  ).colorScheme.onSecondary,
                  size: 15.r,
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}