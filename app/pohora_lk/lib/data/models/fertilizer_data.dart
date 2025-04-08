class FertilizerData {
  final int id;
  final String name;
  final String imagePath;
  final String description;

  FertilizerData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });

  // Get all fertilizer data
  static List<FertilizerData> getAllFertilizers() {
    return [
      FertilizerData(
        id: 1,
        name: 'Balanced NPK',
        imagePath: 'assets/fertilizers/balanced-npk.jpg',
        description:
            'A general-purpose fertilizer with balanced levels of nitrogen, phosphorus, and potassium. Suitable for most crops to promote overall growth and development.',
      ),
      FertilizerData(
        id: 2,
        name: 'DAP (Diammonium Phosphate)',
        imagePath: 'assets/fertilizers/dap.jpg',
        description:
            'High in phosphorus and contains nitrogen. Excellent for promoting root development, flowering, and fruiting. Often used during planting or early growth stages.',
      ),
      FertilizerData(
        id: 3,
        name: 'Urea',
        imagePath: 'assets/fertilizers/urea.jpeg',
        description:
            'High-nitrogen fertilizer that promotes leafy growth and green foliage. Best used during vegetative growth stages when plants need nitrogen for rapid growth.',
      ),
      FertilizerData(
        id: 4,
        name: 'MOP (Muriate of Potash)',
        imagePath: 'assets/fertilizers/mop.jpg',
        description:
            'Contains high levels of potassium. Improves overall plant vigor, disease resistance, and helps in water regulation within plants. Good for flowering and fruiting stages.',
      ),
      FertilizerData(
        id: 5,
        name: 'Compost',
        imagePath: 'assets/fertilizers/compost.jpg',
        description:
            'Organic fertilizer made from decomposed plant material. Improves soil structure, adds nutrients slowly, and enhances microbial activity in the soil.',
      ),
      FertilizerData(
        id: 6,
        name: 'Organic Fertilizer',
        imagePath: 'assets/fertilizers/orgamc.jpg',
        description:
            'Made from natural materials like animal manure, bone meal, and plant residues. Provides slow-release nutrients and improves soil health over time.',
      ),
      FertilizerData(
        id: 7,
        name: 'Lime',
        imagePath: 'assets/fertilizers/lime.jpg',
        description:
            'Used to raise soil pH in acidic soils. Not actually a fertilizer but helps make nutrients more available to plants in acidic conditions.',
      ),
      FertilizerData(
        id: 8,
        name: 'Gypsum',
        imagePath: 'assets/fertilizers/gypsum.jpg',
        description:
            'Contains calcium and sulfur. Helps improve soil structure, especially in clayey or compacted soils. Also helps reduce soil salinity.',
      ),
      FertilizerData(
        id: 9,
        name: 'General Purpose',
        imagePath: 'assets/fertilizers/general-purpose.jpg',
        description:
            'All-purpose fertilizer suitable for a wide range of crops. Contains a mix of macro and micronutrients for balanced plant nutrition.',
      ),
      FertilizerData(
        id: 10,
        name: 'Water-Retaining Fertilizer',
        imagePath: 'assets/fertilizers/water-retaining.jpg',
        description:
            'Special fertilizer that helps retain moisture in the soil. Particularly useful in dry conditions or for plants that need consistent moisture.',
      ),
    ];
  }

  // Get fertilizer by ID
  static FertilizerData? getById(int id) {
    try {
      return getAllFertilizers().firstWhere(
        (fertilizer) => fertilizer.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}
