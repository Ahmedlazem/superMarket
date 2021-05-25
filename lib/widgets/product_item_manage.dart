import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class ProductItemManage extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final int stock;

  ProductItemManage({this.id, this.imageUrl, this.title, this.stock});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.5),
      child: Card(
        margin: EdgeInsets.all(0.5),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 40,
          ),
          title: FittedBox(
            child: Text(
              title,
            ),
          ),
          subtitle: Text(
            '$stock',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          trailing: Container(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routName, arguments: id);
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .removeById(id)
                            .then((_) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item was deleted'),
                            ),
                          );
                        });
                      } catch (_) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'delete was field please check your connection'),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
