import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/offlineWidget.dart';
import 'package:shopapp/widgets/order_item_view.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }  else if   (dataSnapShot.hasError == true)
           {
              return Center(
                child: OfflineError(),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) =>
                    ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) =>
                          OrderItemView(orderData.orders[i]),
                    ),
              );
            }
          },
      ),
    );
  }
}
