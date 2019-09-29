
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  const MenuButton({
    Key key, this.title,
    this.numOfPlayers,
    this.onPressed
  }) : super(key: key);

  final String title;
  final int numOfPlayers;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(title),
            onPressed: onPressed,
          )
        )
      ]
    );
  }

}