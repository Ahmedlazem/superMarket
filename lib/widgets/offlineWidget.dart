import 'package:flutter/material.dart';

class OfflineError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            'you\'re offline. Please'
            ' connect to the internet and '
            'try again',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          child: Text('Retry'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    );
  }
}
