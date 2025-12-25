import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_route.dart';
import 'package:shop_app/provider/auth_provider_firebase.dart';
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
          Divider(color: Colors.lime),
          Expanded(
            child: ListView(
              children: [
                buildListTile(Icons.home, "Home", () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil("/", (route) => false);
                }),
                Container(
                  margin: const EdgeInsets.only(left: 60),
                  child: Divider(),
                ),
                buildListTile(Icons.bookmark_border_rounded, "Orders", () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(OrderScreen.routeName);
                  // Navigator.of(context).push(
                  //   CustomRoute(
                  //     builder: (ctx) => OrderScreen(),
                  //     settings: null,
                  //   ),
                  // );
                }),
                Container(
                  margin: const EdgeInsets.only(left: 60),
                  child: Divider(),
                ),
                buildListTile(Icons.edit, "Manage Products", () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(UserProductsScreen.routeName);
                }),
                Container(
                  margin: const EdgeInsets.only(left: 60),
                  child: Divider(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: .end,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/");
                    Provider.of<AuthProviderFirebase>(
                      context,
                      listen: false,
                    ).logout();
                  },
                  tileColor: Colors.redAccent,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  trailing: Icon(Icons.logout, size: 25),
                ),
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
