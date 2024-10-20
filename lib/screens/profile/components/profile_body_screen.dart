import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:logger/logger.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/auth/signin/signin_screen.dart';
import 'package:monimba_app/screens/profile/components/my_real_estate_screen.dart';
import 'package:monimba_app/screens/profile/components/pin_creation.dart';
import 'package:monimba_app/services/database/monimba_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProfileBodyScreen extends StatefulWidget {
  const ProfileBodyScreen({super.key});

  @override
  State<ProfileBodyScreen> createState() => _ProfileBodyScreenState();
}

class _ProfileBodyScreenState extends State<ProfileBodyScreen> {
 int _propertyCount = 0;

  @override
  void initState() {
    super.initState();
    _getPropertyCount();
  }

Future<void> _getPropertyCount() async {
    try {
      int count = await MonimbaDbService().countElementsBasedOnUserEmail();
      setState(() {
        _propertyCount = count; // Update the counter
      });
    } catch (e) {
      Logger().e('Error fetching property count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Pic of connected user
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Container(
                    width: 25.w,
                    height: 12.h,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                    ),
                    child: Image.network(
                      "",
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          kLogoMoNimbaPath,
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const SizedBox(
                              width: 100.0,
                              height: 100.0,
                              // color: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Full name and Phone number
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  "Diallo Thierno Moussa",
                  style: TextStyle(
                    color: kTertiaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Center(
                child: Text(
                  "(+224) 62X XX XX XX",
                  style: TextStyle(
                    color: kTertiaryColor.withOpacity(0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              // Edit btn
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    primary: kBtnsColor,
                  ),
                  child: Text(
                    "Editer Profil",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
          // Section My Real Estate and Support
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biens Immobiliers',
                  style: TextStyle(fontSize: 12.sp, color: kTertiaryColor),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    border: Border.all(
                        color: kTertiaryColor.withOpacity(.5), width: 0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      BuildProfileMenu(
                        mainIcon: Icons.home_work_outlined,
                        text: "Mes biens",
                        isCounter: true,
                        counterValue: _propertyCount.toString().padLeft(2, '0'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyRealEstateScreen()));
                        },
                      ),
                      SizedBox(height: 1.h),
                      BuildProfileMenu(
                        mainIcon: Icons.headset_outlined,
                        text: "Assistance",
                        isCounter: false,
                        counterValue: "0",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section Params and log out
          SizedBox(height: 2.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paramètres',
                  style: TextStyle(fontSize: 12.sp, color: kTertiaryColor),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  height: 19.h,
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    border: Border.all(
                        color: kTertiaryColor.withOpacity(.5), width: 0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const BuildProfileMenu2(
                        mainIcon: Icons.home_work_outlined,
                        text: "Push notifications",
                      ),
                      SizedBox(height: 1.h),
                      BuildProfileMenu(
                        mainIcon: Icons.pin_outlined,
                        text: "Code PIN",
                        isCounter: false,
                        counterValue: "0",
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PinCreationScreen()));
                        },
                      ),
                      SizedBox(height: 1.h),
                      InkWell(
                        onTap: () async {
                          bool? shouldLogout = await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Confirmation',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: kTitleColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Voulez-vous vous déconnecter ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: kTertiaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text(
                                            'Non',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: kTertiaryColor,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kBtnsColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text(
                                            'Oui',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                          if (shouldLogout ?? false) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.remove('jwtToken');
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration:
                                    const BoxDecoration(color: kbackGreyColor),
                                child: const Icon(
                                  Icons.logout_outlined,
                                  size: 25,
                                  color: kBtnsColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Se déconnecter",
                              style:
                                  TextStyle(fontSize: 14.sp, color: kBtnsColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BuildProfileMenu extends StatelessWidget {
  const BuildProfileMenu({
    super.key,
    required this.mainIcon,
    required this.text,
    required this.isCounter,
    required this.counterValue,
    required this.onTap,
  });

  final IconData mainIcon;
  final String text;
  final bool isCounter;
  final String counterValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon + Txt
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(color: kbackGreyColor),
                  child: Icon(
                    mainIcon,
                    size: 25,
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 14.sp, color: kTertiaryColor),
              ),
              SizedBox(
                width: 2.w,
              ),
              isCounter
                  ? Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: kBtnsColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        counterValue.toString(),
                        style: TextStyle(fontSize: 9.sp, color: kPrimaryColor),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          // Arrow icon
          const Icon(
            Icons.arrow_forward_rounded,
            size: 20,
          )
        ],
      ),
    );
  }
}

class BuildProfileMenu2 extends StatefulWidget {
  const BuildProfileMenu2({
    super.key,
    required this.mainIcon,
    required this.text,
  });

  final IconData mainIcon;
  final String text;

  @override
  State<BuildProfileMenu2> createState() => _BuildProfileMenu2State();
}

class _BuildProfileMenu2State extends State<BuildProfileMenu2> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon + Txt
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(color: kbackGreyColor),
                child: Icon(
                  widget.mainIcon,
                  size: 25,
                ),
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              widget.text,
              style: TextStyle(fontSize: 14.sp, color: kTertiaryColor),
            ),
          ],
        ),
        // Switch
        Switch(
          value: isActive,
          onChanged: (bool newValue) {
            setState(() {
              isActive = newValue;
            });
          },
          activeColor: kBtnsColor,
          activeTrackColor: kBtnsColor,
        )
      ],
    );
  }
}
