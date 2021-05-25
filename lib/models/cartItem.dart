import 'package:flutter/material.dart';
class CartItem  with ChangeNotifier{
  final String id;
  final String title;
  final int qty;
  final double price;
  final String imageUrl;

  CartItem(
      {@required this.id,
        @required this.title,
        @required this.qty,
        @required this.price,this.imageUrl});







}