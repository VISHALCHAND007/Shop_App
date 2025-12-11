import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart' show CartProvider;
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static final routeName = "/cart";

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cartProvider.getSize > 0
          ? buildCardUI(cartProvider, context)
          : Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(Icons.shopping_cart, size: 60,),
                  Text(
                    "Your cart is empty!",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
    );
  }

  Column buildCardUI(CartProvider cartProvider, BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text("Total", style: TextStyle(fontSize: 20)),
                Spacer(),
                Chip(
                  label: Text(
                    "₹${cartProvider.orderTotal}",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).primaryTextTheme.titleLarge?.color,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Order Now",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: cartProvider.getSize,
            itemBuilder: (ctx, ind) {
              final cartItem = cartProvider.getItems.values.toList()[ind];
              return CartItem(
                id: cartItem.id,
                productId: cartProvider.getItems.keys.toList()[ind],
                title: cartItem.title,
                imageUrl: cartItem.imageUrl,
                price: cartItem.price,
                quantity: cartItem.quantity,
              );
            },
          ),
        ),
      ],
    );
  }
}
