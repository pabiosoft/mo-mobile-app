import 'package:flutter/material.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class RealEstateForm extends StatefulWidget {
  const RealEstateForm({super.key});

  @override
  _RealEstateFormState createState() => _RealEstateFormState();
}

class _RealEstateFormState extends State<RealEstateForm> {
  int currentStep = 0;
  List<Step> formSteps = [];
  String _selectedRegion = '';
  String _selectedCity = '';
  String _selectedType = '';

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

  Map<String, List<String>> regionCityMap = {
    "Conakry": ["Conakry", "Dixinn", "Matoto"],
    "Kindia": ["Kindia", "Fria", "Telimele"],
    "Boké": ["Boké", "Kamsar", "Gaoual"],
    "Mamou": ["Mamou", "Pita", "Dalaba"],
    "Labé": ["Labé", "Mali", "Tougué"],
    "Faranah": ["Faranah", "Dabola", "Kissidougou"],
    "Kankan": ["Kankan", "Kouroussa", "Siguiri"],
    "Nzérékoré": ["Nzérékoré", "Beyla", "Yomou"],
  };

  List<String> _cities = [];

  void _updateCityList(String selectedRegion) {
    setState(() {
      _cities = regionCityMap[selectedRegion] ?? [];
      _selectedCity = ''; // Reset selected city when the region changes
    });
  }

  final List<String> _typeOfImmo = [
    "Maison",
    "Appartement",
    "Terrain vide",
  ];

  // void regionDropDownCallBack(String? selectedRegion) {
  //   if (selectedRegion != '') {
  //     setState(() {
  //       _selectedRegion = selectedRegion!;
  //     });
  //   }
  // }

  // void cityDropDownCallBack(String? selectedCity) {
  //   if (selectedCity != '') {
  //     setState(() {
  //       _selectedCity = selectedCity!;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    formSteps = [
      // Step 1: Property Details
      Step(
        title: const Text(
          "Details du bien",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom du bien',
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              cursorColor: kBtnsColor,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Prix',
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              cursorColor: kBtnsColor,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Taille en M²',
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              cursorColor: kBtnsColor,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
          ],
        ),
        isActive: currentStep >= 0,
      ),

      // Step 2: Location Details
      Step(
        title: const Text(
          "Localisation du bien",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          children: [
            // Region Dropdown
            DropdownButtonFormField(
              items: _regions
                  .map((region) => DropdownMenuItem(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
              onChanged: (selectedRegion) {
                setState(() {
                  _selectedRegion = selectedRegion!;
                  _updateCityList(
                      selectedRegion); // Update city options based on region
                  _selectedCity = ''; // Reset city when region changes
                });
              },
              value:
                  _regions.contains(_selectedRegion) ? _selectedRegion : null,
              decoration:  InputDecoration(
                hintText: "Region",
                helperText:
                    "Selectionnez la region dans laquelle se trouve le bien",
               labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // City Dropdown
            DropdownButtonFormField(
              items: _cities
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (selectedCity) {
                setState(() {
                  _selectedCity = selectedCity!;
                });
              },
              value: _cities.contains(_selectedCity) ? _selectedCity : null,
              decoration:  InputDecoration(
                hintText: "Ville",
                helperText:
                    "Selectionnez la ville dans laquelle se trouve le bien",
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Map Prompt
            const Text(
              'Choisir la localisation du bien sur la carte',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 15),

            // Placeholder for map (replace with your map widget)
            Container(
              height: 150,
              decoration:  BoxDecoration(
              color: Colors.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: const Center(
                child: Text(
                  'Google Maps Ici',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
        isActive: currentStep >= 1,
      ),

      // Step 3: Additional Info
      Step(
        title: const Text(
          "Info. Supplementaire",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          children:  [
            // Type de bien Dropdown
             DropdownButtonFormField(
              items: _typeOfImmo
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (selectedType) {
                setState(() {
                  _selectedType = selectedType!;
                });
              },
              value:
                  _regions.contains(_selectedRegion) ? _selectedRegion : null,
              decoration:  InputDecoration(
                hintText: "Type de bien",
                helperText:
                    "Selectionnez le type de bien immobilier",
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
            
              ),
            ),
            const SizedBox(height: 10),
             TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              cursorColor: kBtnsColor,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
             TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de pièces ou chambres',
                labelStyle: const TextStyle(color: kTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: kBtnsColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBtnsColor.withOpacity(0.5), width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              cursorColor: kBtnsColor,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),
          ],
        ),
        isActive: currentStep >= 2,
      ),

      // Step 4: Upload Images
      Step(
        title: const Text(
          "Ajouter des images",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo, color: kBtnsColor, size: 30),
                  onPressed: () {
                    // Image upload functionality
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Veuillez ajouter des images du bien",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            const SizedBox(height: 15),
          ],
        ),
        isActive: currentStep >= 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.home_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: kBtnsColor,
        ),
        child: Stepper(
          steps: formSteps,
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < formSteps.length - 1) {
              setState(() {
                currentStep += 1;
              });
            } else {
              // Submit form logic here
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep -= 1;
              });
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    primary: kBtnsColor,
                  ),
                  child: const Text('Suivant',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: details.onStepCancel,
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  child: const Text('Retour'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
