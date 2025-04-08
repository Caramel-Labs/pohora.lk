import 'dart:convert';
import 'package:http/http.dart' as http;

class CropRecommendationParams {
  final double nitrogen; // mg/kg
  final double phosphorus; // mg/kg
  final double potassium; // mg/kg
  final double temperature; // degrees Celsius
  final double humidity; // %
  final double ph; // pH scale 0-14
  final double rainfall; // mm

  CropRecommendationParams({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });

  Map<String, dynamic> toJson() {
    return {
      'N': nitrogen,
      'P': phosphorus,
      'K': potassium,
      'temperature': temperature,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall,
    };
  }
}

class CropRecommendationResult {
  final List<int> cropIds;
  final List<double> scores;

  CropRecommendationResult({required this.cropIds, required this.scores});

  factory CropRecommendationResult.fromJson(Map<String, dynamic> json) {
    List<int> cropIds = List<int>.from(json['crop_ids']);
    List<double> scores = List<double>.from(
      json['scores'].map((score) => score.toDouble()),
    );
    return CropRecommendationResult(cropIds: cropIds, scores: scores);
  }
}

class CropRecommendationService {
  final String _baseUrl = 'http://localhost:8080/api';

  Future<CropRecommendationResult> getRecommendations(
    CropRecommendationParams params,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/crop-recommendation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params.toJson()),
      );

      if (response.statusCode == 200) {
        return CropRecommendationResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting recommendations: $e');

      // Mock result for testing when API is unavailable
      return CropRecommendationResult(
        cropIds: [1, 3, 7, 14, 11],
        scores: [0.95, 0.85, 0.78, 0.72, 0.65],
      );
    }
  }
}
