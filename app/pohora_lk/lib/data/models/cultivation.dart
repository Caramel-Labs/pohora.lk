class Cultivation {
  final int cultivationId;
  final String soilType;
  final double landArea;
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
    required this.location,
    required this.cropId,
    required this.userId,
    this.cropName,
    this.cropImagePath,
  });

  factory Cultivation.fromJson(Map<String, dynamic> json) {
    return Cultivation(
      cultivationId: json['cultivationId'] ?? 0,
      soilType: json['soilType'] ?? '',
      landArea: (json['landArea'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      cropId: json['cropId'] ?? 0,
      userId: json['userId'] ?? '',
      // These will be populated in the CropCard_Custom widget
      cropName: null,
      cropImagePath: null,
    );
  }
}
