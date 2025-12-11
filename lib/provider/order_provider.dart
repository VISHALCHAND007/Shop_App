import 'package:flutter/widgets.dart';
import '/provider/cart_provider.dart';

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
  final List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  void addOrder(double amount, List<CartItem> products) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().millisecond.toString(),
        amount: amount,
        products: products,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
