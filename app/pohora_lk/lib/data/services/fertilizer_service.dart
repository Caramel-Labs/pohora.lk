import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pohora_lk/data/models/fertilizer_log.dart';

class FertilizerRecommendationParams {
  final int cropId;
  final double temperature; // degrees Celsius
  final double soilMoisture; // %
  final double precipitation; // mm
  final double ph; // pH scale 0-14
  final double nitrogen; // mg/kg
  final double phosphorus; // mg/kg
  final double potassium; // mg/kg
  final double organicCarbon; // %
  final String soilType;

  FertilizerRecommendationParams({
    required this.cropId,
    required this.temperature,
    required this.soilMoisture,
    required this.precipitation,
    required this.ph,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.organicCarbon,
    required this.soilType,
  });

  Map<String, dynamic> toJson() {
    return {
      'crop_id': cropId,
      'temperature': temperature,
      'soil_moisture': soilMoisture,
      'precipitation': precipitation,
      'ph': ph,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'organic_carbon': organicCarbon,
      'soil_type': soilType,
    };
  }
}

class FertilizerRecommendationResult {
  final int fertilizerId;
  final double matchPercentage;

  FertilizerRecommendationResult({
    required this.fertilizerId,
    required this.matchPercentage,
  });

  factory FertilizerRecommendationResult.fromJson(Map<String, dynamic> json) {
    return FertilizerRecommendationResult(
      fertilizerId: json['fertilizer_id'],
      matchPercentage: json['match_percentage'].toDouble(),
    );
  }
}

class FertilizerService {
  final String _baseUrl = 'http://localhost:8080/api';

  // Get fertilizer logs for a cultivation
  Future<List<FertilizerLog>> getFertilizerLogs(int cultivationId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/fertilizerLogs/$cultivationId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((data) => FertilizerLog.fromJson(data)).toList();
      } else {
        throw Exception(
          'Failed to load fertilizer logs: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting fertilizer logs: $e');

      // Mock data for testing
      return [
        FertilizerLog(
          id: 1,
          timestamp: DateTime.now().subtract(const Duration(days: 30)),
          cultivationId: cultivationId,
          fertilizerId: 1,
          fertilizerName: 'Balanced NPK',
        ),
        FertilizerLog(
          id: 2,
          timestamp: DateTime.now().subtract(const Duration(days: 15)),
          cultivationId: cultivationId,
          fertilizerId: 3,
          fertilizerName: 'Urea',
        ),
        FertilizerLog(
          id: 3,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          cultivationId: cultivationId,
          fertilizerId: 5,
          fertilizerName: 'Compost',
        ),
      ];
    }
  }

  // Add a new fertilizer log
  Future<bool> addFertilizerLog(
    int cultivationId,
    int fertilizerId,
    String fertilizerName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/fertilizerLogs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cultivationId': cultivationId,
          'fertilizerId': fertilizerId,
          'fertilizerName': fertilizerName,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding fertilizer log: $e');

      // Mock success for testing
      return true;
    }
  }

  // Get fertilizer recommendation
  Future<FertilizerRecommendationResult> getFertilizerRecommendation(
    FertilizerRecommendationParams params,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/fertilizer-recommendation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params.toJson()),
      );

      if (response.statusCode == 200) {
        return FertilizerRecommendationResult.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception('Failed to get recommendation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting fertilizer recommendation: $e');

      // Mock result for testing
      // Return a different fertilizer based on the crop ID
      int recommendedFertilizerId;
      switch (params.cropId % 10) {
        case 0:
        case 1:
          recommendedFertilizerId = 1; // Balanced NPK
          break;
        case 2:
        case 3:
          recommendedFertilizerId = 2; // DAP
          break;
        case 4:
        case 5:
          recommendedFertilizerId = 3; // Urea
          break;
        case 6:
        case 7:
          recommendedFertilizerId = 4; // MOP
          break;
        case 8:
        case 9:
          recommendedFertilizerId = 5; // Compost
          break;
        default:
          recommendedFertilizerId = 1;
      }

      return FertilizerRecommendationResult(
        fertilizerId: recommendedFertilizerId,
        matchPercentage:
            0.85 + (params.cropId % 15) / 100, // Vary between 85% and 99%
      );
    }
  }
}
