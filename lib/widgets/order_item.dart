import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/widgets/order_items.dart';

import '../provider/order_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(child: Image.asset("assets/images/order.png"),),
              title: Text(
                DateFormat(
                  "dd/MMM/yyyy hh:mm a",
                ).format(widget.order.orderDate),
              ),
              subtitle: Text("Order total: ₹${widget.order.amount.toStringAsFixed(2)}"),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: isExpanded
                    ? Icon(Icons.keyboard_arrow_down)
                    : Icon(Icons.keyboard_arrow_right),
              ),
            ),
            if (isExpanded)
              SizedBox(
                height: min(widget.order.products.length * 98.0, 300),
                child: ListView.builder(
                  itemBuilder: (ctx, ind) {
                    final products = widget.order.products;
                    return OrderItems(
                      id: widget.order.id,
                      productId: products[ind].id,
                      title: products[ind].title,
                      price: products[ind].price,
                      quantity: products[ind].quantity,
                      imageUrl: products[ind].imageUrl,
                    );
                  },
                  itemCount: widget.order.products.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
