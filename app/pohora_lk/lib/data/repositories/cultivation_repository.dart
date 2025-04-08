import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pohora_lk/data/models/cultivation.dart';

class CultivationRepository {
  final String _baseUrl = 'http://localhost:8080/api';
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
        Cultivation(
          cultivationId: 1,
          soilType: 'Clay',
          landArea: 1.5,
          location: 'Colombo',
          cropId: 3,
          userId: _auth.currentUser?.uid ?? 'anonymous',
          cropName: 'Papaya',
          cropImagePath: 'assets/crops/papaya.jpg',
        ),
        Cultivation(
          cultivationId: 2,
          soilType: 'Loamy',
          landArea: 2.3,
          location: 'Kandy',
          cropId: 1,
          userId: _auth.currentUser?.uid ?? 'anonymous',
          cropName: 'Rice',
          cropImagePath: 'assets/crops/rice.jpg',
        ),
        Cultivation(
          cultivationId: 3,
          soilType: 'Sandy',
          landArea: 0.8,
          location: 'Galle',
          cropId: 4,
          userId: _auth.currentUser?.uid ?? 'anonymous',
          cropName: 'Maize',
          cropImagePath: 'assets/crops/maize.jpg',
        ),
      ];
    }
  }
}
