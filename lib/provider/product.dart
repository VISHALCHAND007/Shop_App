import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite(String? token) async {
    final url = "https://shop-app-a8b3b-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final oldState = isFavourite;
    try {
      isFavourite = !isFavourite;
      notifyListeners();

      final response = await http.patch(Uri.parse(url), body: json.encode({
        "is_favourite": isFavourite
      }));
      if(response.statusCode >= 400) {
        isFavourite = oldState;
        notifyListeners();
        throw HttpException(message: "Something went wrong.");
      }
    } catch(error) {
      isFavourite = oldState;
      notifyListeners();
      rethrow;
    }
  }
}
