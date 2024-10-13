import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/auth/signup/signup_screen.dart';
import 'package:monimba_app/screens/main/main_screen.dart';
import 'package:sizer/sizer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackGreyColor,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity:
                  0.6, 
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  kImmoBgPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5.h),
                    // Top Image
                    Image.asset(
                      kLogoMoNimbaPath, 
                      height: 20.h,
                    ),
                    SizedBox(height: 4.h),
                    // Title and Subtext
                    Text(
                      'MoNimba',
                      style: TextStyle(
                          color: kTertiaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 4.h),
                    Text(
                      'Se connecter avec une adresse email',
                      style: TextStyle(
                        color: kTertiaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: kPrimaryColor
                                .withOpacity(0.5), 
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 3.h),
                    // Email Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Adresse Email',
                        labelStyle: const TextStyle(color: kTertiaryColor),
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: kBtnsColor,
                            width: 2.0,
                          ),
                        ),
                        prefixIconColor: kTertiaryColor,
                        focusColor: kBtnsColor,
                      ),
                    ),

                    SizedBox(height: 2.h),
                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: const TextStyle(color: kTertiaryColor),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.visibility),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: kBtnsColor,
                            width: 2.0,
                          ),
                        ),
                        prefixIconColor: kTertiaryColor,
                        focusColor: kBtnsColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            color: kBtnsColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.1,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: kPrimaryColor.withOpacity(
                                    0.5), 
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // SignIn Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBtnsColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainScreen() ));
                        },
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Sign up option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pas de compte? ",
                          style: TextStyle(
                            color: kTertiaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.1,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: kPrimaryColor.withOpacity(
                                    1), 
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen() ));
                          },
                          child: Text(
                            'S\'incrire',
                            style: TextStyle(
                              color: kBtnsColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1,
                              shadows: [
                                Shadow(
                                  offset: const Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  color: kPrimaryColor.withOpacity(
                                      1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
