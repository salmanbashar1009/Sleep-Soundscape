import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/api_services/hive_service.dart';
import 'package:sleep_soundscape/api_services/local_storage_services.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/inputDecoration.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';
import 'package:sleep_soundscape/view/settings_screens/widgets/bottom_sheet_header.dart';
import '../../../model_view/delete_user_provider.dart';

void deleteBottomSheet(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 500.h,
        padding: EdgeInsets.all(20.r),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.h),
              Center(
                child: Container(
                  margin: EdgeInsets.all(6.r),
                  width: 115.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              BottomSheetHeader(
                imagePath: "assets/icons/back.png",
                title: "Delete Account !",
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Once deleted, you won’t be able to recover your account. Do you still want to proceed?",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Color(0xFFFAD051)),
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: Image.asset(
                  "assets/icons/emoti.png",
                  height: 70.h,
                  width: 70.w,
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: emailController,
                decoration: inputDecoration(
                  context: context,
                  labelText: "Email",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 20.h),
              Consumer<LoginAuthProvider>(
                builder: (_, loginProvider, __) {
                  return TextFormField(
                    controller: passwordController,
                    obscureText: loginProvider.isObscureText,
                    decoration: inputDecoration(
                      context: context,
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          loginProvider.onObscure();
                        },
                        child: Icon(
                          loginProvider.isObscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Consumer<DeleteUserProvider>(
                builder: (context, deleteProvider, _) {
                  return Column(
                    children: [
                      if (deleteProvider.deleteProgress > 0)
                        LinearProgressIndicator(
                          value: deleteProvider.deleteProgress,
                          backgroundColor: Color(0xffECEFF3),
                          color: Color(0xFFFAD051),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      SizedBox(
                        height: deleteProvider.deleteProgress > 0 ? 10.h : 0,
                      ),

                      GestureDetector(
                        onLongPressStart: (_) {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            deleteProvider.startProgress(() async {
                              await deleteProvider.deleteUser(
                                emailController.text,
                                passwordController.text,
                              );
                              if (deleteProvider.isSucced) {
                                await HiveServices.clearData(
                                  boxName: 'userData',
                                  modelName: 'user',
                                );
                                await AuthStorageService.removeToken(
                                  fieldName: "userToken",
                                );
                                emailController.clear();
                                passwordController.clear();
                                Navigator.pushNamed(
                                  context,
                                  RouteName.signUpScreen,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Account deletion successful..",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                String errorMessage =
                                    deleteProvider.error ??
                                    "Failed to delete account. Try again.";
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          }
                        },
                        onLongPressEnd: (_) => deleteProvider.cancelProgress(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Mybutton(
                              ontap: () {},
                              text:
                                  deleteProvider.isLoading
                                      ? "Deleting..."
                                      : "Confirm (Hold to Delete)",
                              color:
                                  (emailController.text.isNotEmpty &&
                                          passwordController.text.isNotEmpty &&
                                          !deleteProvider.isLoading)
                                      ? Color(0xFFFAD051)
                                      : Color(0xffECEFF3),
                            ),
                            if (deleteProvider.error != null &&
                                deleteProvider.error!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    deleteProvider.error ??
                                        "An error occurred.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    },
  );
}
