import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/models/cartItem.dart';

class RequestItem {
  final String id;
  final String userName;
  final String userId;
  final String mobileNo;
  final int orderNo;
  final String address;
  final double amount;
  final DateTime orderTime;
  final bool orderStatus;
  final List<CartItem> products;
  RequestItem(
      {@required this.id,
      @required this.userId,
      @required this.orderStatus,
      @required this.userName,
      @required this.mobileNo,
      @required this.address,
      @required this.orderNo,
      @required this.products,
      @required this.amount,
      @required this.orderTime});
}

class Requests with ChangeNotifier {
  //List<OrderItem> _orders = [];

  final String authToken;
  //final String userId;
  int orderNo;

  Requests(this.authToken, this.requests);

  List<RequestItem> requests = [];

  Future fetchAndSetRequests() async {
    List<RequestItem> loadedRequests = [];
    final url =
        'https://super-market-53c5d.firebaseio.com/rqeuest.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedRequests.add(
        RequestItem(
          userName: orderData['userName'],
          mobileNo: orderData['mobileNo'],
          address: orderData['address'],
          orderNo: orderData['orderNo'],
          userId: orderData['userId'],
          id: orderId,
          orderStatus: orderData['orderStatus'],
          amount: orderData['amount'],
          orderTime: DateTime.parse(orderData['time']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  qty: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    return requests = loadedRequests.reversed.toList();
    //notifyListeners();
  }

  Stream<List<RequestItem>> get requestsView async* {
    yield await fetchAndSetRequests();
    // notifyListeners();
  }

  Future<void> sendResponseRequestToUser(
      {int orderNo, String userId, bool orderStatus}) async {
    final url =
        'https://super-market-53c5d.firebaseio.com/requestStatus/$userId/$orderNo.json?auth=$authToken';
    final timeStamp = DateTime.now();
    await http.patch(
      url,
      body: jsonEncode(
        {
          'orderNo': orderNo,
          'orderStatus': orderStatus,
          'time': timeStamp.toIso8601String(),
        },
      ),
    );
  }
}
