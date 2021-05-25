import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/requests_screen.dart';
import 'package:shopapp/screens/set_location.dart';
import 'package:shopapp/screens/product_mange_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/userRequestsStatus.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<Auth>(context, listen: false).userName;
    return Container(
      height: double.infinity,
      width: 180,
      child: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: FittedBox(child: Text('Hello $userName')),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop, color: Theme.of(context).primaryColor),
              title: Text(
                'Shop',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  '/',
                );
              },
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(Icons.payment, color: Theme.of(context).primaryColor),
              title: Text(
                'Orders',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              title: Text(
                'Manage Products',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProductManageScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_city,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Change Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(SetLocation.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(Icons.reorder, color: Theme.of(context).primaryColor),
              title: Text(
                'Requests',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  RequestsScreen.routeName,
                );
              },
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(Icons.reorder, color: Theme.of(context).primaryColor),
              title: Text(
                'Requests Status',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  UserRequestsStatus.routeName,
                );
              },
            ),
            Divider(),
            ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: Theme.of(context).errorColor),
              title: Text(
                'Log Out',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => Center(
                          child: AlertDialog(
                            title: Center(
                                child: Text(
                              'Are you sure you want to.'
                              '                Log Out',
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            )),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                                onPressed: () {
                                  Provider.of<Auth>(context, listen: false)
                                      .logOut();
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'No',
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                            ],
                          ),
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
