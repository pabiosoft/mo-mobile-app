import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateCRUD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBtnsColor,
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
            "Création d'un bien",
            style: TextStyle(
              color: kPrimaryColor,
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
                )))
          ],
        ),
        body: PropertyForm(),
      ),
    );
  }
}

class PropertyForm extends StatefulWidget {
  @override
  _PropertyFormState createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  // Form State Handlers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form fields
  bool _isForSale = true;

  String? _selectedRegion;
  String? _selectedCity;
  String? _selectedType;
  final List<String> _regions = [
    "Conakry",
    "Kindia",
    "Boké",
    "Mamou",
    "Labé",
    "Faranah",
    "Kankan",
    "Nzérékoré"
  ];
  List<String> _cities = [];
  final Map<String, List<String>> _regionCityMap = {
    "Conakry": ["Conakry", "Dixinn", "Matoto"],
    "Kindia": ["Kindia", "Fria", "Telimele"],
    "Boké": ["Boké", "Kamsar", "Gaoual"],
    "Mamou": ["Mamou", "Pita", "Dalaba"],
    "Labé": ["Labé", "Mali", "Tougué"],
    "Faranah": ["Faranah", "Dabola", "Kissidougou"],
    "Kankan": ["Kankan", "Kouroussa", "Siguiri"],
    "Nzérékoré": ["Nzérékoré", "Beyla", "Yomou"],
  };
  final List<String> _typeOfImmo = ["Type 1", "Type 2", "Type 3"];

  final TextEditingController _roomsController = TextEditingController();
  int _numberOfRooms = 0;

  List<TextEditingController> _bedRoomControllers = [];
  List<int> bedCount = [];
  // int bedCount = 0;
  List<Map<String, dynamic>> _selectedBeds = [];

  void _updateRooms(String value) {
    setState(() {
      _numberOfRooms = int.tryParse(value) ?? 0;

      // Update the bed room controllers list based on the number of rooms
      _bedRoomControllers = List.generate(
        _numberOfRooms,
        (index) => TextEditingController(),
      );

      // Initialize or trim bedCount list
      bedCount = List.filled(_numberOfRooms, 0);
      // Initialize _selectedBeds to match the number of rooms
      _selectedBeds = List.generate(
          _numberOfRooms,
          (index) => {
                "@id": "",
                "@type": "Item",
                "space": "",
                "type": "Meuble",
                "isActif": true,
              });
    });
  }

  List<Map<String, dynamic>> bedItems = [
    {
      "@id": "/api/items/0192685f5f107a70bfb5fa2e1ba0e010",
      "@type": "Item",
      "space": "Lit double",
      "type": "Meuble",
      "isActif": true,
    },
    {
      "@id": "/api/items/0192685f5f107a70bfb5fa2e1ba0e011",
      "@type": "Item",
      "space": "Lit simple",
      "type": "Meuble",
      "isActif": true,
    },
    {
      "@id": "/api/items/0192685f5f107a70bfb5fa2e1ba0e012",
      "@type": "Item",
      "space": "Lit superposé",
      "type": "Meuble",
      "isActif": true,
    },
    {
      "@id": "/api/items/0192685f5f107a70bfb5fa2e1ba0e013",
      "@type": "Item",
      "space": "Lit queen-size",
      "type": "Meuble",
      "isActif": true,
    },
    {
      "@id": "/api/items/0192685f5f107a70bfb5fa2e1ba0e014",
      "@type": "Item",
      "space": "Lit king-size",
      "type": "Meuble",
      "isActif": true,
    },
    // Add more items as needed
  ];

  @override
  void dispose() {
    _roomsController.dispose();
    // Dispose all the bed room controllers
    for (var controller in _bedRoomControllers) {
      controller.dispose();
    }
    _nameController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(kHomePattern),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black
                .withOpacity(0.5), // Adjust the opacity for less visibility
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Property Details & Location Details
                  _buildPropertyDetails(),
                  // Step 2: Additional Info
                  _buildAdditionalInfo(),
                  // Step 3: Upload Images
                  _buildUploadImages(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails du Bien',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 2.h),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      _isForSale ? 'Vente' : 'Location',
      style: TextStyle(fontSize: 16.sp, color: kTitleColor, fontWeight: FontWeight.bold),
    ),
    Switch(
      value: _isForSale,
      onChanged: (bool value) {
        setState(() {
          _isForSale = value;
        });
      },
      activeColor: kTertiaryColor,
    ),
  ],
),
SizedBox(height: 2.h),

            _buildTextField(
              'Nom du bien',
              controller: _nameController,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              'Prix',
              keyboardType: TextInputType.number,
              controller: _priceController,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              'Taille en M²',
              keyboardType: TextInputType.number,
              controller: _sizeController,
            ),
            SizedBox(height: 2.h),
            Text(
              'Localisation du Bien',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 2.h),
            _buildDropdownField(
              hint: "Sélectionnez une région",
              items: _regions,
              onChanged: (selectedRegion) {
                setState(() {
                  _selectedRegion = selectedRegion;
                  _cities = _regionCityMap[selectedRegion!]!;
                  _selectedCity = null; // Reset city when region changes
                });
              },
              value: _selectedRegion,
            ),
            SizedBox(height: 2.h),
            _buildDropdownField(
              hint: "Sélectionnez une ville",
              items: _cities,
              onChanged: (selectedCity) {
                setState(() {
                  _selectedCity = selectedCity;
                });
              },
              value: _selectedCity,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations Supplémentaires',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: kTitleColor,
                ),
              ),
              SizedBox(height: 2.h),
              _buildDropdownField(
                hint: "Sélectionnez le type de bien",
                items: _typeOfImmo,
                onChanged: (selectedType) {
                  setState(() {
                    _selectedType = selectedType;
                  });
                },
                value: _selectedType,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: kTertiaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: kTertiaryColor,
                        width: 2), // Focused border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: kTertiaryColor.withOpacity(0.5), width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _roomsController,
                decoration: InputDecoration(
                  labelText: 'Nombre de pièces ou chambre',
                  labelStyle: const TextStyle(color: kTertiaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: kTertiaryColor,
                        width: 2), // Focused border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: kTertiaryColor.withOpacity(0.5), width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: _updateRooms,
              ),
              SizedBox(height: 2.h),
              // Dynamic display additional text fields or select based of the number romm
              for (int i = 0; i < _numberOfRooms; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chambre ${i + 1}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: kTitleColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: kTertiaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Surface',
                              labelStyle:
                                  const TextStyle(color: kTertiaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kTertiaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: kTertiaryColor.withOpacity(0.5),
                                    width: 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle:
                                  const TextStyle(color: kTertiaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kTertiaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: kTertiaryColor.withOpacity(0.5),
                                    width: 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Numbers of bedrooms
                          TextField(
                            controller: _bedRoomControllers[i],
                            decoration: InputDecoration(
                              labelText: 'Nombre de lits dans la chambre',
                              labelStyle:
                                  const TextStyle(color: kTertiaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kTertiaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: kTertiaryColor.withOpacity(0.5),
                                    width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              Logger().i("Value $value");
                              // setState(() {
                              //   // bedCount[i] = int.tryParse(value) ?? 0;
                              //   bedCount = int.tryParse(value) ?? 0;
                              // });

                              setState(() {
                                // Ensure the bedCount list is long enough
                                if (i >= bedCount.length) {
                                  bedCount.add(0);
                                }
                                bedCount[i] = int.tryParse(value) ??
                                    0; // Store the count of beds for the current room

                                // Ensure _selectedBeds has enough entries
                                if (_selectedBeds.length <= i) {
                                  _selectedBeds.add({});
                                }
                                // Initialize or update _selectedBeds['numberOfBeds']
                                if (_selectedBeds[i]['beds'] == null) {
                                  _selectedBeds[i]['beds'] = [];
                                }

                                _selectedBeds[i]["numberOfBeds"] =
                                    bedCount[i]; // Update _selectedBeds too
                              });
                            },
                          ),

                          const SizedBox(
                              height:
                                  8), // Space between TextField and Dropdowns

                          // Display dropdowns for selected number of beds
                          for (int j = 0; j < bedCount[i]; j++)
                            // for (int j = 0; j < bedCount; j++)
                            Column(
                              children: [
                                _buildDropdownField(
                                  hint: "Sélectionnez un meuble",
                                  items: bedItems
                                      .map((item) => item["space"] as String)
                                      .toList(),
                                  onChanged: (selectedBed) {
                                    setState(() {
                                      // Handle dropdown selection change if needed
                                      // if (selectedBed != null) {
                                      //   if (_selectedBeds.length <= i) {
                                      //     _selectedBeds.add(
                                      //         {}); // Ensure _selectedBeds has enough entries
                                      //   }
                                      //   _selectedBeds[i]['space'] =
                                      //       selectedBed; // Save selected bed type
                                      // }

                                      if (selectedBed != null) {
                                        if (_selectedBeds[i]['beds'].length <=
                                            j) {
                                          _selectedBeds[i]['beds'].add(
                                              selectedBed); // Add new bed selection
                                        } else {
                                          _selectedBeds[i]['beds'][j] =
                                              selectedBed; // Update existing bed selection
                                        }
                                      }
                                    });
                                  },
                                  value: (_selectedBeds[i]['beds'].length > j)
                                      ? _selectedBeds[i]['beds'][j]
                                      : null,
                                  // value: _selectedBeds.isNotEmpty &&
                                  //         _selectedBeds[i]['space'] != null
                                  //     ? _selectedBeds[i]['space']
                                  //     : null,
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),

              SizedBox(height: 2.h),
              ElevatedButton.icon(
                onPressed: () {
                  Map<String, dynamic> propertyDetails = {
                    'name': _nameController.text,
                    'content': _contentController.text.isNotEmpty ? _contentController.text : 'Aucune description',
                    'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : 'Aucune description',
                    'price': double.tryParse(_priceController.text) ?? 0,
                    'size': double.tryParse(_sizeController.text) ?? 0,
                    'locate': _selectedRegion,
                    'city': "$_selectedCity Guinée",
                    'createdDate': DateTime.now(),
                    'verified': 'false',
                    'desired': _isForSale ? 'Vente' : 'Location',
                    'images': [],
                    'pieces': [],
                    'elementType': {
                      "@id":
                          "/api/element_types/1ef8536b-b487-6962-ad71-050592d463df",
                      "@type": "ElementType",
                      "name": _selectedType,
                      "isActif": true
                    },
                    'user': {},
                    'category': {},
                    'isActif': false,
                  };
                  Logger().i("Property detail(s) :");
                  Logger().i(propertyDetails);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Tester'),
                style: ElevatedButton.styleFrom(
                  primary: kBtnsColor,
                  onPrimary: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadImages() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image du Bien',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 2.h),

            //  Images UPLOAD
            Center(
              child: IconButton(
                icon:
                    const Icon(Icons.add_a_photo, size: 40, color: kBtnsColor),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Veuillez charger les images du bien",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Cliquez sur l\'icône pour télécharger des photos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTertiaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: kTertiaryColor, width: 2), // Focused border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: kTertiaryColor.withOpacity(0.5), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
  }) {
    return DropdownButtonFormField<String>(
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTertiaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: kTertiaryColor, width: 2), // Focused border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: kTertiaryColor.withOpacity(0.5), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentStep > 0
                ? () {
                    setState(() {
                      _currentStep--;
                      _pageController.animateToPage(
                        _currentStep,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: ElevatedButton.styleFrom(
              primary: kBtnsColor,
              onPrimary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentStep < 3
                ? () {
                    setState(() {
                      _currentStep++;
                      _pageController.animateToPage(
                        _currentStep,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Suivant'),
            style: ElevatedButton.styleFrom(
              primary: kBtnsColor,
              onPrimary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentStep == 3 ? () {} : null,
            icon: const Icon(Icons.check),
            label: const Text('Verifié'),
            style: ElevatedButton.styleFrom(
              primary: kBtnsColor,
              onPrimary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
