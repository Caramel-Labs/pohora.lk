import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/crop_data.dart';
import 'package:pohora_lk/data/services/crop_recommendation_service.dart';
import 'package:pohora_lk/presentation/widgets/primary_button_custom.dart';

class SelectCropScreen extends StatelessWidget {
  final double landArea;
  final String unit;
  final String soilType;

  const SelectCropScreen({
    super.key,
    required this.landArea,
    required this.unit,
    required this.soilType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Crop')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Heading question
              const Text(
                'What crop are you planning to plant here?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Farmer image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/farmer.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 220,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 32),

              // Select best crop text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Select the best crop for your land',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our AI model will analyze your soil data and environmental factors to recommend the most suitable crop.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Button to get recommendation
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Show data input modal sheet
                    _showDataInputBottomSheet(context);
                  },
                  label: const Text('Get Crop Recommendations'),
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Text button to add manually
              TextButton.icon(
                onPressed: () {
                  // Show manual crop selection sheet
                  _showManualCropSelectionSheet(context);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Add crop manually instead'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show data input bottom sheet
  void _showDataInputBottomSheet(BuildContext context) {
    // Controllers for form fields with default values
    final nitrogenController = TextEditingController(text: '40');
    final phosphorusController = TextEditingController(text: '30');
    final potassiumController = TextEditingController(text: '35');
    final temperatureController = TextEditingController(text: '25');
    final humidityController = TextEditingController(text: '65');
    final phController = TextEditingController(text: '6.5');
    final rainfallController = TextEditingController(text: '100');

    // Unit selection state
    String temperatureUnit = '°C';
    String rainfallUnit = 'mm';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const Text(
                        'Enter Soil and Environment Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Provide accurate data for better crop recommendations',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Form fields in a scrollable container
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Nitrogen content
                              _buildInputField(
                                controller: nitrogenController,
                                label: 'Nitrogen content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '20-100',
                                helperText: 'Normal range: 20-100 mg/kg',
                              ),

                              // Phosphorus content
                              _buildInputField(
                                controller: phosphorusController,
                                label: 'Phosphorus content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '10-80',
                                helperText: 'Normal range: 10-80 mg/kg',
                              ),

                              // Potassium content
                              _buildInputField(
                                controller: potassiumController,
                                label: 'Potassium content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '15-90',
                                helperText: 'Normal range: 15-90 mg/kg',
                              ),

                              // Temperature
                              _buildInputFieldWithUnitSelector(
                                controller: temperatureController,
                                label: 'Temperature',
                                currentUnit: temperatureUnit,
                                units: const ['°C', '°F'],
                                onUnitChanged: (newUnit) {
                                  setState(() {
                                    // Convert value when unit changes
                                    if (newUnit == '°F' &&
                                        temperatureUnit == '°C') {
                                      // C to F: (C * 9/5) + 32
                                      final celsiusValue =
                                          double.tryParse(
                                            temperatureController.text,
                                          ) ??
                                          0;
                                      final fahrenheitValue =
                                          (celsiusValue * 9 / 5) + 32;
                                      temperatureController.text =
                                          fahrenheitValue.toStringAsFixed(1);
                                    } else if (newUnit == '°C' &&
                                        temperatureUnit == '°F') {
                                      // F to C: (F - 32) * 5/9
                                      final fahrenheitValue =
                                          double.tryParse(
                                            temperatureController.text,
                                          ) ??
                                          0;
                                      final celsiusValue =
                                          (fahrenheitValue - 32) * 5 / 9;
                                      temperatureController.text = celsiusValue
                                          .toStringAsFixed(1);
                                    }
                                    temperatureUnit = newUnit;
                                  });
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hint: '20-35',
                                helperText: 'Typical growing temperature',
                              ),

                              // Humidity
                              _buildInputField(
                                controller: humidityController,
                                label: 'Relative humidity',
                                suffix: '%',
                                keyboardType: TextInputType.number,
                                hint: '30-90',
                                helperText: 'Normal range: 30-90%',
                              ),

                              // pH value
                              _buildInputField(
                                controller: phController,
                                label: 'pH value',
                                suffix: 'pH',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hint: '0-14',
                                helperText: 'pH Scale: 0-14 (7 is neutral)',
                              ),

                              // Rainfall
                              _buildInputFieldWithUnitSelector(
                                controller: rainfallController,
                                label: 'Rainfall',
                                currentUnit: rainfallUnit,
                                units: const ['mm', 'inches'],
                                onUnitChanged: (newUnit) {
                                  setState(() {
                                    // Convert value when unit changes
                                    if (newUnit == 'inches' &&
                                        rainfallUnit == 'mm') {
                                      // mm to inches: mm / 25.4
                                      final mmValue =
                                          double.tryParse(
                                            rainfallController.text,
                                          ) ??
                                          0;
                                      final inchesValue = mmValue / 25.4;
                                      rainfallController.text = inchesValue
                                          .toStringAsFixed(2);
                                    } else if (newUnit == 'mm' &&
                                        rainfallUnit == 'inches') {
                                      // inches to mm: inches * 25.4
                                      final inchesValue =
                                          double.tryParse(
                                            rainfallController.text,
                                          ) ??
                                          0;
                                      final mmValue = inchesValue * 25.4;
                                      rainfallController.text = mmValue
                                          .toStringAsFixed(0);
                                    }
                                    rainfallUnit = newUnit;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                hint: '50-300',
                                helperText: 'Average rainfall amount',
                              ),

                              // Additional info about the data
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hoverColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Not sure about your soil values? Consider getting a soil test kit or consulting your local agricultural extension office.',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Close the bottom sheet
                            Navigator.pop(context);

                            // Prepare data for API
                            double temperatureValue =
                                double.tryParse(temperatureController.text) ??
                                25.0;
                            double rainfallValue =
                                double.tryParse(rainfallController.text) ??
                                100.0;

                            // Convert values to required units if needed
                            if (temperatureUnit == '°F') {
                              // Convert Fahrenheit to Celsius
                              temperatureValue =
                                  (temperatureValue - 32) * 5 / 9;
                            }

                            if (rainfallUnit == 'inches') {
                              // Convert inches to mm
                              rainfallValue = rainfallValue * 25.4;
                            }

                            final params = CropRecommendationParams(
                              nitrogen: double.parse(nitrogenController.text),
                              phosphorus: double.parse(
                                phosphorusController.text,
                              ),
                              potassium: double.parse(potassiumController.text),
                              temperature: temperatureValue,
                              humidity: double.parse(humidityController.text),
                              ph: double.parse(phController.text),
                              rainfall: rainfallValue,
                            );

                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 20),
                                        Text(
                                          'Analyzing your data and generating recommendations...',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            // Call the recommendation service
                            final service = CropRecommendationService();
                            service
                                .getRecommendations(params)
                                .then((result) {
                                  // Close loading dialog
                                  Navigator.pop(context);

                                  // Show results
                                  final recommendations =
                                      _prepareRecommendations(result);
                                  _showRecommendationResultWithData(
                                    context,
                                    recommendations,
                                  );
                                })
                                .catchError((error) {
                                  // Close loading dialog
                                  Navigator.pop(context);

                                  // Show error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $error')),
                                  );
                                });
                          },
                          label: const Text('Generate Recommendations'),
                          icon: Icon(Icons.auto_awesome, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  // Helper method to prepare recommendations from API result
  List<Map<String, dynamic>> _prepareRecommendations(
    CropRecommendationResult result,
  ) {
    final List<Map<String, dynamic>> recommendations = [];

    // Combine crop IDs with their scores
    for (int i = 0; i < result.cropIds.length; i++) {
      final cropId = result.cropIds[i];
      final score = result.scores[i];
      final cropData = CropData.getById(cropId);

      if (cropData != null) {
        recommendations.add({
          'cropId': cropId,
          'match_percentage': score * 100, // Convert to percentage
          'description': cropData.description,
          'name': cropData.name,
          'imagePath': cropData.imagePath,
        });
      }
    }

    return recommendations;
  }

  // Helper method to build consistent input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required TextInputType keyboardType,
    required String hint,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixText: suffix,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              helperText: helperText,
              helperStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build input fields with unit selectors
  Widget _buildInputFieldWithUnitSelector({
    required TextEditingController controller,
    required String label,
    required String currentUnit,
    required List<String> units,
    required Function(String) onUnitChanged,
    required TextInputType keyboardType,
    required String hint,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    helperText: helperText,
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      value: currentUnit,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onUnitChanged(newValue);
                        }
                      },
                      items:
                          units.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to show manual crop selection
  void _showManualCropSelectionSheet(BuildContext context) {
    final allCrops = CropData.getAllCrops();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (_, scrollController) => Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Select a Crop',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose from all available crops',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          // Search box
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search crops...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                              ),
                            ),
                            onChanged: (value) {
                              // Implement search functionality if needed
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: allCrops.length,
                        itemBuilder: (context, index) {
                          final crop = allCrops[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  crop.imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              title: Text(
                                crop.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                crop.description,
                                overflow: TextOverflow.visible,
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pop(context);
                                // Here you would typically navigate to a detail screen
                                // for the selected crop or add it to the user's list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selected ${crop.name}'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  // Method to show recommendation results with actual data
  void _showRecommendationResultWithData(
    BuildContext context,
    List<Map<String, dynamic>> recommendations,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (_, scrollController) => Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          const Text(
                            'Recommended Crops',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Based on your soil and environmental data',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Display top 3 recommendations or all if less than 3
                          for (
                            int i = 0;
                            i < recommendations.length && i < 3;
                            i++
                          )
                            _buildRecommendedCropCardWithImage(
                              context,
                              recommendations[i]['name'],
                              '${recommendations[i]['match_percentage'].toStringAsFixed(1)}% match',
                              recommendations[i]['description'],
                              recommendations[i]['imagePath'],
                              recommendations[i]['cropId'],
                            ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButtonCustom(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to details screen for selected crop or
                                // continue with the selected recommendation

                                // For now, just show a snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Recommendation selected!'),
                                  ),
                                );
                              },
                              label: 'Select Top Recommendation',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  // Helper to build recommended crop card with image
  Widget _buildRecommendedCropCardWithImage(
    BuildContext context,
    String cropName,
    String matchPercentage,
    String description,
    String imagePath,
    int cropId,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Show detailed view or select this crop
          Navigator.pop(context);

          // Here you would typically navigate to a detail screen
          // for the selected crop or add it to the user's list
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Selected $cropName')));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop image header
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        _getCropIcon(cropId),
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
              ),
            ),

            // Crop details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            Text(
                              matchPercentage,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.arrow_forward, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to get icon for a crop
  IconData _getCropIcon(int cropId) {
    // Group crops by type for appropriate icons
    final List<int> grains = [1, 2]; // Rice, Maize
    final List<int> beans = [3, 4, 5, 6, 7, 8, 9]; // Various beans
    final List<int> fruits = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]; // Fruits
    final List<int> commercial = [20, 21, 22]; // Cotton, Jute, Coffee

    if (grains.contains(cropId)) {
      return Icons.grass;
    } else if (beans.contains(cropId)) {
      return Icons.spa;
    } else if (fruits.contains(cropId)) {
      return Icons.eco;
    } else if (commercial.contains(cropId)) {
      return Icons.agriculture;
    }

    return Icons.grass;
  }
}
