
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  const Button({
    Key key,
    this.title,
    this.numOfPlayers,
    this.onPressed,
    this.child,
    this.color
  }) : super(key: key);

  final String title;
  final int numOfPlayers;
  final Function onPressed;
  final Widget child;
  final color;

  @override
  Widget build(BuildContext context) {

    Widget flatButtonChild = child;
    if(flatButtonChild == null) {
      flatButtonChild = Text(title);
    }

    return
      Expanded(
        child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0), child: FlatButton(
          child: flatButtonChild,
          onPressed: onPressed,
          color: Theme.of(context).primaryColor
        ))
    );
  }

}