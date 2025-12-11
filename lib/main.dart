import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/product_details_screen.dart';
import '/screens/product_overview_screen.dart';
import 'provider/products_provider.dart';


void main () => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: "Shop App",
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.lime,
        ),
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
