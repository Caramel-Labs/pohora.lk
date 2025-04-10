import 'package:pohora_lk/data/models/crop_data.dart';

class Cultivation {
  final int cultivationId;
  final String soilType;
  final double landArea;
  final String? unit;
  final String location;
  final int cropId;
  final String userId;
  String? cropName; // Will be populated from the static map if not provided
  String?
  cropImagePath; // Will be populated from the static map if not provided

  Cultivation({
    required this.cultivationId,
    required this.soilType,
    required this.landArea,
    this.unit,
    required this.location,
    required this.cropId,
    required this.userId,
    this.cropName,
    this.cropImagePath,
  });

  factory Cultivation.fromJson(Map<String, dynamic> json) {
    final id = json['cropId'] ?? 0;
    final cropData = CropData.getById(id);

    return Cultivation(
      cultivationId: json['cultivationId'] ?? 0,
      soilType: json['soilType'] ?? '',
      landArea: (json['landArea'] ?? 0).toDouble(),
      unit: json['unit'],
      location: json['location'] ?? '',
      cropId: json['cropId'] ?? 0,
      userId: json['userId'] ?? '',
      // Get crop name and image path from CropData if available
      cropName: cropData?.name,
      cropImagePath: cropData?.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cultivationId': cultivationId,
      'soilType': soilType,
      'landArea': landArea,
      'unit': unit,
      'location': location,
      'cropId': cropId,
      'userId': userId,
    };
  }

  // Helper method to ensure crop name is available
  String get displayName {
    if (cropName != null && cropName!.isNotEmpty) {
      return cropName!;
    } else {
      final cropData = CropData.getById(cropId);
      return cropData?.name ?? 'Unknown Crop';
    }
  }

  // Helper method to ensure image path is available
  String get displayImagePath {
    if (cropImagePath != null && cropImagePath!.isNotEmpty) {
      return cropImagePath!;
    } else {
      final cropData = CropData.getById(cropId);
      return cropData?.imagePath ?? 'assets/crops/default_crop.png';
    }
  }
}
