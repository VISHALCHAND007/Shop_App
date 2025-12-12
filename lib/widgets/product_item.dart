import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product.dart';

import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({
    super.key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.title),
          leading: Consumer<Product>(
            builder: (ctx, prod, child) => IconButton(
              onPressed: () {
                prod.toggleFavourite();
              },
              icon: Icon(
                prod.isFavourite ? Icons.favorite : Icons.favorite_outline,
                color: prod.isFavourite ? Theme.of(context).primaryColor : null,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              handleCartClick(cart, product, ScaffoldMessenger.of(context));
            },
            icon: Icon(Icons.shopping_cart),
            color: cart.getItems.containsKey(product.id)
                ? Theme.of(context).primaryColor
                : null,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(
            context,
          ).pushNamed(ProductDetailsScreen.routeName, arguments: product.id),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void handleCartClick(
    CartProvider cart,
    Product product,
    ScaffoldMessengerState scaffoldMessenger,
  ) {
    cart.addItem(product.id, product.imageUrl, product.title, product.price);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text("${product.title} added to cart"),
        // duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: "Remove",
          onPressed: () => cart.removeSingleItem(product.id),
        ),
        showCloseIcon: true,
      ),
    );
  }
}
