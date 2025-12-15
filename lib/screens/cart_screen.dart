import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import '../provider/cart_provider.dart' show CartProvider;
import '../provider/order_provider.dart';
import '../widgets/cart_item.dart';
import '../widgets/not_found.dart';

class CartScreen extends StatelessWidget {
  static final routeName = "/cart";

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var _isLoading = false;

    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cartProvider.getSize > 0
          ? buildCardUI(cartProvider, context, _isLoading)
          : NotFound(
              icon: Icons.shopping_cart_outlined,
              title: "Your cart is empty!",
            ),
    );
  }

  Column buildCardUI(
    CartProvider cartProvider,
    BuildContext context,
    bool isLoading,
  ) {
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
                    "₹${cartProvider.orderTotal.toStringAsFixed(2)}",
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
                OrderButton(cartProvider),
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

class OrderButton extends StatefulWidget {
  final CartProvider cartProvider;

  const OrderButton(this.cartProvider, {super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false).addOrder(
                widget.cartProvider.orderTotal,
                widget.cartProvider.getItems.values.toList(),
              );
              setState(() {
                _isLoading = false;
              });
              //clearing the cart after order
              widget.cartProvider.clearCart();
            },
            child: Text(
              "Order Now",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          );
  }
}
