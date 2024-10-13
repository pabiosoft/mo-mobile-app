import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateDetailsScreen extends StatefulWidget {
  const MyRealEstateDetailsScreen({super.key});

  @override
  State<MyRealEstateDetailsScreen> createState() =>
      _MyRealEstateDetailsScreenState();
}

class _MyRealEstateDetailsScreenState extends State<MyRealEstateDetailsScreen> {
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
            "Details Maison X",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                      'https://images.pexels.com/photos/28873273/pexels-photo-28873273/free-photo-of-charmante-maison-de-campagne-aux-tuiles-rouges.jpeg?auto=compress&cs=tinysrgb&w=800',
                      width: double.infinity,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Maison X, Conakry Guinee",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Blabla blabla, blablalab",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("38", "ha", "Sup. Terrain"),
                  _buildInfoColumn("24", "", "Nb. de lits"),
                  _buildInfoColumn("09", "", "Nb. de chambres"),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Lorem Ipsum is simply dummy standard dummy text ever since the 1500s, scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum....",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "500.000 gnf\nnuité",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
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
          style:  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:  TextStyle(color: Colors.grey, fontSize: 10.sp,),
        ),
      ],
    );
  }
}
