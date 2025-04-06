import 'package:flutter/material.dart';

class CropDetailsScreen extends StatelessWidget {
  final int? cropId;

  const CropDetailsScreen({super.key, this.cropId});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: screenHeight * 0.25,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Crop Details${cropId != null ? " #$cropId" : ""}'),
              background: Image.asset(
                'assets/images/crop_placeholder.jpg',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const FlutterLogo(size: 200),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crop Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Name:', 'Rice'),
                      _buildInfoRow('Category:', 'Grain'),
                      _buildInfoRow('Growing Season:', 'Year-round'),
                      _buildInfoRow('Water Requirement:', 'High'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommended Fertilizers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFertilizerItem(
                        'Nitrogen-rich fertilizer',
                        '2-3 weeks after planting',
                      ),
                      _buildFertilizerItem(
                        'Phosphorous fertilizer',
                        'During land preparation',
                      ),
                      _buildFertilizerItem(
                        'Potassium fertilizer',
                        'During heading stage',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: index.isOdd ? Colors.white : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                height: 80.0,
                child: Center(
                  child: Text(
                    'Additional Info ${index + 1}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }, childCount: 5),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildFertilizerItem(String name, String timing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apply: $timing',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
