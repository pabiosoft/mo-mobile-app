import 'package:flutter/material.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class PinCreationScreen extends StatefulWidget {
  const PinCreationScreen({super.key});

  @override
  _PinCreationScreenState createState() => _PinCreationScreenState();
}

class _PinCreationScreenState extends State<PinCreationScreen> {
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackGreyColor,
      appBar: AppBar(
        backgroundColor: kbackGreyColor,
        elevation: 0,
        brightness: Brightness.light,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kTertiaryColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          "Creation code PIN",
          style: TextStyle(
            color: kTertiaryColor,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Image.asset(
                kLogoMoNimbaPath,
                width: 8.w,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                // Illustration and Title
                Image.network(
                    'https://cdn1.iconfinder.com/data/icons/smashicons-security-yellow/60/3_-PIN_Code-_Yellow-512.png',
                    height: 130),
                const SizedBox(height: 20),
                const Text(
                  'Creation Code Pin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Creation d'un code pin a 04 chiffres",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Progress dots based on pin length
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            index < pin.length ? kBtnsColor : kTertiaryColor,
                      ),
                    );
                  }),
                ),
              ],
            ),
            // Numeric Keypad
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String buttonText;
                      if (index < 9) {
                        buttonText = (index + 1).toString();
                      } else if (index == 9) {
                        buttonText = "v"; // Done btn
                      } else if (index == 10) {
                        buttonText = "0";
                      } else {
                        buttonText = "<"; // Backspace btn
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (buttonText == "<") {
                              // Handle backspace
                              if (pin.isNotEmpty) {
                                pin = pin.substring(0, pin.length - 1);
                              }
                            } else if (buttonText == "v") {
                              // Handle Done/Submit button
                              if (pin.length == 4) {
                                _submitPin(); // Method to handle PIN submission logic
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Le PIN doit contenir 4 chiffres."),
                                  ),
                                );
                              }
                            } else if (buttonText.isNotEmpty &&
                                pin.length < 4) {
                              pin += buttonText;
                            }
                          });

                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: kTertiaryColor,
                          child: buttonText == "<"
                              ? const Icon(
                                  Icons.backspace,
                                  color: Colors.red,
                                )
                              : buttonText == "v" ? const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ) :  Text(
                                  buttonText,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: kTitleColor),
                                ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitPin() {
    // Logic to handle PIN submission
    // For example, make an API call, save locally, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PIN créé avec succès: $pin"),
      ),
    );
  }
}
