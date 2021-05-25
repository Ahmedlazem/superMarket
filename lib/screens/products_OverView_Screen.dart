import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/offlineWidget.dart';
import 'package:shopapp/widgets/product_grid.dart';
import 'package:shopapp/providers/cart.dart';
import 'splash_screen.dart';

enum FiltersOption { Offer, All }

bool showFavorite = false;

bool isLocationOk;
Future<bool> isGpsOn;

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  String selectedCat = 'Beverages';

  final categories = const [
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

  Future<void> fetchData(String selectedCat) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchProducts(selectedCat);
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 0))
        .then((value) => fetchData(selectedCat));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Super Market',
          style: TextStyle(fontSize: 17),
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.items.length.toString(),
              child: ch,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FiltersOption val) {
              setState(() {
                if (val == FiltersOption.Offer) {
                  showFavorite = true;
                }
                if (val == FiltersOption.All) {
                  showFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FiltersOption.Offer,
                child: Text('Offer'),
              ),
              PopupMenuItem(
                value: FiltersOption.All,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            height: height / 6.5,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(1),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCat = categories[i];
                      showFavorite = false;
                    });
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(2),
                    child: Stack(
                      // alignment: Alignment.topLeft,
                      children: <Widget>[
                        Container(
                          width: width / 2.4,
                          child: Center(
                            child: Image.asset(
                              'assets/image/${categories[i]}.jpg',
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Text(
                          ' ${categories[i]}',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: Container(
              height: 40,
              //  color: Theme.of(context).primaryColorLight,
              width: double.infinity,
              child: Center(
                child: Text(
                  selectedCat,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: fetchData(selectedCat),
                // ignore: missing_return
                builder: (ctx, snapshotData) {
                  switch (snapshotData.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.none:
                      return SplashScreen();
                    case ConnectionState.done:
                      if (snapshotData.hasError) {
                        return OfflineError();
                      }
                      return ProductGrid(showFavorite);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
