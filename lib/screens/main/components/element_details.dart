import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class ElementDetails extends StatefulWidget {
  const ElementDetails({super.key});

  @override
  State<ElementDetails> createState() => _ElementDetailsState();
}

class _ElementDetailsState extends State<ElementDetails> {
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
            "Details",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16.sp,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: kPrimaryColor,
                size: 22.sp,
              ),
              onPressed: () {},
            ),
          ],
          elevation: 10,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              Stack(
                children: [
                  Container(
                    height: 35.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical( bottom: Radius.circular(32)),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://media.istockphoto.com/id/1165384568/fr/photo/complexe-moderne-europ%C3%A9en-de-b%C3%A2timents-r%C3%A9sidentiels.jpg?b=1&s=612x612&w=0&k=20&c=52wNRu6fSrCmbL7zFrduPNj5XwyiyZGWnnZVOJAg1qc='),
                        fit: BoxFit.cover,
                      ),
                      color: kbackGreyColor
                    ),
                  ),
                  // Backdrop Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Property Name and Details
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cosa, Conakry, Guinée",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.green, size: 14.sp),
                        SizedBox(width: 2.w),
                        Text(
                          "Soloprimo 6 dalles, app. 3",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 14.sp),
                        SizedBox(width: 1.w),
                        Text(
                          "4.7 avis (1,700 avis clients)",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Property Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Le potentiel de l’environnement interne et externe est très favorable au bonheur familial et au confort suffisant pour y vivre, à la fois pour les besoins résidentiels et à d’autres fins.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Lire Plus...", style: TextStyle(color: kBtnsColor),),
                    ),
                  ],
                ),
              ),

              // Location Address
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Addresse du bien",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Column(
                      children: [
                        Text(
                          "Consulter la maps ou carte pour plus de details",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2.sp,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network('https://static.vecteezy.com/system/resources/previews/042/656/727/original/guinea-political-map-with-capital-conakry-most-important-cities-with-national-borders-vector.jpg', 
                  height: 20.h,
                  width: double.infinity,
                  fit: BoxFit.cover,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price and Checkout Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: kbackGreyColor,
                  border: Border.all(color: kTertiaryColor, width: .5),
                  borderRadius: BorderRadius.circular(32)
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "400.000.000 GNF",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          primary: kBtnsColor,
                        ),
                        child: Text(
                          "Acheter",
                          style: TextStyle(fontSize: 14.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
