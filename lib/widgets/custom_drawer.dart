import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Image.asset("assets/images/woman.png"),
          ),
          Divider(color: Colors.lime,),
          Expanded(
            child: ListView(
              children: [
                buildListTile(Icons.home, "Home", () {
                  Navigator.of(context).pushReplacementNamed("/");
                }),
                Container(margin: const EdgeInsets.only(left: 60),child: Divider()),
                buildListTile(Icons.bookmark_border_rounded, "Orders", () {
                  Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
                }),
                Container(margin: const EdgeInsets.only(left: 60),child: Divider()),
                buildListTile(Icons.edit, "Manage Products", () {
                  Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
                }),
                Container(margin: const EdgeInsets.only(left: 60),child: Divider()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell buildListTile(
    IconData icon,
    String title,
    VoidCallback itemSelectedHandler,
  ) {
    return InkWell(
      onTap: itemSelectedHandler,
      child: ListTile(
        leading: Icon(icon, size: 25),
        title: Text(title, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
