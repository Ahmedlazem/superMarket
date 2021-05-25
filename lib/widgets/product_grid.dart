import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product_item_view.dart';

class ProductGrid extends StatelessWidget {
  final bool showOffer;
  ProductGrid(this.showOffer);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showOffer ? productsData.showOffers : productsData.items;

    return Container(
      child: ListView.builder(
        itemCount: products.length,
        itemExtent:150,
       // padding: EdgeInsets.only(top:1),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            //here we used .value its best scenario for list as we are interested by instantiated value and don't need to create instance
            value: products[index],
            child: ProductItemView(),
          );
        },
      ),
    );
  }
}
