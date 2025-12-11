import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../provider/order_provider.dart';
import './provider/cart_provider.dart';
import './screens/cart_screen.dart';

import '/screens/product_details_screen.dart';
import '/screens/product_overview_screen.dart';
import 'provider/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider())
      ],
      child: MaterialApp(
        title: "Shop App",
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.lime,
          primaryColor: Colors.red,
        ),
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
        },
      ),
    );
  }
}
