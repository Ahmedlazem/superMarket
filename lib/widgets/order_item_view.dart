import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shopapp/providers/orders.dart';

class OrderItemView extends StatefulWidget {
  final OrderItem order;

  OrderItemView(this.order);

  @override
  _OrderItemViewState createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.blueGrey[800],
      margin: EdgeInsets.all(1),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.orderTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              height: min(widget.order.products.length * 20.0 + 80, 150),
              color: Colors.tealAccent,
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.qty}x \$${prod.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.blueGrey,
                            thickness: 0.4,
                            height: 15,
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
    );
  }
}
