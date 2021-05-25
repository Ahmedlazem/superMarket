import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const ApiKey = 'AIzaSyDJQSsbtvPPY6WdbHhf9EGi6VyaIG0rpC4';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expireTime;
  String _refreshToken;
  Timer _authTimer;
  String _userName;

  String _mobileNo;

  String get userId {
    return _userId;
  }

  String get userName {
    return _userName;
  }

  bool get authVerified {
    return _token != null;
  }

  String get mobileNo {
    return _mobileNo;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      String userName, String mobileNo) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC95rFLIoxQCYF3zcyb_DffXV5Znu8Yjjw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _refreshToken = responseData['refreshToken'];

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      if (urlSegment == 'signUp') {
        _mobileNo = mobileNo;
        _userName = userName;
        final url =
            'https://super-market-53c5d.firebaseio.com/userData/$userId.json?auth=$_token';
        await http.patch(url,
            body: json.encode(
              {'user name': _userName, 'mobile no': _mobileNo},
            ));
      }
      if (urlSegment == 'signInWithPassword') {
        print('start request user data');
        final url =
            'https://super-market-53c5d.firebaseio.com/userData/$userId.json?auth=$_token';
        final response = await http.get(url);

        _userName = json.decode(response.body)['user name'];
        _mobileNo = json.decode(response.body)['mobile no'];
        print(_mobileNo);
      }
      notifyListeners();
      // setUserData();
      _timerToRefreshToken();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expireTime.toIso8601String(),
          'refreshToken': _refreshToken,
          'userName': _userName,
          'mobile no': _mobileNo,
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(
      String email, String password, String userName, String mobileNo) async {
    return _authenticate(email, password, 'signUp', userName, mobileNo);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
        email, password, 'signInWithPassword', email, password);
  }

  Future<bool> tryAutoLogin() async {
    print('try Auto login Starting');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _token = extractedUserData['token'];
    //print(_token);
    _userId = extractedUserData['userId'];
    _expireTime = expiryDate;
    _refreshToken = extractedUserData['refreshToken'];
    _userName = extractedUserData['userName'];
    _mobileNo = extractedUserData['mobile no'];

    notifyListeners();
//    if (expiryDate.isBefore(DateTime.now())) {
//      await _autoRefreshToken();
//      return true;
//    }
    _timerToRefreshToken();

    return true;
  }

  void logOut() async {
    _userId = null;
    _expireTime = null;
    _token = null;
    _userName = null;
    _mobileNo = null;
    _authTimer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  Future<void> _autoRefreshToken() async {
    final url =
        'https://securetoken.googleapis.com/v1/token?key=AIzaSyC95rFLIoxQCYF3zcyb_DffXV5Znu8Yjjw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'grant_type': 'refresh_token',
            'refresh_token': _refreshToken,
          },
        ),
      );
      final responseData = json.decode(response.body);
      // print(responseData);

      if (responseData['error'] != null) {
        print('error in auto refresh token');
        throw HttpException(responseData['error']['message']);
      }
      _refreshToken = responseData['refresh_token'];
      _token = responseData['id_token'];
      // print(responseData['id_token']);
      _userId = responseData['user_id'];
      _expireTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expires_in'],
          ),
        ),
      );

      notifyListeners();
      _timerToRefreshToken();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expireTime.toIso8601String(),
          'refreshToken': _refreshToken,
          'userName': _userName,
          'mobile no': _mobileNo,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  void _timerToRefreshToken() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = (_expireTime.subtract(
      //make timer to refresh token
      Duration(seconds: 300),
    )).difference(DateTime.now()).inSeconds;
    print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry), _autoRefreshToken);
  }
}
