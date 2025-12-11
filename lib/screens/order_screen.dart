import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart' show OrderProvider;
import 'package:shop_app/widgets/not_found.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static final routeName = "/order-screen";

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your orders")),
      drawer: Drawer(child: CustomDrawer()),
      body: orderProvider.getOrders.isNotEmpty
          ? ListView.builder(
              itemCount: orderProvider.getOrders.length,
              itemBuilder: (ctx, ind) =>
                  OrderItem(order: orderProvider.getOrders[ind]),
            )
          : NotFound(
              icon: Icons.not_interested_sharp,
              title: "No order found!!",
            ),
    );
  }
}
