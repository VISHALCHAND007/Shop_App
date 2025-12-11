import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import 'product_item.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final products = productProvider.getProducts;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, ind) => ChangeNotifierProvider.value(
        value: products[ind],
        child: ProductItem(
          // id: products[ind].id,
          // title: products[ind].title,
          // imageUrl: products[ind].imageUrl,
        ),
      ),
    );
  }
}
