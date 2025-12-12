import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/custom_drawer.dart';
import 'package:shop_app/widgets/not_found.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = "/user-products";

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).getProducts;
    return Scaffold(
      appBar: AppBar(title: Text("Your Products")),
      drawer: Drawer(child: CustomDrawer()),
      body: products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (ctx, ind) => ProductItem(
                  productId: products[ind].id,
                  price: products[ind].price.toString(),
                  title: products[ind].title,
                  imageUrl: products[ind].imageUrl,
                ),
                itemCount: products.length,
              ),
            )
          : NotFound(icon: Icons.not_interested_sharp, title: "Not found!"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String productId;
  final String price;
  final String title;
  final String imageUrl;

  const ProductItem({
    super.key,
    required this.price,
    required this.title,
    required this.imageUrl,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 25,),
      title: Text(title, style: TextStyle(fontSize: 18),),
      subtitle: Text("Price: ₹$price"),
      trailing: Row(
        mainAxisSize: .min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: productId);
            },
            child: Icon(
              Icons.edit,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProductsProvider>(context, listen: false).deleteProd(productId);
            },
            child: Icon(
              Icons.delete,
              size: 25,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
