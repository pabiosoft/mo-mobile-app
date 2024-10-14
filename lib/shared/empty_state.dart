import 'package:flutter/material.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            kEmptyState,
            height: 20.h,
          ),
          SizedBox(height: 2.h),
          Text(
            text,
            style: TextStyle(
                fontSize: 14.sp, color: kTitleColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}