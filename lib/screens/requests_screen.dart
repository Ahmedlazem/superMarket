import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/requests.dart';
import 'package:shopapp/widgets/requests_item_view.dart';
import '../widgets/app_drawer.dart';

class RequestsScreen extends StatefulWidget {
  static const routeName = '/requests';

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final requestsStream = Provider.of<Requests>(context).requestsView;
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<dynamic>(
          stream: requestsStream,
          builder: (context, snapshot) {
            List<RequestItem> requestItem = snapshot.data;
            return ListView.builder(
                itemCount: requestItem?.length ?? 0,
                itemBuilder: (ctx, i) {
//RequestItem _requests=requestItem[i];
                  //print('stream still working');
                  return RequestsItemView(
                      key: ValueKey(requestItem[i].orderNo),
                      request: requestItem[i]);
                });
          }),

//      FutureBuilder(
//        future:
//            Provider.of<Orders>(context, listen: false).fetchAndSetRequests(),
//        builder: (ctx, dataSnapShot) {
//          if (dataSnapShot.connectionState == ConnectionState.waiting) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          } else if (dataSnapShot.hasError == true) {
//            return Center(
//              child: OfflineError(),
//            );
//          } else {
//            return Consumer<Orders>(
//              builder: (ctx, orderData, child) => ListView.builder(
//                itemCount: orderData.requests.length,
//                itemBuilder: (ctx, i) =>
//                    RequestsItemView(orderData.requests[i]),
//              ),
//            );
//          }
//        },
//      ),
    );
  }
}
