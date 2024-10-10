import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/models/category.dart';
import 'package:monimba_app/models/elements.dart';
import 'package:monimba_app/screens/main/components/element_details.dart';
import 'package:monimba_app/services/database/monimba_db_service.dart';
import 'package:sizer/sizer.dart';

class MainScreenBody extends StatefulWidget {
  const MainScreenBody({super.key});

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  TextEditingController _searchControler = TextEditingController();

  late Future<List<ElementModel>> futureElements;

  @override
  void initState() {
    super.initState();
    MonimbaDbService().loginUser('dev2@mo.com', 'dev2');
    futureElements = MonimbaDbService().fetchElements();
  }

  final List<CategoryModel> categories = [
    CategoryModel(name: 'ApartEments', iconPath: 'assets/icons/apartment.svg'),
    CategoryModel(name: 'Maisons', iconPath: 'assets/icons/house.svg'),
    CategoryModel(name: 'Bureaux', iconPath: 'assets/icons/office.svg'),
    // CategoryModel(name: 'Villas', iconPath: 'assets/icons/villa.svg'),
    CategoryModel(name: 'Boutiques', iconPath: 'assets/icons/shop.svg'),
    CategoryModel(name: 'Terrains', iconPath: 'assets/icons/land.svg'),
  ];

  // final List<RealEstateCard> realEstateCards = [
  //   const RealEstateCard(
  //     imageUrl:
  //         'https://media.istockphoto.com/id/1165384568/fr/photo/complexe-moderne-européen-de-bâtiments-résidentiels.jpg?b=1&s=612x612&w=0&k=20&c=52wNRu6fSrCmbL7zFrduPNj5XwyiyZGWnnZVOJAg1qc=',
  //     houseName: 'Appartement Moderne sis a Kobaya Marche',
  //     rating: 4.5,
  //     distance: 2.3,
  //     availableDate: 'Jan 2024',
  //   ),
  //   const RealEstateCard(
  //     imageUrl:
  //         'https://media.istockphoto.com/id/488120139/fr/photo/moderne-real-estate.jpg?b=1&s=612x612&w=0&k=20&c=Vgdp8Xvxopxyu74SdzSdog09iI5YzGkjG4wHhtqrWo0=',
  //     houseName: 'Villa sis a Kaloum Centre Ville',
  //     rating: 4.8,
  //     distance: 1.1,
  //     availableDate: 'Fev 2024',
  //   ),
  //   // Add more cards...
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kbackGreyColor,
        // appBar: mainTopBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.1.h,
              ),
              // search bar
              SearchBarFilters(searchControler: _searchControler),
              // Categories scrollview with icons
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: RealEstateCategories(),
              ),
              // Element card
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: 63.h,
                  child:
                      // ListView.builder(
                      //   physics: const BouncingScrollPhysics(),
                      //   itemCount: realEstateCards.length,
                      //   itemBuilder: (context, index) {
                      //     return Padding(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 1.h, horizontal: 4.w),
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => const ElementDetails(),
                      //             ),
                      //           );
                      //         },
                      //         child: realEstateCards[index],
                      //       ),
                      //     );
                      //   },
                      // ),
                      FutureBuilder<List<ElementModel>>(
                    future: futureElements,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        Logger().e('Erreur: ${snapshot.error}');
                        return Center(child: Text("Erreur: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("Aucun élément disponible"));
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final element = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ElementDetails(
                                      element: element,
                                    ),
                                  ),
                                );
                              },
                              child: RealEstateCard(
                                imageUrl: element.imageUrl.isNotEmpty
                                    ? element.imageUrl
                                    : 'https://images.pexels.com/photos/6970049/pexels-photo-6970049.jpeg?auto=compress&cs=tinysrgb&w=800',
                                houseName: element.name,
                                location: element.locate,
                                price: element.price,
                                availableDate: element.createdDate,
                                city: element.city,
                                rating: 2,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              // Text(
              //   "MONIMBA PROJECT",
              //   style: TextStyle(fontSize: 21.sp, color: kPrimaryColor),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize mainTopBar() {
    return PreferredSize(
      // preferredSize: const Size.fromHeight(75),
      preferredSize: SizerUtil.deviceType == DeviceType.mobile
          ? Size.fromHeight(9.h)
          : Size.fromHeight(9.h),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 0.0,
          top: SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 0.0,
        ),
        child: // Main MONIMBA - Top Header
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // MONIMBA LOGO
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: kbackGreyColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  kLogoMoNimbaPath,
                  width: 12.w,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Votre position",
                          style: TextStyle(
                            color: kSecondaryBlackColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              kPinLocationSvg,
                              color: kBtnsColor,
                              width: 5.w,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              "Conakry Guinée",
                              style: TextStyle(
                                color: kSecondaryBlackColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Notification Icon

              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: kbackGreyColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const NotificationIconWithBadge(notificationCount: 5))
            ]),
      ),
    );
  }
}

class RealEstateCard extends StatelessWidget {
  final String imageUrl;
  final String houseName;
  final double rating;
  final String city;
  final DateTime availableDate;
  final String location;
  final String price;

  const RealEstateCard({
    super.key,
    required this.imageUrl,
    required this.houseName,
    required this.rating,
    required this.city,
    required this.availableDate,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Heart Icon Overlay
          Stack(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(12)),
                child: Image.network(
                  "https://abc.monimba.com/$imageUrl",
                  height: 20.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Heart Icon (Favorite)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          // House Name
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Text(
              houseName,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: kTertiaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 1.h),

          // Footer: Rating, Distance, and Calendar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating
                Row(
                  children: [
                    Icon(Icons.money, color: Colors.green, size: 14.sp),
                    SizedBox(width: 1.w),
                    SizedBox(
                      width: 20.w,
                      child: Text(
                        "$price gnf",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Distance
                Row(
                  children: [
                    Icon(Icons.location_on, color: kTertiaryColor, size: 14.sp),
                    SizedBox(width: 1.w),
                    SizedBox(
                      width: 20.w,
                      child: Text(
                        city,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Calendar
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey, size: 14.sp),
                    SizedBox(width: 1.w),
                    Text(
                      "${availableDate.day.toString()}/${availableDate.month.toString()}/${availableDate.year.toString()}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RealEstateCategories extends StatelessWidget {
  final List<CategoryModel> categories = [
    CategoryModel(name: 'Apartements', iconPath: 'assets/icons/appartment.svg'),
    CategoryModel(name: 'Maisons', iconPath: 'assets/icons/house.svg'),
    CategoryModel(name: 'Bureaux', iconPath: 'assets/icons/office.svg'),
    CategoryModel(name: 'Boutiques', iconPath: 'assets/icons/shop.svg'),
    CategoryModel(name: 'Terrains', iconPath: 'assets/icons/land.svg'),
  ];

  RealEstateCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.h, // Adjust height of the category section
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: kbackGreyColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Category icon (using SvgPicture for SVG icons)
                  SvgPicture.asset(
                    category.iconPath,
                    width: 5.w, // Icon size
                    height: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  // Category label
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationIconWithBadge extends StatelessWidget {
  final int notificationCount; // pass the number of notifications

  const NotificationIconWithBadge({super.key, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // allows the badge to overflow the icon bounds
      children: [
        // The SvgPicture icon
        SvgPicture.asset(
          kNotificationIconPath,
          width: 8.w, // Adjust size as needed
        ),
        // The badge positioned at the top right of the icon
        if (notificationCount > 0)
          Positioned(
            right: -2, // Adjust position (left/right and top/bottom)
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4), // Adjust padding
              decoration: const BoxDecoration(
                color: kBtnsColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18, // Badge minimum width
                minHeight: 18, // Badge minimum height
              ),
              child: Center(
                child: Text(
                  notificationCount.toString(),
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 10.sp, // Text size (use sp if using Sizer)
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SearchBarFilters extends StatelessWidget {
  const SearchBarFilters({
    super.key,
    required TextEditingController searchControler,
  }) : _searchControler = searchControler;

  final TextEditingController _searchControler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 6.5.h,
          width: SizerUtil.deviceType == DeviceType.mobile ? 75.w : 82.w,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 0.5,
              color: kSecondaryBlackColor.withOpacity(0.5),
            ),
          ),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
              controller: _searchControler,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontSize: SizerUtil.deviceType == DeviceType.mobile
                    ? 10.sp
                    : 12.sp, // Adjust the font size here
              ),
              onChanged: (value) {},
              onSubmitted: (value) async {},
              cursorColor: kTertiaryColor,
              cursorWidth: SizerUtil.deviceType == DeviceType.mobile ? 1.5 : 3,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: kTertiaryColor,
                  size: SizerUtil.deviceType == DeviceType.mobile ? 45 : 45,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical:
                      SizerUtil.deviceType == DeviceType.mobile ? 20.0 : 18,
                ),
                hintText: "Recherchez un appartement, villa, etc...",
                hintStyle: TextStyle(
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 9.sp
                        : 12.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Trigger the bottom modal sheet when the button is clicked
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return const FilterBottomSheet();
              },
            );
          },
          child: Container(
            width: SizerUtil.deviceType == DeviceType.mobile ? 14.w : 12.w,
            height: 6.5.h,
            padding: EdgeInsets.all(2.sp),
            decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(100),
                color: kPrimaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: kSecondaryBlackColor,
                    spreadRadius: .5,
                    blurRadius: .2,
                    // offset: Offset(.2, .2),
                  ),
                ]),
            child: SvgPicture.asset(
              kFilterSettingSvg,
              color: kTertiaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // State variable to hold the current slider values
  RangeValues _currentRangeValues = const RangeValues(500, 1500);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      height: 90.h, // Set the height to 90% of the screen height
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // Wrap the Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Sheet Handle
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // Property Type Section
            Text(
              "Type de propriété",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPropertyTypeButton("Villa", Icons.villa),
                _buildPropertyTypeButton("Hotels", Icons.hotel),
                _buildPropertyTypeButton("Appartements", Icons.apartment),
                _buildPropertyTypeButton("Maison", Icons.house),
              ],
            ),
            SizedBox(height: 3.h),

            // Price Range Section
            Text(
              "Mon bugdet",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              height: 20.h,
              width: double.infinity,
              // color: Colors.grey[300], // Placeholder for price range graph
              alignment: Alignment.center,
              child: Image.network(
                  "https://images.pexels.com/photos/7045862/pexels-photo-7045862.jpeg?auto=compress&cs=tinysrgb&w=800"),
            ),
            SizedBox(height: 2.h),

            // Slider
            // Range Slider with dynamic value update
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 2.sp,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.sp),
              ),
              child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 300000,
                divisions: 30,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues newRange) {
                  setState(() {
                    _currentRangeValues = newRange; // Update slider values
                  });
                },
                activeColor: kBtnsColor, // Use your custom color if needed
                inactiveColor: Colors.grey[300],
              ),
            ),
            SizedBox(height: 3.h),

            // Bedrooms Section
            Text(
              "Chambres",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            NumberSelectionRow(
              options: const ['1', '2', '3', '4', '5', 'Tous'],
              onSelected: (selectedValue) {
                print(
                    'Selected value: $selectedValue'); // This will log the selected value when an option is tapped
              },
            ),

            SizedBox(height: 3.h),

            // Beds Section
            Text(
              "Lits",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            NumberSelectionRow(
              options: const ['1', '2', '3', '4', '5', 'Tous'],
              onSelected: (selectedValue) {
                print(
                    'Selected value: $selectedValue'); // This will log the selected value when an option is tapped
              },
            ),

            SizedBox(height: 3.h),

            // Amenities Section
            Text(
              "Commodités",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            const AmenitiesSelectionList(
              amenities: ['Cuisine', 'Clim', 'Piscine', 'Gym'],
            ),

            // Save Filter Button
            SizedBox(height: 5.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet on save
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: kBtnsColor,
                ),
                child: Text(
                  "Appliquer Filtre",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  // Helper widget for property type buttons
  Widget _buildPropertyTypeButton(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kBtnsColor, size: 22.sp),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper widget for number selection rows (Bedrooms, Beds)

  // // Helper widget for amenities list
  // Widget _buildAmenitiesList(List<String> amenities) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: amenities.map((amenity) {
  //       return CheckboxListTile(
  //         value: true,
  //         onChanged: (bool? value) {},
  //         title: Text(amenity),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         activeColor: kBtnsColor,
  //       );
  //     }).toList(),
  //   );
  // }
}

class AmenitiesSelectionList extends StatefulWidget {
  final List<String> amenities;

  const AmenitiesSelectionList({
    Key? key,
    required this.amenities,
  }) : super(key: key);

  @override
  _AmenitiesSelectionListState createState() => _AmenitiesSelectionListState();
}

class _AmenitiesSelectionListState extends State<AmenitiesSelectionList> {
  final Map<String, bool> _selectedAmenities = {};

  @override
  void initState() {
    super.initState();
    // Initialize all amenities as unchecked (false)
    for (var amenity in widget.amenities) {
      _selectedAmenities[amenity] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        children: widget.amenities.map((amenity) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: FilterChip(
              label: Text(
                amenity,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: _selectedAmenities[amenity]!
                      ? Colors.white
                      : kTertiaryColor,
                ),
              ),
              selected: _selectedAmenities[amenity]!,
              onSelected: (bool selected) {
                setState(() {
                  _selectedAmenities[amenity] = selected;
                });
              },
              selectedColor: kBtnsColor, // Color when selected
              backgroundColor: Colors.grey[200], // Color when not selected
              checkmarkColor: Colors.white, // Checkmark color
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NumberSelectionRow extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected; // Callback for the selected value

  const NumberSelectionRow({
    Key? key,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  _NumberSelectionRowState createState() => _NumberSelectionRowState();
}

class _NumberSelectionRowState extends State<NumberSelectionRow> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 2.h,
      children: widget.options.map((option) {
        final isSelected = _selectedOption == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedOption = option; // Update selected option
            });
            widget.onSelected(option); // Pass selected option to callback
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? kTertiaryColor
                  : Colors.transparent, // Highlight selected option
              border: Border.all(color: kBtnsColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected
                    ? Colors.white
                    : kTertiaryColor, // Change text color based on selection
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
