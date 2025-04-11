import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pohora_lk/data/models/cultivation.dart';

class CultivationRepository {
  final String _baseUrl = 'http://16.171.4.110:5000/api';
  final FirebaseAuth _auth;

  CultivationRepository({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  Future<List<Cultivation>> getCultivations() async {
    try {
      final userId = _auth.currentUser?.uid ?? 'anonymous';

      final response = await http.get(
        Uri.parse('$_baseUrl/cultivations/user/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Cultivation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load cultivations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cultivations: $e');
      // Return mock data for testing when API is unavailable
      return [
        // Cultivation(
        //   cultivationId: 1,
        //   soilType: 'Clay',
        //   landArea: 1.5,
        //   location: 'Colombo',
        //   cropId: 3,
        //   userId: _auth.currentUser?.uid ?? 'anonymous',
        //   cropName: 'Papaya',
        //   cropImagePath: 'assets/crops/papaya.jpg',
        // ),
        // Cultivation(
        //   cultivationId: 2,
        //   soilType: 'Loamy',
        //   landArea: 2.3,
        //   location: 'Kandy',
        //   cropId: 1,
        //   userId: _auth.currentUser?.uid ?? 'anonymous',
        //   cropName: 'Rice',
        //   cropImagePath: 'assets/crops/rice.jpg',
        // ),
        // Cultivation(
        //   cultivationId: 3,
        //   soilType: 'Sandy',
        //   landArea: 0.8,
        //   location: 'Galle',
        //   cropId: 4,
        //   userId: _auth.currentUser?.uid ?? 'anonymous',
        //   cropName: 'Maize',
        //   cropImagePath: 'assets/crops/maize.jpg',
        // ),
      ];
    }
  }

  // Add culitvation
  Future<int> addCultivation(Cultivation cultivation) async {
    try {
      final userId = _auth.currentUser?.uid ?? 'anonymous';

      // Create a map with the data to send
      final Map<String, dynamic> data = {
        'soilType': cultivation.soilType,
        'landArea': cultivation.landArea,
        'location': cultivation.location,
        'cropId': cultivation.cropId,
        'userId': userId,
      };

      print('Sending cultivation data: $data');

      final response = await http.post(
        Uri.parse('$_baseUrl/cultivations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${await _auth.currentUser?.getIdToken() ?? ''}',
        },
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse the response to get the ID of the new cultivation
        final responseBody = json.decode(response.body);
        print('Cultivation response body: $responseBody');
        return cultivation.cultivationId;
      } else {
        print(
          'Failed to add cultivation: ${response.statusCode}, ${response.body}',
        );
        // For testing purposes, return a dummy ID
        return 999;
      }
    } catch (e) {
      print('Error adding cultivation: $e');
      // For testing purposes, return a dummy ID
      return 999;
    }
  }
}
