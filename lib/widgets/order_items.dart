import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class OrderItems extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItems({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final total = quantity * price;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Image.network(
            imageUrl,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text("$title (₹$price)"),
          subtitle: Text("Total: ₹${total.toStringAsFixed(2)}"),
          trailing: Text("$quantity x"),
        ),
      ),
    );
  }
}
