import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/models/elements.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateDetailsScreen extends StatefulWidget {
  final ElementModel element;

  const MyRealEstateDetailsScreen({super.key, required this.element});

  @override
  State<MyRealEstateDetailsScreen> createState() =>
      _MyRealEstateDetailsScreenState();
}

class _MyRealEstateDetailsScreenState extends State<MyRealEstateDetailsScreen> {
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
          "Details ${widget.element.name}",
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.element.imageUrl.isNotEmpty
                            ? 'https://abc.monimba.com/${widget.element.imageUrl}'
                            : 'https://images.pexels.com/photos/28873273/pexels-photo-28873273/free-photo-of-charmante-maison-de-campagne-aux-tuiles-rouges.jpeg?auto=compress&cs=tinysrgb&w=800',
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${widget.element.name}, ${widget.element.city} Guinée",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.element.content,
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(widget.element.size, "ha", "Sup. Terrain"),
                    _buildInfoColumn("X", "", "Nb. de lits"),
                    _buildInfoColumn("X", "", "Nb. de chambres"),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.element.description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            "${NumberFormat("#,##0", "en_US").format(int.parse(widget.element.price)).replaceAll(',', '.')} gnf",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            widget.element.desired == 'Location'
                                ? "prix nuité"
                                : "prix achat",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBtnsColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Editer",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String unit, String label) {
    return Column(
      children: [
        Text(
          "$value $unit",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
