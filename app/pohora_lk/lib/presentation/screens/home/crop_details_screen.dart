import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/crop_data.dart';
import 'package:pohora_lk/data/models/cultivation.dart';
import 'package:pohora_lk/data/models/fertilizer_data.dart';
import 'package:pohora_lk/data/models/fertilizer_log.dart';
import 'package:pohora_lk/data/repositories/cultivation_repository.dart';
import 'package:pohora_lk/data/services/fertilizer_service.dart';
import 'package:intl/intl.dart';

class CropDetailsScreen extends StatefulWidget {
  final int cropId;
  final int cultivationId;

  const CropDetailsScreen({
    super.key,
    required this.cropId,
    required this.cultivationId,
  });

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  List<FertilizerLog> _fertilizerLogs = [];
  bool _isLoadingLogs = true;
  late Cultivation? _cultivationData;
  bool _isLoadingCultivation = true;

  @override
  void initState() {
    super.initState();
    print('Received cultivationId: ${widget.cultivationId}');
    print('Received cropId: ${widget.cropId}');
    _loadFertilizerLogs();
    _loadCultivationData();
  }

  Future<void> _loadFertilizerLogs() async {
    setState(() {
      _isLoadingLogs = true;
    });

    try {
      final fertilizerService = FertilizerService();
      final logs = await fertilizerService.getFertilizerLogs(
        widget.cultivationId,
      );

      setState(() {
        _fertilizerLogs = logs;
        _isLoadingLogs = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLogs = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load fertilizer logs: $e')),
      );
      setState(() {
        _isLoadingLogs = false;
        // Set empty list on error
        _fertilizerLogs = [];
      });
    }
  }

  // Add a method to load cultivation data
  Future<void> _loadCultivationData() async {
    setState(() {
      _isLoadingCultivation = true;
    });

    try {
      final repository = CultivationRepository();
      final cultivations = await repository.getCultivations();

      // Find the cultivation that matches our cultivationId
      final cultivation = cultivations.firstWhere(
        (c) => c.cultivationId == widget.cultivationId,
        orElse:
            () => Cultivation(
              cultivationId: widget.cultivationId,
              soilType: 'Unknown', // Default soil type
              landArea: 0,
              location: 'Unknown',
              cropId: widget.cropId,
              userId: '',
            ),
      );

      setState(() {
        _cultivationData = cultivation;
        _isLoadingCultivation = false;
      });

      print('cultivation id after loading: ${cultivation.cultivationId}');
    } catch (e) {
      print('Error loading cultivation data: $e');
      setState(() {
        _isLoadingCultivation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropData = CropData.getById(widget.cropId);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadFertilizerLogs,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton.filledTonal(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_rounded),
              ),
              pinned: true,
              expandedHeight: screenHeight * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  cropData?.name ?? 'Crop Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Theme.of(context).hintColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.3, 1.0],
                    ),
                  ),
                  child: Image.asset(
                    cropData?.imagePath ?? 'assets/images/crop_placeholder.jpg',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),
            ),

            // Crop information card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cropData?.name ?? 'Unknown Crop',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cropData?.description ?? 'No description available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),

                        const Divider(height: 24),

                        // Cultivation details section
                        const Text(
                          'Cultivation Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Show loading indicator while fetching cultivation data
                        _isLoadingCultivation
                            ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location row
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Location: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _cultivationData?.location ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Soil Type row
                                Row(
                                  children: [
                                    Icon(
                                      Icons.landscape,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Soil Type: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _cultivationData?.soilType ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Land Area row
                                Row(
                                  children: [
                                    Icon(
                                      Icons.area_chart,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Land Area: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${_cultivationData?.landArea ?? 0} ${_cultivationData?.unit ?? 'acres'}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        const SizedBox(height: 20),

                        // Add the Get Fertilizer Recommendation button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _showFertilizerRecommendationSheet(context);
                            },
                            icon: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                            ),
                            label: const Text('Get Fertilizer Recommendation'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fertilizer logs section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fertilizer Application Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showAddFertilizerLogSheet(context);
                      },
                      icon: const Icon(Icons.add_circle),
                      tooltip: 'Add New Entry',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            // Fertilizer logs list
            _isLoadingLogs
                ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
                : _fertilizerLogs.isEmpty
                ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_list_bulleted,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No fertilizer applications recorded',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first entry',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final log = _fertilizerLogs[index];
                    return _buildFertilizerLogItem(log);
                  }, childCount: _fertilizerLogs.length),
                ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildFertilizerLogItem(FertilizerLog log) {
    final fertilizer = FertilizerData.getById(log.fertilizerId);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            fertilizer?.imagePath ?? 'assets/fertilizers/general-purpose.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.science, color: Colors.grey),
                ),
          ),
        ),
        title: Text(
          fertilizer?.name ?? log.fertilizerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Applied on ${dateFormat.format(log.timestamp)}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  // Update the _showFertilizerRecommendationSheet method
  void _showFertilizerRecommendationSheet(BuildContext context) {
    // Controllers for form fields with default values
    final temperatureController = TextEditingController(text: '25');
    final moistureController = TextEditingController(text: '60');
    final rainfallController = TextEditingController(text: '30');
    final phController = TextEditingController(text: '6.5');
    final nitrogenController = TextEditingController(text: '40');
    final phosphorusController = TextEditingController(text: '30');
    final potassiumController = TextEditingController(text: '35');
    final carbonController = TextEditingController(text: '0.5');
    final soilType = _cultivationData?.soilType ?? 'Loamy Soil';

    // Unit selection state
    String temperatureUnit = '°C';
    String rainfallUnit = 'mm';

    // Get crop name from widget cropId
    final cropData = CropData.getById(widget.cropId);
    final cropName = cropData?.name ?? 'Unknown';

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
                        'Provide accurate data for better fertilizer recommendations',
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
                              // Temperature
                              _buildInputFieldWithUnitSelector(
                                controller: temperatureController,
                                label: 'Soil Temperature',
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
                                hint: '20-30',
                                helperText: 'Soil or ambient temperature',
                              ),

                              // Soil moisture
                              _buildInputField(
                                controller: moistureController,
                                label: 'Soil Moisture',
                                suffix: '%',
                                keyboardType: TextInputType.number,
                                hint: '40-80',
                                helperText: 'Current soil moisture content',
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
                                hint: '10-50',
                                helperText: 'Recent rainfall amount',
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
                                hint: '5.5-7.5',
                                helperText: 'pH Scale: 0-14 (7 is neutral)',
                              ),

                              // Nitrogen content
                              _buildInputField(
                                controller: nitrogenController,
                                label: 'Nitrogen content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '20-100',
                                helperText: 'Current nitrogen level in soil',
                              ),

                              // Phosphorus content
                              _buildInputField(
                                controller: phosphorusController,
                                label: 'Phosphorus content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '10-80',
                                helperText: 'Current phosphorus level in soil',
                              ),

                              // Potassium content
                              _buildInputField(
                                controller: potassiumController,
                                label: 'Potassium content',
                                suffix: 'mg/kg',
                                keyboardType: TextInputType.number,
                                hint: '15-90',
                                helperText: 'Current potassium level in soil',
                              ),

                              // Carbon content (renamed from Organic Carbon)
                              _buildInputField(
                                controller: carbonController,
                                label: 'Carbon content',
                                suffix: '%',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hint: '0.2-1.5',
                                helperText: 'Soil carbon content',
                              ),

                              // Soil type display (non-editable)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Soil Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        color: Colors.grey.shade100,
                                      ),
                                      width: double.infinity,
                                      child: Text(
                                        'Loamy Soil', // This would come from the cultivation data
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                    if (true) // Always show helper text
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 12,
                                        ),
                                        child: Text(
                                          'Based on your cultivation data',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Crop type display (non-editable)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Crop Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        color: Colors.grey.shade100,
                                      ),
                                      width: double.infinity,
                                      child: Text(
                                        cropName,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        left: 12,
                                      ),
                                      child: Text(
                                        'Current crop in your cultivation',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                        'For best results, enter accurate and recent soil test data.',
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
                          onPressed: () async {
                            // Close the bottom sheet
                            Navigator.pop(context);

                            // Prepare data for API
                            double temperatureValue =
                                double.tryParse(temperatureController.text) ??
                                25.0;
                            double rainfallValue =
                                double.tryParse(rainfallController.text) ??
                                30.0;

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

                            // Create updated parameters using the new format
                            final params = FertilizerRecommendationParams(
                              cropId: widget.cropId,
                              temperature: temperatureValue,
                              moisture: double.parse(moistureController.text),
                              rainfall: rainfallValue,
                              ph: double.parse(phController.text),
                              nitrogen: double.parse(nitrogenController.text),
                              phosphorous: double.parse(
                                phosphorusController.text,
                              ), // Note the 'o' spelling
                              potassium: double.parse(potassiumController.text),
                              carbon: double.parse(
                                carbonController.text,
                              ), // Renamed from organicCarbon
                              soil:
                                  soilType, // This would come from the cultivation data
                            );

                            // Show loading indicator using a separate builder context
                            BuildContext? dialogContext;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext ctx) {
                                dialogContext = ctx;
                                return const Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 20),
                                        Text(
                                          'Analyzing your data and finding the best fertilizer...',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            // Call the recommendation service
                            final service = FertilizerService();
                            try {
                              final result = await service
                                  .getFertilizerRecommendation(params);

                              // Dismiss loading dialog
                              if (dialogContext != null &&
                                  Navigator.canPop(dialogContext!)) {
                                Navigator.pop(dialogContext!);
                              }

                              // Show result
                              if (dialogContext!.mounted) {
                                _showFertilizerResultScreen(
                                  dialogContext!,
                                  result,
                                );
                              }
                            } catch (error) {
                              // Dismiss loading dialog
                              if (dialogContext != null &&
                                  Navigator.canPop(dialogContext!)) {
                                Navigator.pop(dialogContext!);
                              }

                              // Show error
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $error')),
                                );
                              }
                            }
                          },
                          label: const Text('Get Recommendation'),
                          icon: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                          ),
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

  // Updated _showFertilizerResultScreen method
  void _showFertilizerResultScreen(
    BuildContext context,
    FertilizerRecommendationResult result,
  ) {
    // Get fertilizer ID using the topFertilizer name
    final fertilizerId = result.getFertilizerId();
    final fertilizer = FertilizerData.getById(fertilizerId);

    if (fertilizer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fertilizer data not found')),
      );
      return;
    }

    // Format confidence percentage
    final confidencePercentage = (result.predictedConfidence * 100)
        .toStringAsFixed(0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
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
                        'Recommended Fertilizer',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Fertilizer image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          fertilizer.imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.science,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Fertilizer name and match percentage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              fertilizer.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$confidencePercentage% Match',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Fertilizer description
                      Text(
                        fertilizer.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Other recommendations
                      if (result.topChoices.length > 1) ...[
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Alternative Fertilizers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Skip the top choice as we already displayed it
                        for (int i = 1; i < result.topChoices.length; i++) ...[
                          if (result.topChoices[i].confidence > 0)
                            ListTile(
                              title: Text(
                                result.topChoices[i].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                '${(result.topChoices[i].confidence * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              dense: true,
                            ),
                        ],
                      ],

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Close'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                // Record the fertilizer application
                                Navigator.pop(context);
                                _addFertilizerLog(
                                  fertilizerId,
                                  fertilizer.name,
                                );
                              },
                              child: const Text('Apply Now'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addFertilizerLog(
    int fertilizerId,
    String fertilizerName,
  ) async {
    final service = FertilizerService();

    print('Cultivation id: ${_cultivationData!.cultivationId}');

    bool isFertilizerAdded = await service.addFertilizerLog(
      _cultivationData!.cultivationId,
      fertilizerId,
      fertilizerName,
    );

    if (isFertilizerAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fertilizer application recorded')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to record application')));
    }
    await _loadFertilizerLogs(); // Reload the logs
  }

  void _showAddFertilizerLogSheet(BuildContext context) {
    final fertilizers = FertilizerData.getAllFertilizers();
    int selectedFertilizerId = fertilizers[0].id;

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        'Add Fertilizer Application',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Select the fertilizer you applied',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Fertilizer selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<int>(
                          value: selectedFertilizerId,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedFertilizerId = newValue;
                              });
                            }
                          },
                          items:
                              fertilizers.map<DropdownMenuItem<int>>((
                                fertilizer,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: fertilizer.id,
                                  child: Text(fertilizer.name),
                                );
                              }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            final fertilizer = FertilizerData.getById(
                              selectedFertilizerId,
                            );
                            if (fertilizer != null) {
                              _addFertilizerLog(fertilizer.id, fertilizer.name);
                            }
                          },
                          child: const Text('Record Application'),
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
}
