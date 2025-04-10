import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/cultivation.dart';
import 'package:pohora_lk/presentation/screens/home/crop_details_screen.dart';
import 'package:pohora_lk/routes.dart';

class CropCard_Custom extends StatelessWidget {
  final Cultivation cultivation;

  const CropCard_Custom({super.key, required this.cultivation});

  @override
  Widget build(BuildContext context) {
    final cropName = cultivation.displayName;
    final cropImagePath = cultivation.displayImagePath;

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
                      '${cultivation.landArea} acres • ${cultivation.soilType}',
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
