import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/providers/app_data.dart';
import 'package:monimba_app/screens/auth/signin/signin_screen.dart';
import 'package:monimba_app/screens/auth/signup/signup_screen.dart';
import 'package:monimba_app/screens/main/main_screen.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

void main() {
  // To disable Landscape mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _precacheImageAtLaunch();
  }

  void _precacheImageAtLaunch() {
    const appLogoImage = AssetImage(kLogoMoNimbaPath);
    const appImmoBg = AssetImage(kImmoBgPath);
    const appImmoBg2 = AssetImage(kImmoBg2Path);
    precacheImage(appLogoImage, context);
    precacheImage(appImmoBg, context);
    precacheImage(appImmoBg2, context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'MONIMBA',
            theme: ThemeData(
            scaffoldBackgroundColor: kbackGreyColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            //   textTheme: GoogleFonts.robotoTextTheme(
            //   Theme.of(context).textTheme,
            // ),
            textTheme: GoogleFonts.montserratTextTheme(),
            // textTheme: GoogleFonts.latoTextTheme(),
            // textTheme: GoogleFonts.openSansTextTheme(),
            // textTheme: GoogleFonts.ralewayTextTheme(),
            // textTheme: GoogleFonts.nunitoTextTheme(),
          ),
            home: const SignInScreen()
          );
        },
      ),
    );
  }
}
