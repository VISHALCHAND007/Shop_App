import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/provider/auth_provider_firebase.dart';

import '../models/temp_product.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  static const baseUrl = "https://shop-app-a8b3b-default-rtdb.firebaseio.com/";
  static const baseUrlUpdated =
      "https://shop-app-a8b3b-default-rtdb.firebaseio.com/products.json";
  List<Product> products = [];
  final AuthProviderFirebase authProvider;

  ProductsProvider({required this.authProvider});

  Future<void> fetchAndSaveProducts() async {
    // final token = await authProvider.getToken();
    try {
      final response = await http.get(Uri.parse("$baseUrlUpdated?auth=${await authProvider.getToken()}"));
      final List<Product> loadedProducts = [];
      if(json.decode(response.body) == null) return;

      final decodedItems = json.decode(response.body) as Map<String, dynamic>;
      decodedItems.forEach((productId, product) {
        loadedProducts.add(
          Product(
            id: productId,
            title: product["title"],
            description: product["description"],
            price: product["price"],
            imageUrl: product["imageUrl"],
            isFavourite: product["is_favourite"]
          ),
        );
      });
      products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Product> get getProducts {
    return [...products];
  }

  List<Product> get getFavourites {
    return products.where((product) => product.isFavourite).toList();
  }

  Product findByInd(String productId) {
    return products.firstWhere((product) => product.id == productId);
  }

  Future<void> addProduct(TempProduct product) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrlUpdated?auth=${await authProvider.getToken()}"),
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "is_favourite": product.isFavourite,
        }),
      );
      var newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      products.add(newProduct);
      // do add product
      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(TempProduct product, String productId) async {
    final updateUrl = "${baseUrl}products/$productId.json?auth=${await authProvider.getToken()}";
    var updatedProduct = Product(
      id: productId,
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavourite: product.isFavourite,
    );
    final oldProdInd = products.indexWhere((prod) => prod.id == productId);
    if (oldProdInd >= 0) {
      await http.patch(
        Uri.parse(updateUrl),
        body: json.encode({
          "title": updatedProduct.title,
          "description": updatedProduct.description,
          "price": updatedProduct.price,
          "imageUrl": updatedProduct.imageUrl,
        }),
      );
      products[oldProdInd] = updatedProduct;
    } else {
      // print("...");
    }
    notifyListeners();
  }

  Future<void> deleteProd(String productId) async {
    final updateUrl = "${baseUrl}products/$productId.json?auth=${await authProvider.getToken()}";
    final productInd = products.indexWhere((prod) => prod.id == productId);
    Product? existingProduct = products[productInd];

    if (productInd >= 0) {
      products.removeAt(productInd);
      notifyListeners();
      try {
        final response = await http.delete(Uri.parse(updateUrl));
        if (response.statusCode >= 400) {
          products.insert(productInd, existingProduct);
          notifyListeners();
          throw HttpException(message: "Deletion Error");
        }
      } catch (error) {
        // print(error);
        rethrow;
      } finally {
        existingProduct = null;
      }
    }
  }
}

// products =  // Product(
//   id: 'p1',
//   title: 'Red Shirt',
//   description:
//       'A bright and stylish red shirt made from premium cotton fabric. '
//       'It offers excellent comfort and breathability, making it perfect for everyday wear. '
//       'The vibrant color adds a bold touch to your outfit, suitable for casual outings, parties, or layering with jackets.',
//   price: 29.99,
//   imageUrl:
//       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// ),
// Product(
//   id: 'p2',
//   title: 'Trousers',
//   description:
//       'A high-quality pair of trousers crafted with durability and comfort in mind. '
//       'These trousers offer a perfect blend of style and functionality, suitable for both office and casual settings. '
//       'The fabric provides a soft feel while maintaining a structured and professional look.',
//   price: 59.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/640px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// ),
// Product(
//   id: 'p3',
//   title: 'Yellow Scarf',
//   description:
//       'A warm, cozy yellow scarf designed to keep you comfortable during chilly weather. '
//       'Made from soft wool-blend material, it provides excellent insulation while remaining light and breathable. '
//       'The bright color adds a cheerful touch to your winter outfits and pairs well with coats, sweaters, and casual wear.',
//   price: 19.99,
//   imageUrl:
//       'https://media.istockphoto.com/id/1249890023/photo/beautiful-yellow-scarf-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=E8TtiVsCG-pCBgZA8J4oB9nUBVYltQh567_sPRSFGSg=',
// ),
// Product(
//   id: 'p4',
//   title: 'Blue Jeans',
//   description:
//       'Classic blue denim jeans designed for durability, comfort, and timeless style. '
//       'Made with high-quality denim fabric that offers a perfect balance of flexibility and structure. '
//       'These jeans fit well with any outfit—casual shirts, hoodies, t-shirts—and are suitable for daily wear.',
//   price: 49.99,
//   imageUrl:
//       'https://media.gettyimages.com/id/173239968/photo/skinny-tight-blue-jeans-on-white-background.jpg?s=612x612&w=gi&k=20&c=QqoFe-m6N_FQKu6KyDVrHUwmKUyh3nkFK8QbDrl3OVM=',
// ),
// Product(
//   id: 'p5',
//   title: 'Black Sneakers',
//   description:
//       'Comfortable black sneakers built for everyday use. '
//       'Featuring a cushioned insole, breathable upper mesh, and a strong rubber sole for grip and durability. '
//       'Perfect for walking, casual outings, gym sessions, or pairing with jeans, shorts, and athleisure wear.',
//   price: 89.99,
//   imageUrl:
//       'https://images.unsplash.com/photo-1552346154-21d32810aba3?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c25lYWtlcnN8ZW58MHx8MHx8fDA%3D',
// ),
// Product(
//   id: 'p6',
//   title: 'Green Hoodie',
//   description:
//       'A soft and comfortable green hoodie designed for daily casual wear. '
//       'Made from warm fleece material that keeps you cozy during cool weather. '
//       'It features a spacious hood, large front pocket, and a relaxed fit—perfect for lounging, travelling, or outdoor activities.',
//   price: 39.99,
//   imageUrl:
//       'https://t4.ftcdn.net/jpg/06/29/64/95/360_F_629649557_HiqFH3QPeFb6aPTnL7E8DPxh1BrEOT6P.jpg',
// ),
