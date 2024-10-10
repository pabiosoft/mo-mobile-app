import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:monimba_app/models/elements.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MonimbaDbService {
// URL de l'API
  final String loginUrl = "https://abc.monimba.com/api/login";
  final String elementsUrl = "https://abc.monimba.com/api/elements";

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

      // Sauvegarder le token localement
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      // print('jwtToke : $token');
      Logger().i('jwtToke : $token');
    } else {
      throw Exception("Erreur d'authentification : ${response.body}");
    }
  }

// Méthode pour récupérer les éléments
  Future<List<ElementModel>> fetchElements() async {
    // Récupérer le token sauvegardé
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception("Token non trouvé. Authentifiez-vous d'abord.");
    }

    // Appel de l'API avec le token
    final response = await http.get(
      Uri.parse(elementsUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> elementsJson =
          json.decode(response.body)['hydra:member'];
      return elementsJson.map((json) => ElementModel.fromJson(json)).toList();
    } else {
      // Gestion des erreurs API
      final errorMessage = json.decode(response.body)['message'] ??
          "Erreur de chargement des données";
      Logger().e('Erreur de chargement des données : $errorMessage');
      throw Exception("Erreur de chargement des données : $errorMessage");
    }
  }
}
