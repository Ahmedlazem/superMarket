import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/add_product__screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/product_item_manage.dart';

class ProductManageScreen extends StatefulWidget {
  static const routeName = '/product-screen';

  @override
  _ProductManageScreenState createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  List<String> categories = const [
    'Beverages',
    'Bakery',
    'Canned',
    'Dairy',
    'Dry',
    'Frozen-Food',
    'Meet',
    'Produce',
    'Cleaners',
    'Paper-Goods',
    'Personal-Care',
    'Other'
  ];
  String selectedCategories= 'Beverages';

  DropdownButton<String> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String cat in categories) {
      var newItem = DropdownMenuItem(
        child: Text(cat),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      autofocus: true,
      icon: Icon(Icons.format_align_justify,size: 20,color: Theme.of(context).accentColor,),

      elevation: 5,
      hint: Text(
        'Urgent select Item Categories',
        softWrap: true,
        style: TextStyle(color: Theme.of(context).errorColor,fontSize: 17),
      ),
      value: selectedCategories,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
        });
      },
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Column(
          children: [
            getCategoriesDropdown(),
            Expanded(
              child: FutureBuilder(
                future: _refreshProducts(context),
                builder: (ctx, snapShot) => snapShot.connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: const EdgeInsets.all(0.1),
                            child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (ctx, i) => ProductItemManage(
                                      id: productsData.items[i].id,
                                      imageUrl: productsData.items[i].imageUrl,
                                      title: productsData.items[i].title,
                                  stock: productsData.items[i].stock,
                                    )),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ));
  }
}
