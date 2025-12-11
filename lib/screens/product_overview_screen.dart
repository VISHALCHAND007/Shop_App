import 'package:flutter/material.dart';

import '../widgets/grid_item.dart';

enum FilterOptions { favourite, all }

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: [
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
              print(value);
            },
          ),
        ],
      ),
      body: GridItem(),
    );
  }
}
