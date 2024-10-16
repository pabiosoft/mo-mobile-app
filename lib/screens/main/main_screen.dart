import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/favorite/components/favorite_screen_body.dart';
import 'package:monimba_app/screens/main/components/main_screen_body.dart';
import 'package:monimba_app/screens/notifications/notif_screen.dart';
import 'package:monimba_app/screens/profile/profile_screen.dart';
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
      const FavBodyScreen(),
      const NotifScreen(),
      const ProfileScreen(),
    ];


    return Scaffold(
      appBar: mainTopBar(),
      body: _navBarItem[currentIndex],
      bottomNavigationBar: bottomNavig(
        size, // The size of the container, e.g., `MediaQuery.of(context).size`
        [
          Icons.home,
          Icons.favorite,
          Icons.notifications,
          Icons.person
        ], // List of icons
        [
          'Accueil',
          'Favoris',
          'Notifications',
          'Profil'
        ], // Corresponding labels
      ),
    );
  }

  Container bottomNavig(
      Size size, List<IconData> listOfIcons, List<String> labels) {
    return Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Highlight Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1300),
                    curve: Curves.linearToEaseOut,
                    margin: EdgeInsets.only(
                      bottom: index == currentIndex ? 0 : size.width * .029,
                      right: size.width * .0612,
                      left: size.width * .0422,
                    ),
                    width: size.width * .140,
                    height: index == currentIndex ? size.width * .010 : 0,
                    decoration: const BoxDecoration(
                      color: kBtnsColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                  ),
                  // Icon
                  Icon(
                    listOfIcons[index],
                    size: size.width * .050,
                    color: index == currentIndex
                        ? kBtnsColor
                        : Colors.black.withOpacity(0.8),
                  ),
                  // Label Text below Icon
                  Text(
                    labels[index], // Assign label based on index
                    style: TextStyle(
                      fontSize: size.width * .030,
                      color: index == currentIndex
                          ? kBtnsColor
                          : Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
