import 'package:flutter/material.dart';
import 'package:shopapp/providers/location.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/map_screen.dart';
import 'package:shopapp/providers/auth.dart';

int orderNo;

class LastOrderScreen extends StatefulWidget {
  static const String routeName = '/lastOrder';
  @override
  _LastOrderScreenState createState() => _LastOrderScreenState();
}

class _LastOrderScreenState extends State<LastOrderScreen> {
  double totalAmount;
  bool updateAddress = true;
  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context, listen: false);

    final orderData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    totalAmount = orderData['totalAmount'];
    orderNo = orderData['orderNo'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Submit order'),
      ),
      backgroundColor: Color(0xFFF8FDFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 200,
            constraints: BoxConstraints.expand(height: 195),
            decoration: BoxDecoration(
              color: Color(0xFFE0D7D0),
//                  backgroundBlendMode: BlendMode.lighten,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).splashColor),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Text(
                      'your order info',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 5,
                    indent: 75,
                    thickness: 2,
                    color: Theme.of(context).primaryColor,
                    endIndent: 75,
                  ),
                  Text('Name: ${auth.userName} '),
                  Text('Mobile phone: ${auth.mobileNo}'),
                  Text('Address:  ${location.address}'),
                  Text('Order no: Green-HRG $orderNo'),
                  Text('total amount : $totalAmount')
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.add_location),
                label: Text('change'),
                onPressed: () async {
                  await location.getUserLocation();

                  Navigator.pushNamed(context, MapScreen.routeName,
                      arguments: true);
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.done_outline),
                label: Text('submit'),
                onPressed: () async {
                  try {
                    await Provider.of<Orders>(context, listen: false)
                        .sendRequest(
                            userName: auth.userName,
                            userID: auth.userId,
                            address: location.address,
                            mobileNo: auth.mobileNo,
                            cartProducts: cart.items.values.toList(),
                            cartTotalAmount: totalAmount)
                        .whenComplete(() => {
                              showDialog<Null>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Done'),
                                  backgroundColor:
                                      Theme.of(context).primaryColorLight,
                                  content: Text(
                                      'Your Order No HRG-Market-$orderNo was submitted Successfully and you will notify soon'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Okay'),
                                      onPressed: () {
                                        cart.clearCart();
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          '/',
                                        );
                                      },
                                    )
                                  ],
                                ),
                              )
                            });
                  } catch (e) {
                    throw e;
                  }
                },
              ),
            ],
          ),
          Card(
            color: Color(0xFFE0D7D0),
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Item',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          'Qty',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          'Price',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          'total',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => InsideCart(
                title: cart.items.values.toList()[i].title,
                // where items is map and i interested with its value i make items.value and convert to list so i can used index on it
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                qty: cart.items.values.toList()[i].qty,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsideCart extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int qty;

  InsideCart({
    this.title,
    this.qty,
    this.price,
    this.id,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE0D7D0),
      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          // height: 100,
          width: double.infinity,
          child: Row(
            //textDirection: TextDirection.ltr,
            //textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                constraints: BoxConstraints.tightFor(width: 75, height: 30),
                child: FittedBox(
                  child: Text(
                    title,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Text(
                '$qty',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Text(
                '$price',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).accentColor),
              ),
              Text(
                '${price * qty}',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
