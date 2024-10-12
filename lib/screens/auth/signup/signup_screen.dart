import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackGreyColor,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
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
                  kImmoBg2Path,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image
                        Image.asset(
                          kLogoMoNimbaPath,
                          height: 15.h,
                        ),

                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Title and Subtext
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'MoNimba',
                              style: TextStyle(
                                  color: kTertiaryColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: 80.w,
                              child: Text(
                                'Bienvenue chez MoNimba, votre application pour trouver votre bien immobilier idéal.',
                                style: TextStyle(
                                  color: kTertiaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(2.0, 2.0),
                                      blurRadius: 4.0,
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(height: 2.h),
                            Text(
                                'Inscription',
                                style: TextStyle(
                                  color: kTertiaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(2.0, 2.0),
                                      blurRadius: 4.0,
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                          ],
                        ),
                      ],
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
                    // Signup Button
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
                        onPressed: () {},
                        child: Text(
                          'S\'inscrire',
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
                          "Vous avez un compte? ",
                          style: TextStyle(
                            color: kTertiaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.1,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: kPrimaryColor.withOpacity(.5),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Connectez-vous !',
                            style: TextStyle(
                              color: kBtnsColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1,
                              shadows: [
                                Shadow(
                                  offset: const Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  color: kPrimaryColor.withOpacity(.5),
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
