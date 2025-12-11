import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.title),
          leading: IconButton(
            onPressed: () {
              product.toggleFavourite();
            },
            icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_outline,
              color: product.isFavourite?Theme.of(context).primaryColor: null,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart),
            // color: product.isFavourite?Theme.of(context).primaryColor: null,
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
}
