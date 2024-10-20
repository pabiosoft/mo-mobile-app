import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:monimba_app/constants.dart';
import 'package:monimba_app/models/elements.dart';
import 'package:monimba_app/services/database/monimba_db_service.dart';
import 'package:sizer/sizer.dart';

class MyRealEstateCRUD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            "Création d'un bien",
            style: TextStyle(
              color: kTertiaryColor,
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
  bool _showVerifyView = false;
  final PageController _pageController = PageController();
  // Form State Handlers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _surfaceControllers = [];
  final List<TextEditingController> _descriptionControllers = [];

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
  // final List<String> _typeOfImmo = ["Type 1", "Type 2", "Type 3"];

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

      // Initialize surface and description controllers
      _surfaceControllers.clear();
      _descriptionControllers.clear();
      for (int i = 0; i < _numberOfRooms; i++) {
        _surfaceControllers.add(TextEditingController());
        _descriptionControllers.add(TextEditingController());
      }

      // Initialize or trim bedCount list
      bedCount = List.filled(_numberOfRooms, 0);
      // Initialize or update the room list based on number of rooms
      _selectedBeds = List.generate(
        _numberOfRooms,
        (index) => {
          "@id": "",
          "@type": "Piece",
          "description": "",
          "surface": "",
          "items": [],
          "isActif": true,
        },
      );
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

  List<File> _images = [];

  late Future<List<ElementTypeModel>> futureElementTypes;
  List<String> _typeOfImmo = [];

  @override
  void initState() {
    super.initState();
    fetchAndPopulateElementTypes();
  }

  Future<void> fetchAndPopulateElementTypes() async {
    try {
      List<ElementTypeModel> elementTypes =
          await MonimbaDbService().fetchElementType();

      setState(() {
        _typeOfImmo = elementTypes.map((element) => element.name).toList();
      });
    } catch (e) {
      Logger().e('Error fetching element types: $e');
    }
  }

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: !_showVerifyView
          ? Column(
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
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Récap de votre bien',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: kTitleColor,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  _buildRecapRow(
                      label: 'Type de service : ',
                      value: _isForSale ? 'En Vente' : 'En Location'),
                  SizedBox(
                    height: 1.h,
                  ),
                  _buildRecapRow(
                      label: 'Nom du bien : ', value: _nameController.text),
                  SizedBox(
                    height: 1.h,
                  ),
                  _buildRecapRow(
                      label: 'Prix : ', value: "${_priceController.text} GNF"),
                  SizedBox(
                    height: 1.h,
                  ),
                  _buildRecapRow(
                      label: 'Taille : ', value: "${_sizeController.text} M²"),
                  SizedBox(
                    height: 1.h,
                  ),
                  _buildRecapRow(
                      label: 'Région et ville : ',
                      value:
                          "${_selectedRegion.toString()}, $_selectedCity Guinée"),
                  SizedBox(
                    height: 1.h,
                  ),
                  _buildRecapRow(
                      label: 'Nb. de chambre : ', value: _roomsController.text),
                  SizedBox(
                    height: 1.h,
                  ),
                  // _buildRecapRow(label: 'Nb. de lits : ', value: bedCount.toString()),
                  // SizedBox(height: 1.h,),

                  Text(
                    'Photo(s) de votre bien',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kTertiaryColor,
                    ),
                  ),

                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: 45.h,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 5.0),
                        itemCount: _images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: kBtnsColor, width: 0.5),
                                    borderRadius: BorderRadius.circular(32)),
                                child: Image.file(
                                  _images[index],
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecapRow({required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyDetails() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails du Bien',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isForSale ? 'Vente' : 'Location',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: kTertiaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    value: _isForSale,
                    onChanged: (bool value) {
                      setState(() {
                        _isForSale = value;
                      });
                    },
                    activeColor: kTertiaryColor,
                  ),
                ),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 2.h),
            _buildTextField(
              'Nom du bien',
              controller: _nameController,
            ),
            SizedBox(height: 2.5.h),
            _buildTextField(
              'Prix',
              keyboardType: TextInputType.number,
              controller: _priceController,
            ),
            SizedBox(height: 2.5.h),
            _buildTextField(
              'Taille en M²',
              keyboardType: TextInputType.number,
              controller: _sizeController,
            ),
            SizedBox(height: 2.5.h),
            Text(
              'Localisation du Bien',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDropdownField(
              hint: "Sélectionnez une région",
              items: _regions,
              onChanged: (selectedRegion) {
                setState(() {
                  _selectedRegion = selectedRegion;
                  _cities = _regionCityMap[selectedRegion!]!;
                  _selectedCity = null;
                });
              },
              value: _selectedRegion,
            ),
            SizedBox(height: 2.5.h),
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
            SizedBox(height: 3.h),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Info. Supplémentaires',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
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
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Ajouter une description complete de votre bien',
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
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 2.h),
              TextField(
                controller: _roomsController,
                cursorColor: kTertiaryColor,
                textInputAction: TextInputAction.next,
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.deepOrange.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10, sigmaY: 10), // Blur effect
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _surfaceControllers[i],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Surface',
                                    labelStyle:
                                        const TextStyle(color: kTertiaryColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: kTertiaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kTertiaryColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                TextField(
                                  controller: _descriptionControllers[i],
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    labelStyle:
                                        const TextStyle(color: kTertiaryColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: kTertiaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kTertiaryColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                TextField(
                                  controller: _bedRoomControllers[i],
                                  decoration: InputDecoration(
                                    labelText: 'Nombre de lits dans la chambre',
                                    labelStyle:
                                        const TextStyle(color: kTertiaryColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: kTertiaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kTertiaryColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      // Ensure bedCount and _selectedBeds are correctly initialized
                                      bedCount[i] = int.tryParse(value) ?? 0;

                                      // Initialize the 'space' list in _selectedBeds if not present
                                      if (_selectedBeds[i]['space'] == null) {
                                        _selectedBeds[i]['space'] =
                                            List.filled(bedCount[i], '');
                                      } else {
                                        // Resize the 'space' list if necessary
                                        if (_selectedBeds[i]['space'].length <
                                            bedCount[i]) {
                                          _selectedBeds[i]['space'].addAll(
                                            List.filled(
                                                (bedCount[i] -
                                                        _selectedBeds[i]
                                                                ['space']
                                                            .length)
                                                    .toInt(),
                                                ''),
                                          );
                                        } else if (_selectedBeds[i]['space']
                                                .length >
                                            bedCount[i]) {
                                          _selectedBeds[i]['space'].removeRange(
                                              bedCount[i],
                                              _selectedBeds[i]['space'].length);
                                        }
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(
                                    height:
                                        8), // Space between TextField and Dropdowns

                                // Display dropdowns for each bed in the room
                                for (int j = 0; j < bedCount[i]; j++)
                                  Column(
                                    children: [
                                      _buildDropdownField(
                                        hint: "Sélectionnez un meuble",
                                        items: bedItems
                                            .map((item) =>
                                                item["space"] as String)
                                            .toList(),
                                        onChanged: (selectedBed) {
                                          setState(() {
                                            // Check if the selectedBed is not null
                                            if (selectedBed != null) {
                                              // If there are not enough items, add a new one
                                              if (_selectedBeds[i]['items']
                                                      .length <=
                                                  j) {
                                                _selectedBeds[i]['items'].add({
                                                  "@id":
                                                      "", // You can generate or assign an ID if needed
                                                  "@type": "Item",
                                                  "space": selectedBed,
                                                  "type": "Meuble",
                                                  "isActif": true,
                                                });
                                              } else {
                                                // Update the existing item's space
                                                _selectedBeds[i]['items'][j]
                                                    ['space'] = selectedBed;
                                              }
                                            }
                                          });
                                        },
                                        value: (_selectedBeds[i]['items']
                                                    .length >
                                                j)
                                            ? _selectedBeds[i]['items'][j][
                                                'space'] // Update to reflect the correct space
                                            : null,
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
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
                    'content': _contentController.text.isNotEmpty
                        ? _contentController.text
                        : 'Aucun contenu',
                    'description': _descriptionController.text.isNotEmpty
                        ? _descriptionController.text
                        : 'Aucune description',
                    'price': double.tryParse(_priceController.text) ?? 0,
                    'size': double.tryParse(_sizeController.text) ?? 0,
                    'locate': _selectedRegion,
                    'city': "$_selectedCity Guinée",
                    'createdDate': DateTime.now(),
                    'verified': 'false',
                    'desired': _isForSale ? 'Vente' : 'Location',
                    'images': [],
                    'pieces': _createPieces(),
                    'elementType': {
                      "@id":
                          "/api/element_types/1ef8536b-b487-6962-ad71-050592d463df",
                      "@type": "ElementType",
                      "name": _selectedType,
                      "isActif": true
                    },
                    // 'user': {},
                    'category': {},
                    'isActif': false,
                  };
                  Logger().i("Property detail(s) :");
                  Logger().i(propertyDetails);

                  Logger().i("Property Room(s) detail(s) :");
                  Logger().i("Nb of room : $_numberOfRooms");
                  Logger().i("Nb of bed : $bedCount");
                  Logger().i("Selected of bed :");
                  Logger().i(_selectedBeds);
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

  List<Map<String, dynamic>> _createPieces() {
    List<Map<String, dynamic>> pieces = [];

    for (int i = 0; i < _numberOfRooms; i++) {
      pieces.add({
        "@id":
            "/api/pieces/${_generateUniqueId()}", // Generate unique ID for each piece
        "@type": "Piece",
        "description": _descriptionControllers[i].text,
        "surface": _surfaceControllers[i].text,
        "items": _selectedBeds[i]['items'],
        "isActif": true,
      });
    }

    return pieces;
  }

// Helper method to generate a unique ID
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Widget _buildUploadImages() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Smooth rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Images du Bien',
              style: TextStyle(
                fontSize:
                    20.sp, // Slightly larger font size for better emphasis
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            SizedBox(height: 3.h),

            // Image Upload Button
            Center(
              child: GestureDetector(
                onTap: () {
                  _showChoiceDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kBtnsColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: kBtnsColor, width: 2), // Highlighted border
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: kBtnsColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Instruction Text (before uploading images)
            if (_images.isEmpty)
              Center(
                child: Column(
                  children: const [
                    Text(
                      "Veuillez charger les images du bien",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cliquez sur l\'icône pour télécharger des photos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 3.h),

            // Grid View for Uploaded Images
            if (_images.isNotEmpty)
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: 50.h,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 5.0,
                      childAspectRatio: 1.0, // Ensures consistent square images
                    ),
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            _removeImage(index), // Image removal handler
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: kBtnsColor,
                                width: 1), // Sharper image borders
                            borderRadius: BorderRadius.circular(
                                20), // Rounded image corners for a clean look
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                15), // Ensure image corners match container
                            child: Image.file(
                              _images[index],
                              fit: BoxFit
                                  .cover, // Ensures the image fills the space properly
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for modern look
          ),
          title: Row(
            children: [
              const Icon(Icons.image, color: kTertiaryColor),
              SizedBox(width: 1.w),
              Text(
                'Choix de l\'image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),
          content: Text(
            'Voulez-vous choisir une image depuis la galerie ou prendre une nouvelle photo ?',
            style:
                TextStyle(fontSize: 12.sp), // Adjust font size for readability
          ),
          actionsPadding: const EdgeInsets.symmetric(
              horizontal: 10), // Padding for button placement
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.photo_library, color: kBtnsColor),
              label: Text(
                'Galerie Photo',
                style: TextStyle(
                  color: kTertiaryColor,
                  fontSize: 13.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _selectImageFromGallery();
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.camera_alt, color: kBtnsColor),
              label: Text(
                'Caméra',
                style: TextStyle(
                  color: kTertiaryColor,
                  fontSize: 13.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _takeNewPhoto();
              },
            ),
            TextButton(
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectImageFromGallery() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    setState(() {
      _images.addAll(images.map((xFile) => File(xFile.path)));
    });
  }

  Future<void> _takeNewPhoto() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
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
      borderRadius: BorderRadius.circular(10.0),
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
            onPressed: _currentStep == 3
                ? () {
                    setState(() {
                      _showVerifyView = true;
                    });
                  }
                : null,
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
