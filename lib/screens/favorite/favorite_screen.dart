import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/main/components/main_screen_body.dart';
import 'package:sizer/sizer.dart';

import 'components/favorite_screen_body.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: kbackGreyColor,
        // appBar: mainTopBar(),
        body: FavBodyScreen(),
      ),
    );
  }


 
}