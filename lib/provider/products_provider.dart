import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/640px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy – perfect for winter.',
      price: 19.99,
      imageUrl:
      'https://media.istockphoto.com/id/1249890023/photo/beautiful-yellow-scarf-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=E8TtiVsCG-pCBgZA8J4oB9nUBVYltQh567_sPRSFGSg=',
    ),
    Product(
      id: 'p4',
      title: 'Blue Jeans',
      description: 'Classic blue denim jeans.',
      price: 49.99,
      imageUrl:
      'https://media.gettyimages.com/id/173239968/photo/skinny-tight-blue-jeans-on-white-background.jpg?s=612x612&w=gi&k=20&c=QqoFe-m6N_FQKu6KyDVrHUwmKUyh3nkFK8QbDrl3OVM=',
    ),
    Product(
      id: 'p5',
      title: 'Black Sneakers',
      description: 'Comfortable everyday footwear.',
      price: 89.99,
      imageUrl:
      'https://images.unsplash.com/photo-1552346154-21d32810aba3?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c25lYWtlcnN8ZW58MHx8MHx8fDA%3D',
    ),
    Product(
      id: 'p6',
      title: 'Green Hoodie',
      description: 'A comfy green hoodie for daily wear.',
      price: 39.99,
      imageUrl:
      'https://t4.ftcdn.net/jpg/06/29/64/95/360_F_629649557_HiqFH3QPeFb6aPTnL7E8DPxh1BrEOT6P.jpg',
    ),
  ];

  List<Product> get getProducts {
    return [..._products];
  }

  Product findByInd(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  void addProduct() {
    // do add product
    notifyListeners();
  }
}