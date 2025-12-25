import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/custom_drawer.dart';
import './cart_screen.dart';
import '../provider/cart_provider.dart';

import '../widgets/grid_item.dart';

enum FilterOptions { favourite, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product-overview";
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavourites = false;
  var _init = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    try {
      if (_init) {
        setState(() {
          isLoading = true;
        });
        Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).fetchAndSaveProducts().then((_) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
        _init = false;
      }
    } catch(error) {
      _init = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, child) => Badge(
              isLabelVisible: true,
              label: Text(cart.getSize.toString()),
              offset: Offset(-3, 0),
              child: child,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.favourite,
                child: Text("Only Favourites"),
              ),
              PopupMenuItem(value: FilterOptions.all, child: Text("All")),
            ],
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favourite) {
                  showOnlyFavourites = true;
                } else {
                  showOnlyFavourites = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(child: CustomDrawer()),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridItem(showOnlyFavourites: showOnlyFavourites),
    );
  }
}
