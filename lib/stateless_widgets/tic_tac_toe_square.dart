

import 'package:flutter/material.dart';

class TicTacToeSquare extends StatelessWidget {

  const TicTacToeSquare({
    Key key,
    this.onPressed,
    this.child
  }) : super(key: key);

  final onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {

    return(
        Expanded(
          child: RawMaterialButton(
            constraints: BoxConstraints.expand(),
            fillColor: Colors.white,
            child: child,
            onPressed: onPressed,
            shape: Border.all(
              color: Colors.black,
              width: 8.0,
            )
          )
        )
    );

  }

}