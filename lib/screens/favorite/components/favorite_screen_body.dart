import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/screens/main/components/element_details.dart';
import 'package:sizer/sizer.dart';

class FavBodyScreen extends StatefulWidget {
  const FavBodyScreen({super.key});

  @override
  State<FavBodyScreen> createState() => _FavBodyScreenState();
}

class _FavBodyScreenState extends State<FavBodyScreen> {
  final List<Map<String, String>> favoriteProperties = [
    {
      'imageUrl': 'https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Villa Luxueuse',
      'location': 'Kipé, Conakry, Guinée',
      'price': '1,500,000 GNF',
    },
    {
      'imageUrl': 'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Appart. Moderne',
      'location': 'Kaloum, Conakry, Guinée',
      'price': '800,000 GNF',
    },
    {
      'imageUrl': 'https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Villa Luxueuse',
      'location': 'Kipé, Conakry, Guinée',
      'price': '1,500,000 GNF',
    },
    {
      'imageUrl': 'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Appart. Moderne',
      'location': 'Kaloum, Conakry, Guinée',
      'price': '800,000 GNF',
    },
    // Add more properties as needed...
  ];
  


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 2.w, // Spacing between columns
            mainAxisSpacing: 2.h, // Spacing between rows
            childAspectRatio: 0.75, // Ratio for card height and width
          ),
          itemCount: favoriteProperties.length,
          itemBuilder: (context, index) {
            final property = favoriteProperties[index];
            return GestureDetector(
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => const ElementDetails(element: ,),),);
              // },
              child: RealEstateFavoriteCard(
                imageUrl: property['imageUrl']!,
                name: property['name']!,
                location: property['location']!,
                price: property['price']!,
              ),
            );
          },
        ),
      );
  }
}

class RealEstateFavoriteCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String price;

  const RealEstateFavoriteCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 14.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Property Name
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Property Location
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              location,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Spacer
          const Spacer(),

          // Price and Favorite Icon
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: kBtnsColor,
                  ),
                ),
                // Favorite Icon
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}