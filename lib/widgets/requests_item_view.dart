import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/requests.dart';

//enum requestStatus { Accepted, Reject }

class RequestsItemView extends StatefulWidget {
  final RequestItem request;

  RequestsItemView({Key key, this.request}) : super(key: key);

  @override
  _RequestsItemViewState createState() => _RequestsItemViewState();
}

class _RequestsItemViewState extends State<RequestsItemView> {
  var _expanded = false;
  var requestStatus = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(22), topLeft: Radius.circular(22)),
          child: Card(
            color: requestStatus ? Colors.lightGreen[300] : Colors.blueGrey,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  //height: 150,
                  padding: EdgeInsets.all(15),
                  //margin: EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('OrderNo HRG -Market-: ${widget.request.orderNo}'),
                      Text('Client: ${widget.request.userName}'),
                      Text('Mobile No : ${widget.request.mobileNo}'),
                      Text('Address: ${widget.request.address}'),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton.icon(
                              color: Theme.of(context).primaryColorLight,
                              elevation: 2,
                              onPressed: requestStatus
                                  ? () {
                                      Provider.of<Requests>(context)
                                          .sendResponseRequestToUser(
                                              orderNo: widget.request.orderNo,
                                              orderStatus: false,
                                              userId: widget.request.userId);

                                      setState(() {
                                        requestStatus = false;
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(
                                'Reject',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                          RaisedButton.icon(
                            color: Theme.of(context).primaryColorLight,
                            elevation: 2,
                            onPressed: requestStatus
                                ? () {
                                    Provider.of<Requests>(context)
                                        .sendResponseRequestToUser(
                                            orderNo: widget.request.orderNo,
                                            orderStatus: true,
                                            userId: widget.request.userId);

                                    setState(() {
                                      requestStatus = true;
                                    });
                                  }
                                : null,
                            icon: Icon(
                              Icons.done,
                              color: Theme.of(context).primaryColor,
                            ),
                            label: Text(
                              'Accepted',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('\$${widget.request.amount}'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(widget.request.orderTime),
                  ),
                  trailing: IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ),
                if (_expanded)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    height:
                        min(widget.request.products.length * 20.0 + 80, 200),
                    //color: Colors.tealAccent,
                    child: ListView(
                      children: widget.request.products
                          .map(
                            (prod) => Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      prod.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${prod.qty}x \$${prod.price}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  color: Colors.blueGrey,
                                  thickness: 0.4,
                                  height: 8,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Divider(
            color: Theme.of(context).primaryColor,
            height: 5,
            thickness: 3,
            indent: 50,
            endIndent: 50,
          ),
        )
      ],
    );
  }
}
