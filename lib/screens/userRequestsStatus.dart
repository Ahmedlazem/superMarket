import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/offlineWidget.dart';

import '../widgets/app_drawer.dart';

class UserRequestsStatus extends StatelessWidget {
  static const routeName = '/userRequestStatus';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Request Status'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetStatus(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.hasError == true) {
            return Center(
              child: OfflineError(),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.status.length,
                  itemBuilder: (ctx, i) {
                    return RequestItemViewUser(orderData.status[i]);
                  }),
            );
          }
        },
      ),
    );
  }
}

class RequestItemViewUser extends StatefulWidget {
  final OrderStatus orderStatus;
  RequestItemViewUser(this.orderStatus);

  @override
  _RequestItemViewUserState createState() => _RequestItemViewUserState();
}

class _RequestItemViewUserState extends State<RequestItemViewUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(22),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22), topLeft: Radius.circular(22)),
              child: Card(
                // color: Colors.lightGreen,

                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Order No: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${widget.orderStatus.orderNo}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Order status : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            widget.orderStatus.orderStatus
                                ? Text(
                                    ' Accepted',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      'Rejected',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Order Time: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('dd/MM/yy hh:mm')
                                  .format(widget.orderStatus.orderIssueTime),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          thickness: 2,
          endIndent: 50,
          indent: 50,
          height: 6,
        ),
      ],
    );
  }
}
