import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItemView extends StatefulWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int qty;
  final String imageUrl;

  CartItemView({
    Key key,
    this.title,
    this.qty,
    this.price,
    this.id,
    this.productId,
    this.imageUrl,
  }) : super(key: key);

  @override
  _CartItemViewState createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
//  List<int> qtyList = [for (var i = 1; i < 100; i += 1) i];
  int newQty;

  @override
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState
    newQty = widget.qty;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure...',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            content:
                Text('Are you sure you want to remove item from Your cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(widget.productId),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(widget.productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            // height: 100,
            width: double.infinity,
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  child: ImageContainer(widget.imageUrl),
                ),
                Container(
                  constraints: BoxConstraints.tightFor(width: 75, height: 30),
                  child: FittedBox(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  width: 50,
                  constraints: BoxConstraints.tightFor(width: 40, height: 100),
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.file_upload,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              newQty = widget.qty + 1;
                              Provider.of<Cart>(context, listen: false)
                                  .updateQty(
                                      price: widget.price,
                                      newQty: newQty,
                                      productId: widget.productId,
                                      title: widget.title,
                                      imageUrl: widget.imageUrl);
                            });
                          },
                        ),
                        Text(
                          '$newQty',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            if (newQty <= 0) {
                              return;
                            }
                            setState(() {
                              newQty = widget.qty - 1;
                              Provider.of<Cart>(context, listen: false)
                                  .updateQty(
                                      price: widget.price,
                                      newQty: newQty,
                                      productId: widget.productId,
                                      title: widget.title,
                                      imageUrl: widget.imageUrl);
                            });
                          },
                          icon: Icon(
                            Icons.file_download,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${widget.price}',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
                Text(
                  '${widget.price * newQty}',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  ImageContainer(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageUrl.isEmpty
              ? AssetImage('assets/image/0.gif')
              : NetworkImage(
                  imageUrl,
                ),
          fit: BoxFit.fill,
        ),
      ),
      //constraints: BoxConstraints.expand(),
    );
  }
}
