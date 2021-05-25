import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart'
    show
        Cart; // to tell dart i just interested with Cart not cart item which i make another widget by same name
import 'package:provider/provider.dart';
import 'package:shopapp/providers/location.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/lastOrderScreen.dart';
import 'package:shopapp/widgets/cart_item_view.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: cart.totalAmount != 0
          ? Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          height: 40,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 15,
                                child: FittedBox(child: Text('Green')),
                              ),
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
                SizedBox(width: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => CartItemView(
                      key: ValueKey(
                        cart.items.keys.toList()[i],
                      ),
                      title: cart.items.values.toList()[i].title,
                      // where items is map and i interested with its value i make items.value and convert to list so i can used index on it
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      price: cart.items.values.toList()[i].price,
                      qty: cart.items.values.toList()[i].qty,
                      imageUrl: cart.items.values.toList()[i].imageUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Card(
                    margin: EdgeInsets.all(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor)),
                        Spacer(),
                        Chip(
                          label: Text(
                            ' ${cart.totalAmount}EGP',
                            // ignore: deprecated_member_use
                            style: Theme.of(context).textTheme.title,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        MakeOrder(cart: cart)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          : ImageContainer(),
    );
  }
}

class MakeOrder extends StatefulWidget {
  const MakeOrder({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });

              try {
                //  await
//                Provider.of<Orders>(context, listen: false).addNewOrder(
//                  widget.cart.items.values.toList(),
//                  // we transfer cart.items from map to its value to list so we can index inside it
//                  widget.cart.totalAmount,
//                );
                orderNo = await Provider.of<Orders>(context, listen: false)
                    .generateOderNo();
                Provider.of<Location>(context).restoreLocationInfo();

                Navigator.of(context).pushReplacementNamed(
                    LastOrderScreen.routeName,
                    arguments: {
                      'totalAmount': widget.cart.totalAmount,
                      'orderNo': orderNo
                    });
                //widget.cart.clearCart();
              } catch (_) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Some thing went wrong! Please check internet connection...'),
                ));
                setState(() {
                  isLoading = false;
                });
              }
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(fontSize: 12),
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}

class ImageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('your loader is Empty')),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/0.gif'),
          fit: BoxFit.fill,
        ),
      ),
      constraints: BoxConstraints.expand(),
    );
  }
}
