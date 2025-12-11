import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static final routeName = "/product-details";

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false).findByInd(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
