import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: EdgeInsets.all(1.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        )
      ],
    );
  }
}
