import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pohora_lk/data/models/fertilizer_log.dart';
import 'package:pohora_lk/data/models/crop_data.dart';

class FertilizerRecommendationParams {
  final int cropId; // Crop ID from your local CropData
  final String cropName; // Added for API compatibility
  final double temperature; // degrees Celsius
  final double moisture; // % (renamed from soilMoisture to match API)
  final double rainfall; // mm (renamed from precipitation to match API)
  final double ph; // pH scale 0-14
  final double nitrogen; // mg/kg
  final double phosphorous; // mg/kg (renamed to match API spelling)
  final double potassium; // mg/kg
  final double carbon; // % (renamed from organicCarbon to match API)
  final String soil; // soil type (renamed from soilType to match API)

  FertilizerRecommendationParams({
    required this.cropId,
    required this.temperature,
    required this.moisture,
    required this.rainfall,
    required this.ph,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
    required this.carbon,
    required this.soil,
  }) : cropName = CropData.getById(cropId)?.name ?? "Unknown";

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'moisture': moisture,
      'rainfall': rainfall,
      'ph': ph,
      'nitrogen': nitrogen,
      'phosphorous': phosphorous,
      'potassium': potassium,
      'carbon': carbon,
      'soil': soil,
      'crop': cropName,
    };
  }
}

class FertilizerChoice {
  final String name;
  final double confidence;

  FertilizerChoice({required this.name, required this.confidence});
}

class FertilizerRecommendationResult {
  final String topFertilizer;
  final List<FertilizerChoice> topChoices;
  final double predictedConfidence;
  final double executionTime;

  FertilizerRecommendationResult({
    required this.topFertilizer,
    required this.topChoices,
    required this.predictedConfidence,
    required this.executionTime,
  });

  // Helper method to get fertilizer ID from name
  int getFertilizerId() {
    // Map fertilizer names to ID numbers
    final Map<String, int> fertilizerNameToId = {
      'Urea': 1,
      'DAP': 2,
      'NPK': 3,
      'Potash': 4,
      'Ammonium Sulphate': 5,
      'Water Retaining Fertilizer': 6,
      'Compost': 7,
      'Organic Fertilizer': 8,
      'Balanced Fertilizer': 9,
      'Micronutrients': 10,
    };

    return fertilizerNameToId[topFertilizer] ??
        1; // Default to Urea (1) if not found
  }

  double getMatchPercentage() {
    return predictedConfidence * 100;
  }

  factory FertilizerRecommendationResult.fromJson(Map<String, dynamic> json) {
    final String topFertilizer = json['fertilizer'] as String;
    final confidenceData = json['confidence'] as Map<String, dynamic>;
    final List<dynamic> topChoicesJson =
        confidenceData['top_choices'] as List<dynamic>;
    final double predictedConfidence =
        confidenceData['predicted_confidence'] as double;
    final double executionTime = json['execution_time'] as double;

    final List<FertilizerChoice> topChoices =
        topChoicesJson.map((choice) {
          return FertilizerChoice(
            name: choice['fertilizer'] as String,
            confidence: choice['confidence'] as double,
          );
        }).toList();

    return FertilizerRecommendationResult(
      topFertilizer: topFertilizer,
      topChoices: topChoices,
      predictedConfidence: predictedConfidence,
      executionTime: executionTime,
    );
  }
}

class FertilizerService {
  final String _baseUrl = 'https://pohora-intelligence.koyeb.app';
  final String _apiUrl = 'http://13.53.91.220:5000/api';
  final now = DateTime.now();

  // Get fertilizer logs for a cultivation
  Future<List<FertilizerLog>> getFertilizerLogs(int cultivationId) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/fertilizerLogs/$cultivationId'),
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
      // Return empty list for testing
      return getDummyFertilizerLogs(cultivationId);
    }
  }

  List<FertilizerLog> getDummyFertilizerLogs(int cultivationId) {
    final now = DateTime.now();

    return [
      FertilizerLog(
        id: 1,
        cultivationId: cultivationId,
        fertilizerId: 1,
        fertilizerName: 'Urea',
        timestamp: now.subtract(const Duration(days: 45)),
      ),
      FertilizerLog(
        id: 2,
        cultivationId: cultivationId,
        fertilizerId: 3,
        fertilizerName: 'NPK',
        timestamp: now.subtract(const Duration(days: 30)),
      ),
      FertilizerLog(
        id: 3,
        cultivationId: cultivationId,
        fertilizerId: 8,
        fertilizerName: 'Organic Fertilizer',
        timestamp: now.subtract(const Duration(days: 15)),
      ),
      FertilizerLog(
        id: 4,
        cultivationId: cultivationId,
        fertilizerId: 5,
        fertilizerName: 'Ammonium Sulphate',
        timestamp: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Add a new fertilizer log
  Future<bool> addFertilizerLog(
    int cultivationId,
    int fertilizerId,
    String fertilizerName,
  ) async {
    try {
      final formattedTimestamp =
          '${DateTime.now().toUtc().toIso8601String().split('.').first}Z';

      final Map<String, dynamic> logData = {
        "timestamp": formattedTimestamp,
        "cultivationId": cultivationId,
        "fertilizerId": fertilizerId,
        "fertilizerName": fertilizerName,
      };

      print('Sending fertilizer log data: $logData');

      final response = await http.post(
        Uri.parse('http://13.53.91.220:5000/api/fertilizerLogs'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(logData),
      );

      if (cultivationId <= 0) {
        print('Error: Invalid cultivation ID: $cultivationId');
        return false;
      }

      print('Fertilizer log response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully added fertilizer log');
        return true;
      } else {
        print('Failed to add fertilizer log: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding fertilizer log: $e');
      return false;
    }
  }

  // Get fertilizer recommendation
  Future<FertilizerRecommendationResult> getFertilizerRecommendation(
    FertilizerRecommendationParams params,
  ) async {
    try {
      print(
        'Sending fertilizer recommendation request: ${jsonEncode(params.toJson())}',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/recommendation/fertilizer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params.toJson()),
      );

      print(
        'Fertilizer recommendation response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Fertilizer recommendation response: $jsonResponse');
        return FertilizerRecommendationResult.fromJson(jsonResponse);
      } else {
        print('Error response body: ${response.body}');
        throw Exception('Failed to get recommendation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting fertilizer recommendation: $e');

      // Mock result for testing when API is unavailable
      return FertilizerRecommendationResult(
        topFertilizer: 'Urea',
        topChoices: [
          FertilizerChoice(name: 'Urea', confidence: 0.75),
          FertilizerChoice(name: 'DAP', confidence: 0.15),
          FertilizerChoice(name: 'Compost', confidence: 0.10),
        ],
        predictedConfidence: 0.75,
        executionTime: 0.003,
      );
    }
  }
}
