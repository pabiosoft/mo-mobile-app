import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:monimba_app/models/elements.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MonimbaDbService {
// URL de l'API
  final String loginUrl = "https://abc.monimba.com/api/login";
  final String elementsUrl =
      "https://abc.monimba.com/api/elements?isActif=true";
  final String elementTypeUrl = "https://abc.monimba.com/api/element_types";

// Méthode pour se connecter et obtenir le token
  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      // Extraire le token
      final token = json.decode(response.body)['token'];
      // Extraire l'email de la personne connectee
      final email = json.decode(response.body)['user']['email'];

      // Sauvegarder le token localement
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      await prefs.setString('logInUserEmail', email);
      // print('jwtToke : $token');
      Logger().i('jwtToke : $token');
    } else {
      throw Exception("Erreur d'authentification : ${response.body}");
    }
  }

// Méthode pour récupérer les éléments
  Future<List<ElementModel>> fetchElements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception("Token non trouvé. Authentifiez-vous d'abord.");
    }

    // Check for cached data and timestamp
    String? cachedData = prefs.getString('cachedElements');
    int? lastFetchTime = prefs.getInt('lastFetchTime');

    // Get the current time in seconds
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if cached data is valid (e.g., not older than 1 hour)
    if (cachedData != null &&
        lastFetchTime != null &&
        (currentTime - lastFetchTime < 3600000)) {
      final List<dynamic> elementsJson =
          json.decode(cachedData)['hydra:member'];
      return elementsJson.map((json) => ElementModel.fromJson(json)).toList();
    }

    // API call
    final response = await http.get(
      Uri.parse(elementsUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Cache the response and update the fetch time
      await prefs.setString('cachedElements', response.body);
      await prefs.setInt('lastFetchTime', currentTime);

      final List<dynamic> elementsJson =
          json.decode(response.body)['hydra:member'];
      return elementsJson.map((json) => ElementModel.fromJson(json)).toList();
    } else {
      final errorMessage = json.decode(response.body)['message'] ??
          "Erreur de chargement des données";
      Logger().e('Erreur de chargement des données : $errorMessage');
      throw Exception("Erreur de chargement des données : $errorMessage");
    }
  }

  Future<List<ElementTypeModel>> fetchElementType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception("Token non trouvé. Authentifiez-vous d'abord.");
    }

    // Check for cached data
    final cachedData = prefs.getString('cachedElementTypes');
    int? lastFetchTime = prefs.getInt('lastFetchTime');

    // Get the current time in seconds
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if cached data is valid (e.g., not older than 1 hour)
    if (cachedData != null &&
        lastFetchTime != null &&
        (currentTime - lastFetchTime < 3600000)) {
      final List<dynamic> cachedJson = json.decode(cachedData);
      List<ElementTypeModel> cachedList =
          cachedJson.map((json) => ElementTypeModel.fromJson(json)).toList();
      return cachedList;
    }

    // If no cached data, fetch from API
    final response = await http.get(
      Uri.parse(elementTypeUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body as a list of dynamic elements
      final List<dynamic> elementsJson = json.decode(response.body);

      // Convert the list of JSON elements to a list of ElementTypeModel
      List<ElementTypeModel> elementTypeList =
          elementsJson.map((json) => ElementTypeModel.fromJson(json)).toList();

      // Add { name: "Tous", isActif: true } to the first position
      elementTypeList.insert(
        0,
        ElementTypeModel(name: "Tous", isActif: true),
      );

      // Cache the result
      await prefs.setString('cachedElementTypes', json.encode(elementTypeList));

      return elementTypeList;
    } else {
      // Error handling
      final errorMessage = json.decode(response.body)['message'] ??
          "Erreur de chargement des données";
      Logger().e('Erreur de chargement des données : $errorMessage');
      throw Exception("Erreur de chargement des données : $errorMessage");
    }
  }

  Future<List<ElementModel>> fetchElementsByCategory(
      String elementTypeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');

    // Check for cached data
    final cachedData = prefs.getString('cachedElements_$elementTypeName');
    int? lastFetchTime = prefs.getInt('lastFetchTime');
    // Get the current time in seconds
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if cached data is valid (e.g., not older than 1 hour)
    if (cachedData != null &&
        lastFetchTime != null &&
        (currentTime - lastFetchTime < 3600000)) {
      final List<dynamic> cachedJson = json.decode(cachedData);
      List<ElementModel> cachedList =
          cachedJson.map((json) => ElementModel.fromJson(json)).toList();
      return cachedList;
    }

    // If no cached data, fetch from API
    final response = await http.get(
      Uri.parse(elementsUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> elementsData = jsonData['hydra:member'];

      List<ElementModel> data =
          elementsData.map((item) => ElementModel.fromJson(item)).toList();

      // Filter results by elementType name
      List<ElementModel> filteredData = data.where((element) {
        return element.elementType.name == elementTypeName;
      }).toList();

      // Cache the filtered results only if there is data
      if (filteredData.isNotEmpty) {
        await prefs.setString('cachedElements_$elementTypeName',
            json.encode(filteredData.map((e) => e.toJson()).toList()));
      }

      return filteredData;
    } else {
      Logger()
          .e('Failed to load data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

// USER OP.

  Future<List<ElementModel>> fetchElementsBasedOnUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('logInUserEmail');
    String? token = prefs.getString('jwtToken');

    final response = await http.get(
      Uri.parse(elementsUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> elementsData =
          jsonData['hydra:member']; // Adjust according to actual structure

      List<ElementModel> data =
          elementsData.map((item) => ElementModel.fromJson(item)).toList();

      // Filter results by user email
      List<ElementModel> filteredData = data.where((element) {
        return element.user.email == userEmail;
      }).toList();

      return filteredData;
    } else {
      Logger()
          .e('Failed to load data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<int> countElementsBasedOnUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('logInUserEmail');
    String? token = prefs.getString('jwtToken');

    final response = await http.get(
      Uri.parse(elementsUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> elementsData =
          jsonData['hydra:member']; // Adjust according to actual structure

      List<ElementModel> data =
          elementsData.map((item) => ElementModel.fromJson(item)).toList();

      // Filter results by user email
      List<ElementModel> filteredData = data.where((element) {
        return element.user.email == userEmail;
      }).toList();

      // Return the count of filtered data
      return filteredData.length;
    } else {
      Logger()
          .e('Failed to load data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
