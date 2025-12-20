import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider_firebase.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../provider/order_provider.dart';
import './provider/cart_provider.dart';
import './screens/cart_screen.dart';

import '/screens/product_details_screen.dart';
import '/screens/product_overview_screen.dart';
import 'provider/products_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // var isInit = false;
  // @override
  // void didChangeDependencies() {
  //   if(!isInit) {
  //     isInit = true;
  //     Provider.of<AuthProviderFirebase>(context, listen: false).saveToken();
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProviderFirebase()),
        ChangeNotifierProxyProvider<AuthProviderFirebase, ProductsProvider>(
          update: (ctx, authProvider, previousProducts) =>
              ProductsProvider(authProvider: authProvider),
          create: (ctx) => ProductsProvider(
            authProvider: Provider.of<AuthProviderFirebase>(ctx, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProviderFirebase, OrderProvider>(
          create: (ctx) => OrderProvider(
            authProviderFirebase: Provider.of<AuthProviderFirebase>(
              ctx,
              listen: false,
            ),
          ),
          update: (ctx, authProvider, previousOrder) =>
              OrderProvider(authProviderFirebase: authProvider),
        ),
      ],
      child: Consumer<AuthProviderFirebase>(
        builder: (ctx, authProvider, _) {
          return MaterialApp(
            title: "Shop App",
            theme: ThemeData(
              fontFamily: "Lato",
              primarySwatch: Colors.lime,
              primaryColor: Colors.lightBlue,
            ),
            home: authProvider.isLoggedIn
                ? ProductOverviewScreen()
                : AuthScreen(),
            routes: {
              // "/": (ctx) => ProductOverviewScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
