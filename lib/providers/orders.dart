import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/models/cartItem.dart';

const ApiKey = 'AIzaSyDJQSsbtvPPY6WdbHhf9EGi6VyaIG0rpC4';

class OrderStatus {
  final String id;
  final bool orderStatus;
  final int orderNo;
  final DateTime orderIssueTime;
  OrderStatus({this.orderNo, this.orderStatus, this.orderIssueTime, this.id});
}

class OrderItem {
  final String id;
  final double amount;
  final DateTime orderTime;
  final List<CartItem> products;
  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.orderTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderStatus> _status = [];
  final String authToken;
  final String userId;
  int orderNo;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderStatus> get status {
    return [..._status];
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    List<OrderItem> loadedOrders = [];
    final url =
        'https://super-market-53c5d.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
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
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addNewOrder(
      List<CartItem> cartProducts, double cartTotalAmount) async {
    final url =
        'https://super-market-53c5d.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: jsonEncode({
          'amount': cartTotalAmount,
          //  'orderStatus':orderStatus,
          'time': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((pro) => {
                    'id': pro.id,
                    'quantity': pro.qty,
                    'title': pro.title,
                    'price': pro.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: jsonDecode(response.body)['name'],
            products: cartProducts,
            amount: cartTotalAmount,
            orderTime: timeStamp));
    notifyListeners();
  }

  Future<int> generateOderNo() async {
    var url =
        'https://super-market-53c5d.firebaseio.com/orderNo.json?auth=$authToken';

    final getNo = await http.get(url);
    final orderData = getNo.body;
    orderNo = jsonDecode(orderData)['orderNo'] + 1;

    await http.put(url,
        body: jsonEncode({
          'orderNo': orderNo,
        }));
    notifyListeners();
    return orderNo;
  }

  Future<void> sendRequest(
      {List<CartItem> cartProducts,
      String address,
      String mobileNo,
      String userID,
      String userName,
      double cartTotalAmount}) async {
    final url =
        'https://super-market-53c5d.firebaseio.com/rqeuest.json?auth=$authToken';
    final timeStamp = DateTime.now();
    await http.post(url,
        body: jsonEncode({
          'userName': userName,
          'address': address,
          'mobileNo': mobileNo,
          'orderNo': orderNo,
          'userId': userId,
          'amount': cartTotalAmount,
          'time': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((pro) => {
                    'id': pro.id,
                    'quantity': pro.qty,
                    'title': pro.title,
                    'price': pro.price,
                  })
              .toList(),
        }));
  }

  Future<void> fetchAndSetStatus() async {
    try {
      final List<OrderStatus> loadedStatus = [];
      final url =
          'https://super-market-53c5d.firebaseio.com/requestStatus/$userId.json?auth=$authToken';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedStatus.add(
          OrderStatus(
            id: orderId,
            orderNo: orderData['orderNo'],
            orderIssueTime: DateTime.parse(orderData['time']),
            orderStatus: orderData['orderStatus'],
          ),
        );
      });

      _status = loadedStatus.reversed.toList();

      notifyListeners();
      //print(orderStatus);

    } catch (e) {
      throw e;
    }
  }
}
//  Future<void> sendRequest(
//      {List<CartItem> cartProducts,
//      String address,
//      String mobileNo,
//      String userID,
//      String userName,
//      double cartTotalAmount}) async {
//    final url =
//        'https://super-market-53c5d.firebaseio.com/rqeuest.json?auth=$authToken';
//    final timeStamp = DateTime.now();
//    final response = await http.post(url,
//        body: jsonEncode({
//          'userName': userName,
//          'address': address,
//          'mobileNo': mobileNo,
//          'orderNo': orderNo,
//          'userId': userID,
//          'amount': cartTotalAmount,
//          'time': timeStamp.toIso8601String(),
//          'products': cartProducts
//              .map((pro) => {
//                    'id': pro.id,
//                    'quantity': pro.qty,
//                    'title': pro.title,
//                    'price': pro.price,
//                  })
//              .toList(),
//        }));
//  }
//
//  Future fetchAndSetRequests() async {
//    List<RequestItem> loadedRequests = [];
//    final url =
//        'https://super-market-53c5d.firebaseio.com/rqeuest.json?auth=$authToken';
//    final response = await http.get(url);
//    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
//    if (extractedData == null) {
//      return;
//    }
//    extractedData.forEach((orderId, orderData) {
//      loadedRequests.add(
//        RequestItem(
//          userName: orderData['userName'],
//          mobileNo: orderData['mobileNo'],
//          address: orderData['address'],
//          orderNo: orderData['orderNo'],
//          userId: orderData['userId'],
//          id: orderId,
//          amount: orderData['amount'],
//          orderTime: DateTime.parse(orderData['time']),
//          products: (orderData['products'] as List<dynamic>)
//              .map(
//                (item) => CartItem(
//                  id: item['id'],
//                  price: item['price'],
//                  qty: item['quantity'],
//                  title: item['title'],
//                ),
//              )
//              .toList(),
//        ),
//      );
//    });
//    return requests = loadedRequests.reversed.toList();
//    notifyListeners();
//  }
//
//  Stream<List<RequestItem>> get requestsView async* {
//    yield await fetchAndSetRequests();
//    notifyListeners();
//  }
//
//  Future <void> sendRequestResponseToUser(){
//
//  }
