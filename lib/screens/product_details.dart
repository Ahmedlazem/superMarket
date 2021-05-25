import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routName = '/Product_details';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final productLoaded =
        Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(

      appBar: AppBar(
        title: Text(productLoaded.title),
      ),
      body: SingleChildScrollView(

        child: Column(

          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(productLoaded.imageUrl,fit: BoxFit.cover,),
            ),
            SizedBox(height: 10),
            Text('\$ ${productLoaded.price}'),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                  width: double.infinity,
                  child: Text(productLoaded.description,softWrap: true,),alignment: Alignment.center,),
            ),
          ],
        ),
      ),
    );
  }
}
