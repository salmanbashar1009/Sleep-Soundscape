import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_soundscape/Utils/route_name.dart';
import 'package:sleep_soundscape/model_view/ForgetPass_provider.dart';
import 'package:sleep_soundscape/model_view/login_auth_provider.dart';
import 'package:sleep_soundscape/view/Login_Screen/ForgetPass_Screnn/forgotPassword_Screen.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/inputDecoration.dart';
import 'package:sleep_soundscape/view/Login_Screen/widget/myButton.dart';
import 'package:sleep_soundscape/view/upload_screen/upload_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final diddy = context.watch<ForgetPassProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Sign In",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 56.h),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Email is required!" ;
                    }
                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400),
                  decoration: inputDecoration(
                    context: context,
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "Enter your Email",
                  ),
                ),

                SizedBox(height: 16.h),
                Consumer<LoginAuthProvider>(
                  builder: (_,loginProvider, child) {
                    return TextFormField(
                      obscureText: loginProvider.isObscureText,
                      controller: _passwordController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Password is required!" ;
                        }
                        if(value.length < 6){
                          return "Password must be at least 6 characters long" ;
                        }
                        return null;
                      },
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        // color: Color(0xFFFFFFFFF).withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: inputDecoration(
                        context: context,
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        hintText: "Enter your password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                             loginProvider.onObscure();
                          },
                          child: Icon(loginProvider.isObscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      ),




                    ),);
                  }
                ),
                SizedBox(height: 12.h),

                GestureDetector(
                  onTap: () {
                    diddy.setPageID(2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotpasswordScreen(),
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",

                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),

                Consumer<LoginAuthProvider>(
                  builder: (context, loginAuthProvider, child) {
                    return loginAuthProvider.isLoginInProgress
                        ? Center(child: CircularProgressIndicator())
                        : Mybutton(
                          text: "Sign in",
                          color: Color(0xffFAD051),
                          ontap: () async {
                            if (_formKey.currentState!.validate())  {

                              await loginAuthProvider.login(email: _emailController.text,
                                  password: _passwordController.text);

                              // await loginAuthProvider.userLogin(
                              //   _emailController.text,
                              //   _passwordController.text,
                              // );
                              //
                              // await AuthStorageService.saveToken(token: loginAuthProvider.loginData!.token!,);

                              debugPrint("\n\n user-token = ${loginAuthProvider.loginData!.token}");

                              if (loginAuthProvider.isSuccessfullyLogin) {

                                if(loginAuthProvider.loginData!.user!.role == "admin"){
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.musicUploadScreen,
                                        (_) => false,
                                  );
                                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const MusicUploadScreen()), (_)=>false);
                                }else{
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.homeScreen,
                                        (_) => false,
                                  );
                                }

                                _emailController.clear();
                                _passwordController.clear();
                              } else {
                                // _emailConteroller.clear();
                                // _passwordController.clear();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Login failed! Try again"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                        );
                  },
                ),

                SizedBox(height: 24.h),
                RichText(
                  text: TextSpan(
                    text: "Have an account? ",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),

                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign up",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteName.signUpScreen,
                                  (_) => false,
                                );
                              },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
