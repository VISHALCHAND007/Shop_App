import 'package:flutter/material.dart';

import '../widgets/grid_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop App")),
      body: GridItem(),
    );
  }
}


