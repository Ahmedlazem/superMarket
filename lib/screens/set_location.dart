import 'package:flutter/material.dart';
import 'package:shopapp/providers/location.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/screens/map_screen.dart';

class SetLocation extends StatefulWidget {
  static const routeName = '/set_location';
  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
//  Future<void> _selectOnMap() async {
//    final selectedLocation = await Navigator.of(context).push<LatLng>(
//      MaterialPageRoute(
//        fullscreenDialog: true,
//        builder: (ctx) => MapScreen(),
//      ),
//    );
//    if (selectedLocation == null) {
//      return;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            'Welcome To Green Market',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/image/gps.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            constraints: BoxConstraints.expand(height: 100, width: 100),
          ),
          RoundedButton(
            title: 'Set Location',
            colour: Colors.green,
          )
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour});

  final Color colour;
  final String title;
  // final Function onPressed;

  @override
  Widget build(BuildContext context) {
    Future<void> getlocation() async {
      try {
        await Provider.of<Location>(context, listen: false).getUserLocation();
      } catch (e) {}
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Material(
            elevation: 5.0,
            color: colour,
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              onPressed: () {
                getlocation();
                Navigator.pushNamed(
                  context,
                  MapScreen.routeName,
                );
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text('Please turn On  GPS'),
        ],
      ),
    );
  }
}
