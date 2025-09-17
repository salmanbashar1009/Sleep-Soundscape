
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/global_widget/custom_button.dart';
import 'package:sleep_soundscape/model_view/ForgetPass_provider.dart';
import 'package:sleep_soundscape/model_view/theme_provider.dart';
import '../../../model_view/change_password_provider.dart';

void ChangePasswordBottomSheet(BuildContext context) {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form Key for validation

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
      final darkTheme = context.watch<ThemeProvider>().isDarkMode;
      final diddy = context.watch<ForgetPassProvider>();
      return Consumer<ChangePasswordProvider>(
        builder: (context, changePasswordProvider, child) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 6.h),
                    Container(
                      width: 115.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: darkTheme
                            ? Color.fromRGBO(255, 255, 255, 0.10)
                            : Color.fromRGBO(0, 0, 0, 0.10),
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
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium!.copyWith(
                            fontFamily: "Lexend",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: "Change "),
                            TextSpan(
                              text: "Password ",
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
                    SizedBox(height: 24.h),
                    Text(
                      "Please enter the details below to change your password.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // **Text Fields with Validation**
                    textFormField(
                      context,
                      "Enter your Current Password",
                      currentPassController,
                      changePasswordProvider.isCurrentPasswordObscure,
                      onVisibilityToggle: () {
                        changePasswordProvider.toggleCurrentPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 12.h),
                    textFormField(
                      context,
                      "Enter New Password",
                      newPassController,
                      changePasswordProvider.isNewPasswordObscure,
                      onVisibilityToggle: () {
                        changePasswordProvider.toggleNewPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 12.h),
                    textFormField(
                      context,
                      "Re-Enter New Password",
                      confirmPassController,
                      changePasswordProvider.isConfirmPasswordObscure,
                      onVisibilityToggle: () {
                        changePasswordProvider.toggleConfirmPasswordVisibility();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please confirm your new password";
                        }
                        if (value != newPassController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          diddy.setPageID(3);
                          Navigator.pushNamed(
                            context,
                            RouteName.forgotPassword,
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(
                            color: Color(0xFFFAD051),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Lexend",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    changePasswordProvider.isLoading
                        ? CircularProgressIndicator()
                        : CustomButton(
                      text: "Done",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await changePasswordProvider.changePassword(
                            currentPassController.text,
                            newPassController.text,
                            confirmPassController.text,
                          );

                          if (changePasswordProvider.issuccessfull) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Password change failed! Try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

TextFormField textFormField(
    BuildContext context,
    String hintText,
    TextEditingController controller,
    bool isObscureText, {
      String? Function(String?)? validator,
      required VoidCallback onVisibilityToggle,
    }) {
  return TextFormField(
    controller: controller,
    style: Theme.of(context).textTheme.bodyLarge,
    obscureText: isObscureText,
    validator: validator,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w300,
        fontFamily: "Lexend",
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(12.r),
        child: ImageIcon(
          AssetImage("assets/icons/lock.png"),
          size: 18.r,
          color: context.watch<ThemeProvider>().isDarkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
      suffixIcon: GestureDetector(
        onTap: onVisibilityToggle,
        child: Icon(
          isObscureText ? Icons.visibility_off_outlined: Icons.visibility_outlined  ,
          color: Color.fromRGBO(255, 255, 255, 0.6),
          size: 18.r,
        ),
      ),
    ),
  );
}
