import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const ApiKey = 'AIzaSyDJQSsbtvPPY6WdbHhf9EGi6VyaIG0rpC4';

class Location with ChangeNotifier {
  double lat;
  double long;
  String address;
  String country;
  String gover;
  String city;
  String street;
  bool gpsIsOn;
  double distanceInKilo;
  bool distanceIsOk;

  Future<bool> checkGpsIsOn() async {
    Geolocator geolocator = Geolocator()..isLocationServiceEnabled();

    return gpsIsOn = await geolocator.isLocationServiceEnabled();
  }

  Future<void> getUserLocation() async {
    Geolocator geolocator = Geolocator()..isLocationServiceEnabled();

    gpsIsOn = await geolocator.isLocationServiceEnabled();
    if (gpsIsOn) {
      try {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        lat = position.latitude;
        print(lat);
        long = position.longitude;
        double distanceInMeters =
            await Geolocator().distanceBetween(30.033333, 31.233334, lat, long);

        distanceInKilo = (distanceInMeters / 1000).roundToDouble();

        final String url =
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$ApiKey';

        final location = await http.get(url);
        final locationData = location.body;

        address = jsonDecode(locationData)['results'][0]['formatted_address'];

        street = jsonDecode(locationData)['results'][0]['address_components'][0]
            ['long_name'];
        city = jsonDecode(locationData)['results'][0]['address_components'][1]
            ['long_name'];
        gover = jsonDecode(locationData)['results'][0]['address_components'][2]
            ['long_name'];
        country = jsonDecode(locationData)['results'][0]['address_components']
            [3]['long_name'];
        if (distanceInKilo < 500) {
          print(distanceInKilo);
          distanceIsOk = true;
        } else {
          distanceIsOk = false;
        }
        notifyListeners();
        final userLocation = await SharedPreferences.getInstance();
        final userLocationData = json.encode(
          {
            'address': address,
            'city': city,
            'country': country,
            'gover': gover,
            'street': street,
            'distanceInKilo': distanceInKilo,
          },
        );

        userLocation.setString('userLocationData', userLocationData);
      } catch (error) {
        //print(error);
        //throw error;
      }
    }
  }

  Future<void> updateAddress(double lat, double long) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$ApiKey';

    final location = await http.get(url);
    final locationData = location.body;

    address = jsonDecode(locationData)['results'][0]['formatted_address'];
    double distanceInMeters =
        await Geolocator().distanceBetween(30.033333, 31.233334, lat, long);

    distanceInKilo = (distanceInMeters / 1000).roundToDouble();
    if (distanceInKilo < 500) {
      print(distanceInKilo);
      distanceIsOk = true;
    } else {
      distanceIsOk = false;
    }
    notifyListeners();
    final userLocation = await SharedPreferences.getInstance();
    final userLocationData = json.encode(
      {
        'address': address,
        'city': city,
        'country': country,
        'gover': gover,
        'street': street,
        'distanceInKilo': distanceInKilo,
      },
    );

    userLocation.setString('userLocationData', userLocationData);
  }

  Future<void> restoreLocationInfo() async {
    final userLocation = await SharedPreferences.getInstance();
    if (!userLocation.containsKey('userLocationData')) {
      return;
    }

    final extractedUserLocationData =
        json.decode(userLocation.getString('userLocationData'))
            as Map<String, Object>;

    city = extractedUserLocationData['city'];

    address = extractedUserLocationData['address'];

    gover = extractedUserLocationData['gover'];
    distanceInKilo = extractedUserLocationData['distanceInKilo'];
    country = extractedUserLocationData['country'];
    street = extractedUserLocationData['street'];

    notifyListeners();
  }
}
