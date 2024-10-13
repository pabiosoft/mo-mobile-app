import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/profile/components/my_real_estate_details_screen.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateScreen extends StatefulWidget {
  const MyRealEstateScreen({super.key});

  @override
  State<MyRealEstateScreen> createState() => _MyRealEstateScreenState();
}

class _MyRealEstateScreenState extends State<MyRealEstateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackGreyColor,
        appBar: AppBar(
          backgroundColor: kBtnsColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: kPrimaryColor,
              size: 22.sp,
            ),
          ),
          title: Text(
            "Mes biens immobiliers",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Ici,vos',
              //           style: TextStyle(fontSize: 15.sp, color: Colors.black),
              //         ),
              //         Text(
              //           'Biens Immobiliers',
              //           style: TextStyle(
              //               fontSize: 18.sp, fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //     InkWell(onTap: (){
              //       Navigator.pop(context);
              //     }, child: const Icon(Icons.arrow_back_rounded, color: kBtnsColor, size: 50)),
              //   ],
              // ),
              // SizedBox(height: 2.h,),
              // Real estates display
              Expanded(
                child: GridView.builder(
                  itemCount: 5,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    // Applying different margins based on index to achieve offset
                    final isOdd = index % 2 == 1;
                    return Padding(
                      padding: EdgeInsets.only(
                        top: isOdd
                            ? 30.0
                            : 0.0, 
                        left: 16.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: InkWell(onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyRealEstateDetailsScreen() ));
                      }, child: const PropertyCard()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  // final Property property;

  // PropertyCard({required this.property});
  const PropertyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            'https://images.pexels.com/photos/28873273/pexels-photo-28873273/free-photo-of-charmante-maison-de-campagne-aux-tuiles-rouges.jpeg?auto=compress&cs=tinysrgb&w=800',
            fit: BoxFit.cover,
            height: 20.h,
            width: 35.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '200.450.000 gnf',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Maison X",
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          '2150 M²',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
