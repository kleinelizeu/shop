import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl = "${Constants.BASE_API_URL}/products";
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get('$_baseUrl.json');

    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
        notifyListeners();
      });
    }
    return Future.value();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      '$_baseUrl.json',
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return; //produto não existe,nada é feito
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product; // produto existe, vamos atualizar
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete("$_baseUrl/${product.id}.json");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptions("Ocorreu um erro na exclusão do produto");
      }
    }
  }
}

// bool _showFavoriteOnly = false;

/* List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }
*/
