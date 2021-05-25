import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/location.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/providers/requests.dart';
import 'package:shopapp/screens/lastOrderScreen.dart';
import 'package:shopapp/screens/map_screen.dart';
import 'package:shopapp/screens/requests_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_details.dart';
import 'package:shopapp/screens/add_product__screen.dart';
import 'package:shopapp/screens/product_mange_screen.dart';
import 'package:shopapp/screens/products_OverView_Screen.dart';
import 'package:shopapp/screens/authScreen.dart';
import 'package:shopapp/screens/set_location.dart';
import 'package:shopapp/screens/userRequestsStatus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //final getData= Provider.of<Auth>(context,listen: false).getData();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                // ignore: missing_return
                previousProducts == null ? [] : previousProducts.items),
            // ignore: missing_return
            create: (BuildContext context) {},
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                // ignore: missing_return
                previousOrders == null ? [] : previousOrders.orders),
            // ignore: missing_return
            create: (BuildContext context) {},
          ),
          ChangeNotifierProxyProvider<Auth, Requests>(
            update: (ctx, auth, previousRequests) => Requests(
                auth.token,
                // ignore: missing_return
                previousRequests == null ? [] : previousRequests.requests),
            // ignore: missing_return
            create: (BuildContext context) {},
          ),
          ChangeNotifierProvider(
            create: (ctx) => Location(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Super Market',
            theme: ThemeData(
              primaryColor: Color(0xFFEC616A),
              accentColor: Color(0xFF3D107A),
              backgroundColor: Color(0xFFD1C4B4),
              //backgroundColor: Color(0xFFEFA2A7),
              // canvasColor: Color(0xFFEFA2A7),
              fontFamily: 'Lato',
              textTheme: TextTheme(
                // ignore: deprecated_member_use
                title: TextStyle(
                  fontSize: 14,
                ),
                // ignore: deprecated_member_use
                body1: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF3D107A),
                ),
                // ignore: deprecated_member_use
                body2: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            home: auth.authVerified
                ? ProductsOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              ProductManageScreen.routeName: (ctx) => ProductManageScreen(),
              AddProductScreen.routeName: (ctx) => AddProductScreen(),
              EditProductScreen.routName: (ctx) => EditProductScreen(),
              SetLocation.routeName: (ctx) => SetLocation(),
              LastOrderScreen.routeName: (ctx) => LastOrderScreen(),
              MapScreen.routeName: (ctx) => MapScreen(),
              RequestsScreen.routeName: (ctx) => RequestsScreen(),
              UserRequestsStatus.routeName: (ctx) => UserRequestsStatus(),
            },
          ),
        ));
  }
}
