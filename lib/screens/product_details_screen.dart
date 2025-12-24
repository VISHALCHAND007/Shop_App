import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../provider/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static final routeName = "/product-details";

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute
        .of(context)
        ?.settings
        .arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findByInd(productId);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      // appBar: AppBar(title: Text(product.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54
                  ),
                  child: Text(product.title, style: TextStyle(color: Colors.white),),
                ),
                background: Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Text(
                    "Price: ₹${product.price}",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {
                      cart.addItem(
                        productId,
                        product.imageUrl,
                        product.title,
                        product.price,
                      );
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: cart.getItems.containsKey(product.id)
                          ? Theme
                          .of(context)
                          .colorScheme
                          .error
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(product.description, softWrap: true),
            ),
            SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
