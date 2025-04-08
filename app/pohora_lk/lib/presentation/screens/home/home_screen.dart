import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/cultivation.dart';
import 'package:pohora_lk/data/repositories/cultivation_repository.dart';
import 'package:pohora_lk/presentation/widgets/cropcard_custom.dart';
import 'package:pohora_lk/presentation/screens/home/add_cultivation_screen.dart';
import 'package:pohora_lk/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CultivationRepository _cultivationRepository = CultivationRepository();

  List<Cultivation> _cultivations = [];
  List<Cultivation> _filteredCultivations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCultivations();
    _searchController.addListener(_filterCultivations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCultivations);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCultivations() async {
    setState(() => _isLoading = true);

    try {
      final cultivations = await _cultivationRepository.getCultivations();
      setState(() {
        _cultivations = cultivations;
        _filteredCultivations = cultivations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cultivations: $e')),
      );
    }
  }

  void _filterCultivations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCultivations = _cultivations;
      } else {
        _filteredCultivations =
            _cultivations.where((cultivation) {
              return cultivation.cropName?.toLowerCase().contains(query) ==
                      true ||
                  cultivation.location.toLowerCase().contains(query) ||
                  cultivation.soilType.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cultivations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCultivations,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCultivations,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search box
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search cultivations...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Header or empty state
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_filteredCultivations.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/empty_state.png',
                              height: 200,
                              opacity: const AlwaysStoppedAnimation(.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No cultivations yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add your first cultivation using the + button',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You have ${_filteredCultivations.length} ${_filteredCultivations.length == 1 ? 'cultivation' : 'cultivations'}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredCultivations.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CropCard_Custom(
                                cultivation: _filteredCultivations[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCultivationScreen(),
            ),
          ).then((_) => _loadCultivations()); // Reload after returning
        },
      ),
    );
  }
}
