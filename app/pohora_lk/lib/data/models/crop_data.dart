class CropData {
  final int id;
  final String name;
  final String imagePath;
  final String description;

  CropData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });

  // Get all crop data
  static List<CropData> getAllCrops() {
    return [
      CropData(
        id: 1,
        name: 'Rice',
        imagePath: 'assets/crops/rice.jpg',
        description:
            'Rice is a staple food for more than half of the world\'s population. It grows well in warm and humid climates with plenty of water.',
      ),
      CropData(
        id: 2,
        name: 'Maize',
        imagePath: 'assets/crops/maize.jpg',
        description:
            'Maize (corn) is one of the most versatile crops, used for food, feed, and industrial purposes. Thrives in warm weather with moderate water.',
      ),
      CropData(
        id: 3,
        name: 'Chickpea',
        imagePath: 'assets/crops/chickpea.jpg',
        description:
            'Chickpeas are a good source of protein and fiber. They grow well in dry conditions and can tolerate heat and drought.',
      ),
      CropData(
        id: 4,
        name: 'Kidney Beans',
        imagePath: 'assets/crops/kidneybeans.jpg',
        description:
            'Kidney beans are rich in protein and minerals. They prefer well-drained soil and moderate temperatures.',
      ),
      CropData(
        id: 5,
        name: 'Pigeon Beans',
        imagePath: 'assets/crops/pigeonbeans.jpg',
        description:
            'Pigeon beans are drought-resistant and can grow in poor soil conditions, making them ideal for sustainable farming.',
      ),
      CropData(
        id: 6,
        name: 'Moth Beans',
        imagePath: 'assets/crops/mothbeans.jpg',
        description:
            'Moth beans are highly drought-resistant and can thrive in arid conditions with minimal water requirements.',
      ),
      CropData(
        id: 7,
        name: 'Mung Beans',
        imagePath: 'assets/crops/mungbeans.jpg',
        description:
            'Mung beans are short-season crop that are rich in protein. They grow well in warm temperatures and moderate humidity.',
      ),
      CropData(
        id: 8,
        name: 'Black Gram',
        imagePath: 'assets/crops/blackgram.jpg',
        description:
            'Black gram is a protein-rich pulse crop that grows well in humid areas with moderate rainfall.',
      ),
      CropData(
        id: 9,
        name: 'Lentil',
        imagePath: 'assets/crops/lentil.jpg',
        description:
            'Lentils are nutritious legumes that grow well in cool climates and can tolerate some drought conditions.',
      ),
      CropData(
        id: 10,
        name: 'Pomegranate',
        imagePath: 'assets/crops/pomegranate.jpg',
        description:
            'Pomegranates are drought-resistant fruit trees that produce antioxidant-rich fruits. They require well-drained soil.',
      ),
      CropData(
        id: 11,
        name: 'Banana',
        imagePath: 'assets/crops/banana.jpeg',
        description:
            'Bananas are tropical fruits that require warm temperatures, high humidity, and plenty of water to grow well.',
      ),
      CropData(
        id: 12,
        name: 'Mango',
        imagePath: 'assets/crops/mango.jpg',
        description:
            'Mangoes are tropical fruit trees that need warm temperatures and a distinct dry season to produce the best fruit.',
      ),
      CropData(
        id: 13,
        name: 'Grapes',
        imagePath: 'assets/crops/grapes.jpg',
        description:
            'Grapes thrive in temperate climates with warm, dry summers and cool winters. They need well-drained soil.',
      ),
      CropData(
        id: 14,
        name: 'Watermelon',
        imagePath: 'assets/crops/watermelon.jpg',
        description:
            'Watermelons need warm temperatures, plenty of sunlight, and consistent moisture to develop their sweet flavor.',
      ),
      CropData(
        id: 15,
        name: 'Muskmelon',
        imagePath: 'assets/crops/muskmelon.jpg',
        description:
            'Muskmelons (cantaloupe) require warm soil, consistent moisture, and good air circulation to prevent disease.',
      ),
      CropData(
        id: 16,
        name: 'Apple',
        imagePath: 'assets/crops/apple.jpeg',
        description:
            'Apple trees require cool winters and moderate summers, with good drainage and full sun exposure.',
      ),
      CropData(
        id: 17,
        name: 'Orange',
        imagePath: 'assets/crops/orange.jpeg',
        description:
            'Oranges thrive in subtropical climates with mild winters. They need well-draining soil and regular watering.',
      ),
      CropData(
        id: 18,
        name: 'Papaya',
        imagePath: 'assets/crops/papaya.jpg',
        description:
            'Papayas are fast-growing tropical fruits that need warm temperatures and protection from strong winds.',
      ),
      CropData(
        id: 19,
        name: 'Coconut',
        imagePath: 'assets/crops/coconut.jpeg',
        description:
            'Coconut palms are tropical trees that thrive in humid coastal areas with sandy, well-draining soil.',
      ),
      CropData(
        id: 20,
        name: 'Cotton',
        imagePath: 'assets/crops/cotton.jpg',
        description:
            'Cotton is a warm-season crop that requires a long growing season, abundant sunshine, and moderate rainfall.',
      ),
      CropData(
        id: 21,
        name: 'Jute',
        imagePath: 'assets/crops/jute.jpg',
        description:
            'Jute is a rainy season crop that thrives in warm, humid conditions with high rainfall.',
      ),
      CropData(
        id: 22,
        name: 'Coffee',
        imagePath: 'assets/crops/coffee.jpg',
        description:
            'Coffee plants prefer rich soil, mild temperatures, and regular rainfall or irrigation.',
      ),
    ];
  }

  // Get crop by ID
  static CropData? getById(int id) {
    try {
      return getAllCrops().firstWhere((crop) => crop.id == id);
    } catch (e) {
      return null;
    }
  }
}
