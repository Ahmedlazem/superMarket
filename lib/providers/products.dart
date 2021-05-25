import 'product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  String selectedCat;
  Products(this.authToken, this.userId, this._items);
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get showOffers {
    return _items.where((prod) => prod.isOffer == true).toList();
  }

  Future<void> addProduct(Product product) async {
    try {
      final url =
          'https://super-market-53c5d.firebaseio.com/products.json?auth=$authToken';
      await http
          .post(url,
              body: json.encode({
                'title': product.title,
                'price': product.price,
                'description': product.description,
                'imageUrl': product.imageUrl,
                'creatorId': product.categories,
                'isOffer': product.isOffer,
                'stock': product.stock,
              }))
          .then((response) {
        var newProduct = Product(
          categories: product.categories,
          title: product.title,
          price: product.price,
          isOffer: product.isOffer,
          imageUrl: product.imageUrl,
          description: product.description,
          stock: product.stock,
          id: jsonDecode(response.body)['name'],
        );

        _items.add(newProduct);
        notifyListeners();
      });
    } catch (onError) {
      // by catch error method and print it this will  prevent our from crashing if found error in above future method
      print(onError);
      throw onError;
    }
  }

  Future<void> fetchProducts(String selectedCat) async {
    bool filterByUser = true;
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$selectedCat"' : '';
    var url =
        'https://super-market-53c5d.firebaseio.com/products.json?auth=$authToken&$filterString';
//  Future<void> fetchProducts([bool filterByUser = false]) async {
//    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
//    var url = 'https://super-market-53c5d.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          categories: prodData['creatorId'],
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isOffer: prodData['isOffer'],
          imageUrl: prodData['imageUrl'],
          stock: prodData['stock'],
        ));

        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> replaceAndUpdateByID(String id, Product updatedProduct) async {
    final url =
        'https://super-market-53c5d.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': updatedProduct.title,
          'price': updatedProduct.price,
          'description': updatedProduct.description,
          'imageUrl': updatedProduct.imageUrl,
          'isOffer': updatedProduct.isOffer,
          'creatorId': updatedProduct.categories,
          'stock': updatedProduct.stock,
        }));
    final index = _items.indexWhere((pro) => pro.id == id);
    _items[index] = updatedProduct;
    notifyListeners();
  }

  Future<void> removeById(String id) async {
    final url =
        'https://super-market-53c5d.firebaseio.com/products/$id.json?auth=$authToken';
    var existProductIndex = _items.indexWhere((pro) => pro.id == id);
    Product deleteItem = _items[existProductIndex];
    try {
      _items.removeWhere((pro) => pro.id == id);
      await http.delete(url);

      notifyListeners();
    } catch (_) {
      _items.insert(existProductIndex, deleteItem);
      notifyListeners();
    }
  }
}
