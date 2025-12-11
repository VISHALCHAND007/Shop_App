import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get getItems {
    return {..._cartItems};
  }

  void addItem(String productId, String imageUrl, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      // update the quantity
      _cartItems.update(
        productId,
        (oldEntry) => CartItem(
          id: oldEntry.id,
          title: oldEntry.title,
          quantity: oldEntry.quantity + 1,
          price: oldEntry.price,
          imageUrl: oldEntry.imageUrl,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().millisecond.toString(),
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  int get getSize {
    return _cartItems.length;
  }

  double get orderTotal {
    var total = 0.0;
    _cartItems.forEach((productId, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
