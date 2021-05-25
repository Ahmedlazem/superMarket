import 'package:flutter/material.dart';





class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  final String description;
final  String categories;
 int stock;
  bool isOffer ;

  Product(
      {@required this.title,
      @required this.imageUrl,
      @required this.id,
      @required this.description,
      @required this.price,
      @required this.categories,
        this.stock,
      this.isOffer=false,
      });


//  Future<void> toggleFavorite( String authToken, String userId) async {
//    bool lastStatus =isOffer;
//
//    final url = 'https://super-market-53c5d.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
//    isOffer = !isOffer;
//   final response = await http.put(url,
//       body: jsonEncode(
//          isOffer,
//       ));
//
//   notifyListeners();
//   if (response.statusCode >= 400) {
//     print(response.statusCode.toString());
//     isOffer = lastStatus;
//     notifyListeners();
//   }
// }

}
