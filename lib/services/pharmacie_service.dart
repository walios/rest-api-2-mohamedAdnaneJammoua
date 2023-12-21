import 'dart:convert';
import 'package:flutter_pharmacies_2023/models/pharmacie.dart';
import 'package:http/http.dart' as http;

class PharmacieService {
  final String baseUrl = 'http://localhost:3000/pharmacies';

 Future<List<Pharmacie>> chargerPharmacies() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final String rawJson = response.body;
      

      final List<dynamic> donnees = json.decode(rawJson);
      return donnees.map((json) => Pharmacie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pharmacies');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}


  Future<Pharmacie> creerPharmacie(Pharmacie pharmacie) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pharmacie.toJson()),
      );

      if (response.statusCode == 201) {
        
        final dynamic responseData = json.decode(response.body);
        return Pharmacie.fromJson(responseData);
      } else {
        throw Exception('Failed to create pharmacy');
      }
    } catch (e) {
      throw Exception('An error occurred during creation: $e');
    }
  }

  Future<void> supprimerPharmacie(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        
        print('Pharmacy deleted successfully');
      } else {
        throw Exception('Failed to delete pharmacy');
      }
    } catch (e) {
      throw Exception('An error occurred during deletion: $e');
    }
  }
}
