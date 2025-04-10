import 'package:flutter/material.dart';
import 'package:pohora_lk/presentation/screens/home/select_crop_screen.dart';
import 'package:pohora_lk/presentation/widgets/primary_button_custom.dart';

class AddCultivationScreen extends StatefulWidget {
  const AddCultivationScreen({super.key});

  @override
  State<AddCultivationScreen> createState() => _AddCultivationScreenState();
}

class _AddCultivationScreenState extends State<AddCultivationScreen> {
  final _landAreaController = TextEditingController();
  final _locationController = TextEditingController(); // Default location
  String _selectedUnit = 'Acres';
  final List<String> _units = ['Acres', 'Hectares'];

  String _selectedSoil = 'Acidic Soil';
  final List<String> _soils = [
    'Acidic Soil',
    'Peaty Soil',
    'Neutral Soil',
    'Loamy Soil',
    'Alkaline Soil',
  ];

  final Map<String, String> _soilDescriptions = {
    'Acidic Soil':
        'pH less than 7. Good for growing blueberries, azaleas, and rhododendrons.',
    'Peaty Soil':
        'Waterlogged soil rich in organic matter. Excellent for water retention.',
    'Neutral Soil': 'pH around 7. Versatile for most plants and vegetables.',
    'Loamy Soil':
        'Well-balanced mix of sand, silt, and clay. Ideal for most crops.',
    'Alkaline Soil':
        'pH greater than 7. Good for growing cabbage, cauliflower, and sweet corn.',
  };

  // For unit conversion
  double _convertLandArea() {
    if (_landAreaController.text.isEmpty) return 0;

    double area = double.tryParse(_landAreaController.text) ?? 0;
    if (_selectedUnit == 'Acres') {
      return area * 0.404686; // Convert acres to hectares
    } else {
      return area * 2.47105; // Convert hectares to acres
    }
  }

  String _getConvertedUnitText() {
    if (_landAreaController.text.isEmpty) return '';

    double convertedArea = _convertLandArea();
    String convertedUnit = _selectedUnit == 'Acres' ? 'Hectares' : 'Acres';
    return '${convertedArea.toStringAsFixed(2)} $convertedUnit';
  }

  @override
  void dispose() {
    _landAreaController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cultivation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your cultivation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Location input field
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter location name',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location, size: 20),
                  tooltip: 'Use current location',
                  onPressed: () {
                    // In a real app, you'd use a location plugin here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Getting current location...'),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Land area input with unit selection
            const Text(
              'Land Area',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text field for land area
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: _landAreaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter land area',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                // Unit dropdown next to text field
                Expanded(
                  flex: 4,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 14.5,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedUnit = newValue;
                            });
                          }
                        },
                        items:
                            _units.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
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
            // Then if the land area is not empty, show the conversion
            if (_landAreaController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Equivalent to: ${_getConvertedUnitText()}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Soil type selection
            const Text(
              'Soil Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSoil,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items:
                  _soils.map((soil) {
                    return DropdownMenuItem<String>(
                      value: soil,
                      child: Text(soil),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSoil = value;
                  });
                }
              },
            ),

            // Soil description card
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.all(0.0),
              elevation: 0,
              color: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedSoil,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _soilDescriptions[_selectedSoil] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: PrimaryButtonCustom(
                onPressed: () {
                  // Navigate to next page
                  if (_landAreaController.text.isEmpty) {
                    // Show validation error for land area
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter land area')),
                    );
                    return;
                  }

                  if (_locationController.text.isEmpty) {
                    // Show validation error for location
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter location')),
                    );
                    return;
                  }

                  // Parse the land area
                  double landArea =
                      double.tryParse(_landAreaController.text) ?? 0;

                  // Navigate to the select crop screen with all data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectCropScreen(
                            landArea: landArea,
                            unit: _selectedUnit,
                            soilType: _selectedSoil,
                            location: _locationController.text,
                          ),
                    ),
                  );
                },
                label: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
