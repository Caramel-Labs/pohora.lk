import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/cultivation.dart';
import 'package:pohora_lk/presentation/screens/home/crop_details_screen.dart';
import 'package:pohora_lk/routes.dart';

class CropCard_Custom extends StatelessWidget {
  final Cultivation cultivation;

  const CropCard_Custom({super.key, required this.cultivation});

  // Helper method to get crop image path based on cropId
  String getCropImagePath(int cropId) {
    // Map cropId to the correct image
    final Map<int, String> cropImages = {
      1: 'assets/crops/rice.jpg',
      2: 'assets/crops/maize.jpg',
      3: 'assets/crops/chickpea.jpg',
      4: 'assets/crops/kidneybeans.jpg',
      5: 'assets/crops/pigeonbeans.jpg',
      6: 'assets/crops/mothbeans.jpg',
      7: 'assets/crops/mungbeans.jpg',
      8: 'assets/crops/blackgram.jpg',
      9: 'assets/crops/lentil.jpg',
      10: 'assets/crops/pomegranate.jpg',
      11: 'assets/crops/banana.jpeg',
      12: 'assets/crops/mango.jpg',
      13: 'assets/crops/grapes.jpg',
      14: 'assets/crops/watermelon.jpg',
      15: 'assets/crops/muskmelon.jpg',
      16: 'assets/crops/apple.jpeg',
      17: 'assets/crops/orange.jpeg',
      18: 'assets/crops/papaya.jpg',
      19: 'assets/crops/coconut.jpeg',
      21: 'assets/crops/jute.jpg',
      22: 'assets/crops/coffee.jpg',
    };

    return cropImages[cropId] ?? 'assets/crops/default_crop.png';
  }

  // Helper method to get crop name based on cropId
  String getCropName(int cropId) {
    final Map<int, String> cropNames = {
      1: 'Rice',
      2: 'Maize',
      3: 'Chickpea',
      4: 'Kidney Beans',
      5: 'Pigeon Beans',
      6: 'Moth Beans',
      7: 'Mung Beans',
      8: 'Black Gram',
      9: 'Lentil',
      10: 'Pomegranate',
      11: 'Banana',
      12: 'Mango',
      13: 'Grapes',
      14: 'Watermelon',
      15: 'Muskmelon',
      16: 'Apple',
      17: 'Orange',
      18: 'Papaya',
      19: 'Coconut',
      20: 'Cotton',
      21: 'Jute',
      22: 'Coffee',
    };

    return cropNames[cropId] ?? 'Unknown Crop';
  }

  @override
  Widget build(BuildContext context) {
    final cropName = cultivation.cropName ?? getCropName(cultivation.cropId);
    final cropImagePath =
        cultivation.cropImagePath ?? getCropImagePath(cultivation.cropId);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CropDetailsScreen(
                    cropId: cultivation.cropId,
                    cultivationId: cultivation.cultivationId,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Crop image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cropImagePath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 16),

              // Crop details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cultivation.location,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cultivation.landArea} acres • ${cultivation.soilType} soil',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
