import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopapp/providers/location.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/lastOrderScreen.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  static const routeName = '/map_screen';

  final bool isSelecting = true;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      print(_pickedLocation);
    });
  }

  bool comingFromLastOrder;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final location = Provider.of<Location>(context);
    final comingFromLastOrder =
        ModalRoute.of(context).settings.arguments as bool;
    print(comingFromLastOrder);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.add_location),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      location.updateAddress(
                          _pickedLocation.latitude, _pickedLocation.longitude);
                    },
            ),
        ],
      ),
      body: location.gpsIsOn
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: height / 1.7,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2)),
                  child: location.long == null
                      ? Image.asset(
                          'assets/image/maps.png',
                          fit: BoxFit.fill,
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(location.lat, location.long),
                            zoom: 16,
                          ),
                          onTap: widget.isSelecting ? _selectLocation : null,
                          markers: _pickedLocation == null
                              ? null
                              : {
                                  Marker(
                                    markerId: MarkerId('m1'),
                                    position: _pickedLocation,
                                  ),
                                },
                        ),
                ),
                Text(
                  'Set Delivery Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                location.address == null
                    ? Text('Please Open GPS and Mobile Data')
                    : Text(location.address, textAlign: TextAlign.center),
                RaisedButton(
                    child: Text('Confirm Location'),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (comingFromLastOrder) {
                        Navigator.of(context)
                            .pushReplacementNamed(LastOrderScreen.routeName);
                      }
                      if (location.distanceIsOk) {
                        if (comingFromLastOrder) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      } else {
                        await showDialog<Null>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Sorry '),
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            content: Text(
                                'we don\'t have branch in this area yet see you soon'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Okay',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ],
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Please turn on GPS and internet connection ',
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }
}
