import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model_view/edit_profile_screen_provider.dart';
import '../../Login_Screen/widget/inputDecoration.dart';
import 'bottom_sheet_header.dart';
void EditProfileBottomSheet(BuildContext context) {
  TextEditingController nameController = TextEditingController(text: context.read<LoginAuthProvider>().loginData?.user?.name);

  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.w),
        topRight: Radius.circular(10.w),
      ),
    ),
    context: context,
    isScrollControlled: true,
    builder: (context) {
     // final darkTheme = context.watch<ThemeProvider>().isDarkMode;
      final appLocalization = AppLocalizations.of(context)!;
    //  final editProfileProvider = Provider.of<EditProfileProvider>(context, listen: false);

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
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              SizedBox(height: 12.h),
              BottomSheetHeader(
                imagePath: "assets/icons/cancel.png",
                title: appLocalization.account_title,
              ),
              SizedBox(height: 32.h),
              Stack(
                children: [
                  Consumer2<LoginAuthProvider, EditProfileProvider>(
                    builder: (_, loginAuthProvider, editProfileProvider, child) {
                      return ClipOval(
                        child: editProfileProvider.tempImage != null ?
                            Image.file(File(editProfileProvider.tempImage!.path),
                              height: 60.h,
                             // width: 60.w,
                              fit: BoxFit.cover,

                            )
                            :
                            loginAuthProvider.assetProfilePicturePath != null ?

                            Image.file(File(loginAuthProvider.assetProfilePicturePath!.path),
                              height: 60.h,
                           //   width: 60.w,
                              fit: BoxFit.cover,

                            )
                            :
                            loginAuthProvider.loginData?.user?.image != null ?

                      Image.network(
                        loginAuthProvider.loginData!.user!.image!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/default_profile_pic.png",
                                      height: 70.h,
                                      width: 70.w,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                :
                      Image.asset(
                                  "assets/images/default_profile_pic.png",
                                  height: 60.h,
                                //  width: 60.w,
                                  fit: BoxFit.cover,
                                ),


                        // Consumer<EditProfileProvider>(
                        //   builder: (context, provider, child) {
                        //     if (provider.selectedImage != null) {
                        //       return Image.file(
                        //         provider.selectedImage!,
                        //         height: 60.h,
                        //       //  width: 65.w,
                        //         fit: BoxFit.cover,
                        //       );
                        //     } else {
                        //       return Consumer<LoginAuthProvider>(
                        //         builder: (BuildContext context, loginAuthProvider,child) {
                        //           String? imageUrl = loginAuthProvider.localUserData?.image;
                        //           return imageUrl != null && imageUrl.isNotEmpty
                        //               ? Image.network(
                        //             imageUrl,
                        //             height: 60.h,
                        //             width: 65.w,
                        //             fit: BoxFit.cover,
                        //             errorBuilder: (context, error, stackTrace) {
                        //               return Image.asset(
                        //                 "assets/images/default_profile_pic.png",
                        //                 height: 60.h,
                        //                 width: 65.w,
                        //                 fit: BoxFit.cover,
                        //               );
                        //             },
                        //           )
                        //               : Image.asset(
                        //             "assets/images/default_profile_pic.png",
                        //             height: 35.h,
                        //             width: 40.w,
                        //             fit: BoxFit.cover,
                        //           );
                        //         },
                        //       );
                        //     }
                        //   },
                        // ),
                      );
                    }
                  ),
                  Positioned(
                    bottom: -3,
                    right: 2,
                    child: GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          context.read<EditProfileProvider>().setImage(File(pickedFile.path));
                        }
                      },
                      child: Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 16.r,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                appLocalization.choose_your_image,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontFamily: "Lexend",
                ),
              ),
              SizedBox(height: 32.h),

              // Name TextField for editing name

                    TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      //  color: Color(0xFFFFFFFFF).withOpacity(0.9),
                        fontWeight: FontWeight.w400
                    ),
                    decoration: inputDecoration(
                      context : context,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  // return TextField(
                  //   controller: nameController,
                  //   onChanged: (newName) {
                  //     editProfileProvider.setName(newName);
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: loginAuthProvider.localUserData?.name ?? "N/A",
                  //     labelText: loginAuthProvider.localUserData?.name ?? "N/A",
                  //   ),

              SizedBox(height: 32.h),
              // Name TextField for editing name
              Consumer<LoginAuthProvider>(
                builder: (BuildContext context,loginAuthProvider,child) {
                  return TextFormField(
                    enabled: false,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      //  color: Color(0xFFFFFFFFF).withOpacity(0.9),
                        fontWeight: FontWeight.w400
                    ),
                    decoration: inputDecoration(
                      context : context,
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText:loginAuthProvider.loginData?.user?.email ?? "N/A",
                    ),
                  );
                  //
                  //   TextField(
                  //   enabled: false,
                  //   decoration: InputDecoration(
                  //     labelText:loginAuthProvider.localUserData?.email ?? "N/A",
                  //     filled: true, // Ensures background change
                  //   ),
                  // );
                },
              ),

              SizedBox(height: 32.h),

              Consumer<EditProfileProvider>(
                builder: (_, editProfileProvider, child) {
                  return editProfileProvider.isLoading ?
                  Center(
                    child: CircularProgressIndicator(),
                  )
                  :
                  CustomButton(
                    text: appLocalization.save_button,
                    onPressed: () async {
                      debugPrint("\nSave button pressed ... \n");

                      await editProfileProvider.editProfile(
                        name: nameController.text.isNotEmpty ?
                            nameController.text
                            : null,
                      );

                      debugPrint("\nis successfully edited : ${editProfileProvider.isSuccessfullyEdited}\n");
                      if (editProfileProvider.isSuccessfullyEdited) {
                        Navigator.pop(context); // Close the bottom sheet

                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Profile update failed",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red
                          ),)),
                        );
                      }
                    },
                  );
                }
              ),
              SizedBox(height: 32.h),

            ],
          ),
        ),
      );
    },
  );
}
