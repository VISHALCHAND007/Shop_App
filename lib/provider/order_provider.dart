import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shop_app/provider/auth_provider_firebase.dart';
import '/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount; // total amount of the order
  final List<CartItem> products;
  final DateTime orderDate;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.orderDate,
  });
}

class OrderProvider with ChangeNotifier {
  final AuthProviderFirebase authProviderFirebase;

  OrderProvider({required this.authProviderFirebase});

  List<OrderItem> _orders = [];
  final url =
      "https://shop-app-a8b3b-default-rtdb.firebaseio.com/orders";

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse("$url/${authProviderFirebase.userId}.json?auth=${await authProviderFirebase.getToken()}"),
        body: json.encode({
          "amount": amount,
          "order_date": timestamp.toIso8601String(),
          "products": products
              .map(
                (product) => {
                  "id": DateTime.now().toIso8601String(),
                  "title": product.title,
                  "price": product.price,
                  "quantity": product.quantity,
                  "image_url": product.imageUrl,
                },
              )
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: amount,
          products: products,
          orderDate: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(Uri.parse("$url/${authProviderFirebase.userId}.json?auth=${await authProviderFirebase.getToken()}"));
      List<OrderItem> loadedItems = [];

      if (json.decode(response.body) == null) {
        return;
      }
      final decodedItems = json.decode(response.body) as Map<String, dynamic>;
      decodedItems.forEach((orderId, order) {
        loadedItems.add(
          OrderItem(
            id: orderId,
            amount: order["amount"],
            products: (order["products"] as List<dynamic>)
                .map(
                  (product) => CartItem(
                    id: product["id"],
                    title: product["title"],
                    quantity: product["quantity"],
                    price: product["price"],
                    imageUrl: product["image_url"],
                  ),
                )
                .toList(),
            orderDate: DateTime.parse(order['order_date']),
          ),
        );
      });
      _orders = loadedItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
