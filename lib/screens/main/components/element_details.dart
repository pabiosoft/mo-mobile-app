import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/models/elements.dart';
import 'package:sizer/sizer.dart';

class ElementDetails extends StatefulWidget {
  const ElementDetails({super.key, required this.element});
  final ElementModel element;

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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              Stack(
                children: [
                  Container(
                    height: 35.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32)),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://abc.monimba.com/${widget.element.imageUrl}"),
                          fit: BoxFit.cover,
                        ),
                        color: kbackGreyColor),
                  ),
                  // Backdrop Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white.withOpacity(0.2),
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
                      "${widget.element.name}, Conakry, Guinée",
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
                          widget.element.locate,
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
                      widget.element.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Lire Plus...",
                        style: TextStyle(color: kBtnsColor),
                      ),
                    ),
                  ],
                ),
              ),

              // Sell or loaner Info
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.element.desired == 'Vente'
                          ? "Vendeur du bien"
                          : "Votre hote",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kBtnsColor,
                              ),
                              color: kPrimaryColor,
                            ),
                            child: widget.element.user.imgUrl != ''
                                ? Image.network(
                                    widget.element.user.imgUrl,
                                    width: 15.w,
                                  )
                                : Image.network(
                                    'https://img.freepik.com/psd-gratuit/illustration-3d-personne-lunettes_23-2149436190.jpg?size=626&ext=jpg',
                                    width: 15.w,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.element.user.fullName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: kTertiaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                widget.element.user.bio,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 2.h,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ce bien se trouve à : ${widget.element.locate}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Consulter la maps ou carte pour plus de details",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          height: 2.sp,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              'https://static.vecteezy.com/system/resources/previews/042/656/727/original/guinea-political-map-with-capital-conakry-most-important-cities-with-national-borders-vector.jpg',
                              height: 20.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                    border: Border.all(color: kTertiaryColor, width: .1),
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            kBtnsColor.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                    
                    ),
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${NumberFormat("#,##0", "en_US").format(int.parse(widget.element.price)).replaceAll(',', '.')} GNF",
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
                          widget.element.desired == 'Vente'
                              ? "Acheter"
                              : "Louer",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white),
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
