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

class CropChoice {
  final String cropName;
  final double confidence;

  CropChoice({required this.cropName, required this.confidence});
}

class CropRecommendationResult {
  final String topCrop;
  final List<CropChoice> topChoices;
  final double predictedConfidence;
  final double executionTime;

  CropRecommendationResult({
    required this.topCrop,
    required this.topChoices,
    required this.predictedConfidence,
    required this.executionTime,
  });

  // Helper method to get crop IDs from crop names using CropData
  List<int> get cropIds {
    final List<int> ids = [];
    final Map<String, int> cropNameToId = {
      'rice': 1,
      'maize': 2,
      'chickpea': 3,
      'kidneybeans': 4,
      'pigeonpeas': 5,
      'mothbeans': 6,
      'mungbean': 7,
      'blackgram': 8,
      'lentil': 9,
      'pomegranate': 10,
      'banana': 11,
      'mango': 12,
      'grapes': 13,
      'watermelon': 14,
      'muskmelon': 15,
      'apple': 16,
      'orange': 17,
      'papaya': 18,
      'coconut': 19,
      'cotton': 20,
      'jute': 21,
      'coffee': 22,
    };

    for (var choice in topChoices) {
      final id = cropNameToId[choice.cropName.toLowerCase()];
      if (id != null) {
        ids.add(id);
      }
    }
    return ids;
  }

  // Helper method to get confidence scores for each crop
  List<double> get scores {
    return topChoices.map((choice) => choice.confidence).toList();
  }

  factory CropRecommendationResult.fromJson(Map<String, dynamic> json) {
    final String topCrop = json['crop'] as String;
    final confidenceData = json['confidence'] as Map<String, dynamic>;
    final List<dynamic> topChoicesJson =
        confidenceData['top_choices'] as List<dynamic>;
    final double predictedConfidence =
        confidenceData['predicted_confidence'] as double;
    final double executionTime = json['execution_time'] as double;

    final List<CropChoice> topChoices =
        topChoicesJson.map((choice) {
          return CropChoice(
            cropName: choice['crop'] as String,
            confidence: choice['confidence'] as double,
          );
        }).toList();

    return CropRecommendationResult(
      topCrop: topCrop,
      topChoices: topChoices,
      predictedConfidence: predictedConfidence,
      executionTime: executionTime,
    );
  }
}

class CropRecommendationService {
  final String _baseUrl = 'https://pohora-intelligence.koyeb.app';

  Future<CropRecommendationResult> getRecommendations(
    CropRecommendationParams params,
  ) async {
    try {
      print(
        'Sending crop recommendation request: ${jsonEncode(params.toJson())}',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/recommendation/crop'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params.toJson()),
      );

      print('Crop recommendation response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Crop recommendation response: $jsonResponse');
        return CropRecommendationResult.fromJson(jsonResponse);
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
          'Failed to get recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting crop recommendations: $e');

      // Mock result for testing when API is unavailable
      return CropRecommendationResult(
        topCrop: 'kidneybeans',
        topChoices: [
          CropChoice(cropName: 'kidneybeans', confidence: 0.45),
          CropChoice(cropName: 'muskmelon', confidence: 0.35),
          CropChoice(cropName: 'orange', confidence: 0.1),
        ],
        predictedConfidence: 0.45,
        executionTime: 0.019,
      );
    }
  }
}
