import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

late CameraPosition _kGoogleMapsAddie;

Set<Marker> _markers = {}; // Define a set to hold the markers

  @override
  void initState() {
    super.initState();
    String exactLocate = widget.element.exactLocate; // Get the string
    List<String> coordinates =
        exactLocate.split(','); // Split into latitude and longitude

    double latitude = double.parse(coordinates[0].trim());
    double longitude = double.parse(coordinates[1].trim());

    _kGoogleMapsAddie = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );

    // Add a marker for the location
  _markers.add(
    Marker(
      markerId: const MarkerId('real_estate_location'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(title: 'Adresse du bien'),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackGreyColor,
      appBar: AppBar(
        backgroundColor: kBtnsColor,
        elevation: 0,
        brightness: Brightness.light,
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          "Consulter la carte pour plus de details",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          height: 2.sp,
                        ),
                        SizedBox(
                          height: 20.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: _kGoogleMapsAddie,
                              markers: _markers, 
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
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
