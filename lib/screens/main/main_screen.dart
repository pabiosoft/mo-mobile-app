import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/main/components/main_screen_body.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;

    List<Widget> _navBarItem = <Widget>[
      const MainScreenBody(),
      const MainScreenBody(),
      const MainScreenBody(),
      const MainScreenBody(),
        
    ];

    List<IconData> listOfIcons = [
      FontAwesomeIcons.home,
      FontAwesomeIcons.inbox,
      FontAwesomeIcons.feed,
      FontAwesomeIcons.userShield,
    ];

    
    return Scaffold(
      appBar: mainTopBar(), 
       body:_navBarItem[currentIndex],
      bottomNavigationBar: bottomNavig(size, listOfIcons),

    );
  }

  Container bottomNavig(Size size, List<IconData> listOfIcons) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: size.width * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        // borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: listOfIcons.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * .024),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              currentIndex = index;
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1300),
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: EdgeInsets.only(
                      bottom: index == currentIndex ? 0 : size.width * .029,
                      right: size.width * .0422,
                      left: size.width * .0422,
                    ),
                    width: size.width * .140,
                    height: index == currentIndex ? size.width * .010 : 0,
                    decoration: const BoxDecoration(
                      color: kBtnsColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                  ),
                  Icon(
                    listOfIcons[index],
                    size: size.width * .050,
                    color: index == currentIndex
                        ? kBtnsColor
                        : Colors.black.withOpacity(0.8),
                  ),
                  SizedBox(height: size.width * .03),
                ],
              ),
             ],
          ),
        ),
      ),
    );
  }


  PreferredSize mainTopBar() {
    return PreferredSize(
      // preferredSize: const Size.fromHeight(75),
      preferredSize: SizerUtil.deviceType == DeviceType.mobile
          ? Size.fromHeight(9.h)
          : Size.fromHeight(9.h),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 0.0,
          top: SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 0.0,
        ),
        child: // Main MONIMBA - Top Header
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // MONIMBA LOGO
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: kbackGreyColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  kLogoMoNimbaPath,
                  width: 12.w,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Votre position",
                          style: TextStyle(
                            color: kSecondaryBlackColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              kPinLocationSvg,
                              color: kBtnsColor,
                              width: 5.w,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              "Conakry Guinée",
                              style: TextStyle(
                                color: kSecondaryBlackColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Notification Icon

              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: kbackGreyColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const NotificationIconWithBadge(notificationCount: 5))
            ]),
      ),
    );
  }
}