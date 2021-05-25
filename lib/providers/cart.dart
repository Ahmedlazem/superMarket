import 'package:flutter/material.dart';

import 'package:shopapp/models/cartItem.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void updateQty({String productId, String title, double price,String imageUrl,int newQty}) {
//  _items.containsKey(productId)
//    // ignore: unnecessary_statements
    if (_items.containsKey(productId))
    _items.update(
        productId,
            (updateCartItem) =>
            CartItem(
                imageUrl: updateCartItem.imageUrl,
                id: updateCartItem.id,
                title: updateCartItem.title,
                price: updateCartItem.price,
                qty: newQty));

    notifyListeners();
  }
    void addNewCartItem(
        {String productId, String title, double price, String imageUrl}) {
      // ignore: unnecessary_statements
      if (_items.containsKey(productId))
        // ignore: unnecessary_statements
        _items.update(
            productId,
                (updateCartItem) =>
                CartItem(
                    imageUrl: updateCartItem.imageUrl,
                    id: updateCartItem.id,
                    title: updateCartItem.title,
                    price: updateCartItem.price,
                    qty: (updateCartItem.qty + 1)));
      else {
        _items.putIfAbsent(
            productId,
                () =>
                CartItem(
                  imageUrl: imageUrl,
                  title: title,
                  price: price,
                  id: DateTime.now().toString(),
                  qty: 1,

                ));

        notifyListeners();
      }
    }
    double get totalAmount {
      var total = 0.0;
      // ignore: non_constant_identifier_names
      _items.forEach((key, CartItem) {
        total += CartItem.price * CartItem.qty;
      });
      return total;
    }
    void deleteItem(productId) {
      _items.remove(productId);
      notifyListeners();
    }
    void clearCart() {
      _items = {};
      notifyListeners();
    }
    void singleItemUpdateQty(productId) {
      if (!_items.containsKey(productId)) {
        return;
      }
      if (_items[productId].qty > 1) {
        _items.update(
            productId,
                (updateCartItem) =>
                CartItem(
                    imageUrl: updateCartItem.imageUrl,
                    id: updateCartItem.id,
                    title: updateCartItem.title,
                    price: updateCartItem.price,
                    qty: (updateCartItem.qty - 1)));
      }
      else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }
