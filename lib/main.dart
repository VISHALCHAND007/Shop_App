import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

void main () => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shop App",
      routes: {
        "/": (ctx) => ProductOverviewScreen(),
      },
    );
  }
}
