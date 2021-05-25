import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/cart.dart';

class ProductItemView extends StatefulWidget {
  @override
  _ProductItemViewState createState() => _ProductItemViewState();
}

class _ProductItemViewState extends State<ProductItemView> {
  int itemCounter = 0;
  int updatedCounter = 0;
  bool isItemAdd = false;

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);

    // we put listen to false because we used consumer which direct effect on our target widget
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(22), topLeft: Radius.circular(22)),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: ListTile(
                  contentPadding: EdgeInsets.all(1),
                  isThreeLine: true,
                  //   trailing:

                  title: Text(productItem.title),
                  subtitle: Text(productItem.description),
                  leading: Container(
                    width: 100,
                    height: 120,
                    child: Stack(
                      children: <Widget>[
                        ImageContainer(productItem.imageUrl),
                        productItem.isOffer ? Text('🔥') : Text(''),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            ' ${productItem.price} EGP',
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              size: 25,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (itemCounter == 0) {
                                return;
                              } else {
                                setState(() {
                                  itemCounter--;
                                });
                                cart.singleItemUpdateQty(productItem.id);
                              }
                            }),
                        Text('$itemCounter'),
                        IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 25,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (productItem.stock <= 0) {
                                return;
                              }
                              setState(() {
                                itemCounter++;
                              });
                            }),
                        productItem.stock != 0
                            ? FlatButton.icon(
                                //color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (itemCounter > 0) {
                                    updatedCounter =
                                        updatedCounter + itemCounter;
                                    for (int n = 0; n < itemCounter; n++) {
                                      cart.addNewCartItem(
                                          imageUrl: productItem.imageUrl,
                                          price: productItem.price,
                                          productId: productItem.id,
                                          title: productItem.title);
                                    }
                                    setState(() {
                                      isItemAdd = true;
                                      itemCounter = 0;
                                      // ignore: unnecessary_statements
                                      updatedCounter;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  size: 18,
                                  color: Theme.of(context).accentColor,
                                ),
                                label: !isItemAdd
                                    ? Container(
                                        constraints: BoxConstraints.tightFor(
                                            width: 36, height: 35),
                                        child: FittedBox(
                                          child: Text(
                                            'Add',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        constraints: BoxConstraints.tightFor(
                                            width: 50, height: 40),
                                        child: FittedBox(
                                          child: Column(
                                            children: <Widget>[
                                              isItemAdd
                                                  ? Text(
                                                      '$updatedCounter',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                    )
                                                  : Text(''),
                                              Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              )
// need to fix

                            : RaisedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.remove_shopping_cart,
                                  size: 18,
                                ),
                                label: Container(
                                  constraints: BoxConstraints.tightFor(
                                      width: 36, height: 35),
                                  child: FittedBox(
                                    child: Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor),
                                    ),
                                  ),
                                ),
                              ),
                      ]),
                ),
              ),
            ],
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
      child: FadeInImage(
        placeholder: AssetImage('assets/image/fadeImage.png'),
        image: NetworkImage(imageUrl),
        fit: BoxFit.fill,
      ),
      constraints: BoxConstraints.expand(),
    );
  }
}
