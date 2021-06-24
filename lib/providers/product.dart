import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    _toggleFavorite();
    notifyListeners();
    try {
      final _baseUrl = "${Constants.BASE_API_URL}/products/$id.json";

      final response = await http.patch(
        _baseUrl,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        _toggleFavorite();
        notifyListeners();
      }
    } catch (error) {
      _toggleFavorite();
      notifyListeners();
    }
  }
}
