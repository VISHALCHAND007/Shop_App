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
    return Scaffold(
      appBar: AppBar(title: Text("Your orders")),
      drawer: Drawer(child: CustomDrawer()),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error == null) {
              //main content
              return Consumer<OrderProvider>(
                builder: (ctx, orderProvider, child) {
                  return orderProvider.getOrders.isNotEmpty
                      ? ListView.builder(
                          itemCount: orderProvider.getOrders.length,
                          itemBuilder: (ctx, ind) =>
                              OrderItem(order: orderProvider.getOrders[ind]),
                        )
                      : NotFound(
                          icon: Icons.not_interested_sharp,
                          title: "No order found!!",
                        );
                },
              );
            } else {
              //error handling
              print(dataSnapshot.error.toString());
              return const Text("Error occurred");
            }
          }
        },
      ),
    );
  }
}
