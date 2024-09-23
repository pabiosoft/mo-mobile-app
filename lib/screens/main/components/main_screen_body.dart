import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class MainScreenBody extends StatefulWidget {
  const MainScreenBody({super.key});

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackGreyColor,
        body: Text(
          "MONIMBA PROJECT",
          style: TextStyle(fontSize: 21.sp),
        ),
      ),
    );
  }
}
