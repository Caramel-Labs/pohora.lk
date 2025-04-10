import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pohora_lk/data/models/news.dart';
import 'package:pohora_lk/data/models/comment.dart';

class NewsRepository {
  final String _baseUrl = 'http://16.171.4.110:5000';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all news
  Future<List<News>> getNews() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/news'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => News.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');

      // Return mock data if API is unavailable
      return [
        // News(
        //   id: 1,
        //   title: "New Techniques in Farming",
        //   body:
        //       "Learn about hydroponics and modern farming techniques that can revolutionize your cultivation practices. This approach uses less water and produces higher yields.",
        //   imagePath: "/images/news1.jpg",
        //   timestamp: DateTime.now().subtract(const Duration(days: 2)),
        //   author: "Admin",
        // ),
        // News(
        //   id: 2,
        //   title: "Fertilizer Prices Drop",
        //   body:
        //       "Good news for farmers as fertilizer prices have dropped by 15% this month. Check latest market rates and stock up for the season.",
        //   imagePath: "/images/news2.jpg",
        //   timestamp: DateTime.now().subtract(const Duration(days: 1)),
        //   author: "Editor",
        // ),
        // News(
        //   id: 3,
        //   title: "How to Improve Yield",
        //   body:
        //       "10 expert tips to boost your crop yield this season. Follow these guidelines to maximize your harvest.",
        //   imagePath: "/images/news3.jpg",
        //   timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        //   author: "Expert",
        // ),
        // News(
        //   id: 4,
        //   title: "Organic vs Chemical",
        //   body:
        //       "We examine the pros and cons of organic and chemical farming methods to help you make informed decisions.",
        //   imagePath: "/images/news4.jpg",
        //   timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        //   author: "AgroTech",
        // ),
        // News(
        //   id: 5,
        //   title: "Pest Control Tips",
        //   body:
        //       "Learn about natural remedies for common pests that can damage your crops. These eco-friendly solutions are effective and safe.",
        //   imagePath: "/images/news5.jpg",
        //   timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        //   author: "FarmerBot",
        // ),
      ];
    }
  }

  // Get single news detail
  Future<News> getNewsDetail(int newsId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/news/$newsId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return News.fromJson(jsonData);
      } else {
        throw Exception('Failed to load news detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news detail: $e');

      // Return mock data if API is unavailable
      return News(
        id: newsId,
        title: "New Techniques in Farming",
        body:
            "Learn about hydroponics and modern farming techniques that can revolutionize your cultivation practices. This approach uses less water and produces higher yields.\n\nHydroponics is a type of horticulture and a subset of hydroculture, which is a method of growing plants, usually crops, without soil, by using mineral nutrient solutions in an aqueous solvent. Terrestrial plants may be grown with only their roots exposed to the nutritious liquid, or, in addition, the roots may be physically supported by an inert medium such as perlite, gravel, or other substrates.\n\nDespite inert media, roots can cause changes of the rhizosphere pH and root exudates can affect the rhizosphere biology. The nutrients used in hydroponic systems can come from many different sources, including fish excrement, duck manure, purchased chemical fertilizers, or artificial nutrient solutions.",
        imagePath: "/images/news1.jpg",
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        author: "Admin",
      );
    }
  }

  // Get comments for a news article
  Future<List<Comment>> getNewsComments(int newsId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/news/$newsId/comments'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Comment.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');

      // Return mock data if API is unavailable
      return [
        // Comment(
        //   id: 1,
        //   content:
        //       "Very informative! I'm going to try hydroponics in my small backyard.",
        //   userId: "user123",
        //   timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        //   userName: "John Farmer",
        // ),
        // Comment(
        //   id: 2,
        //   content:
        //       "I've been using this technique for a year now. It really works well for leafy vegetables.",
        //   userId: "user456",
        //   timestamp: DateTime.now().subtract(const Duration(days: 1)),
        //   userName: "Maria Grower",
        // ),
        // Comment(
        //   id: 3,
        //   content: "Where can I buy the equipment needed for this?",
        //   userId: "user789",
        //   timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        //   userName: "Farming Newbie",
        // ),
      ];
    }
  }

  // Add a comment to a news article
  Future<bool> addComment(int newsId, String content) async {
    try {
      final userId = _auth.currentUser?.uid ?? 'anonymous';

      final response = await http.post(
        Uri.parse('$_baseUrl/news/$newsId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'userId': userId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add comments: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }
}
