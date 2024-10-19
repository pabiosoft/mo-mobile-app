import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/models/elements.dart';
import 'package:monimba_app/screens/profile/components/my_real_estate_crud.dart';
import 'package:monimba_app/screens/profile/components/my_real_estate_details_screen.dart';
import 'package:monimba_app/services/database/monimba_db_service.dart';
import 'package:monimba_app/shared/empty_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateScreen extends StatefulWidget {
  const MyRealEstateScreen({super.key});

  @override
  State<MyRealEstateScreen> createState() => _MyRealEstateScreenState();
}

class _MyRealEstateScreenState extends State<MyRealEstateScreen> {
  late Future<List<ElementModel>> userElements;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userElements = MonimbaDbService().fetchElementsBasedOnUserEmail();
  }

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
          "Mes biens immobiliers",
          style: TextStyle(
            color: kTertiaryColor,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration:  BoxDecoration(
      image: DecorationImage(
        image: const AssetImage(kHomePattern),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5), // Adjust the opacity for less visibility
          BlendMode.darken,
        ),
      ),
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.3), // Gradient color
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(height: 2.h,),
                // Real estates display
                Expanded(
                  child: FutureBuilder<List<ElementModel>>(
                      future: userElements,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return buildMyRealEstateShimmerEffectGridView();
                        } else if (snapshot.hasError) {
                          Logger().e('Erreur: ${snapshot.error}');
                          return Center(child: Text("Erreur: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const EmptyState(
                            text: "Vos n'avez aucun bien pour le moment",
                          );
                        } else {
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                            ),
                            itemBuilder: (context, index) {
                              final element = snapshot.data![index];
                              // Applying different margins based on index to achieve offset
                              final isOdd = index % 2 == 1;
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: isOdd ? 30.0 : 0.0,
                                  left: 16.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyRealEstateDetailsScreen(
                                                    element: element,
                                                  )));
                                    },
                                    child: PropertyCard(
                                      element: element,
                                    )),
                              );
                            },
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyRealEstateCRUD(),
            ),
          );
        },
        backgroundColor: kBtnsColor,
        label: const Icon(Icons.home),
      ),
    );
  }

  Widget buildMyRealEstateShimmerEffectGridView() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 8, // Number of shimmer items to show during loading
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final isOdd = index % 2 == 1;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmering Image placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: Colors.grey[300],
                  height: 20.h,
                  width: 35.w,
                ),
              ),
              SizedBox(height: 1.h),
              // Shimmering price text placeholder
              Container(
                color: Colors.grey[300],
                width: 15.w,
                height: 12.sp,
              ),
              SizedBox(height: 1.h),
              // Shimmering name text placeholder
              Container(
                color: Colors.grey[300],
                width: 30.w,
                height: 11.sp,
              ),
              SizedBox(height: 1.h),
              // Shimmering size text placeholder
              Container(
                color: Colors.grey[300],
                width: 35.w,
                height: 9.sp,
              ),
            ],
          ),
        );
      },
    );
  }
}

class PropertyCard extends StatelessWidget {
  final ElementModel element;

  const PropertyCard({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(2.0),
            child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
              child: Image.network(
                element.imageUrl != ''
                    ? 'https://abc.monimba.com/${element.imageUrl}'
                    : 'https://images.pexels.com/photos/28873273/pexels-photo-28873273/free-photo-of-charmante-maison-de-campagne-aux-tuiles-rouges.jpeg?auto=compress&cs=tinysrgb&w=800',
                fit: BoxFit.cover,
                height: 20.h,
                width: 35.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6.0))
            ),
          child: Column(
            children: [
              SizedBox(
                width: 50.w,
                child: Text(
                  '${NumberFormat("#,##0", "en_US").format(int.parse(element.price)).replaceAll(',', '.')} gnf',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
               SizedBox(
          width: 50.w,
          child: Text(
            element.name,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w100,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 50.w,
          child: Text(
            '${element.size} M²',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w300,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
            ],
          ),
        ),
       
      ],
    );
  }
}
