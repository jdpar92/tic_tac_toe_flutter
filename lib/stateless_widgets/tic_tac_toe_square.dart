

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
            fillColor: Color(0xff2EC4B6),
            child: child,
            onPressed: onPressed,
            shape: Border.all(
              color: Color(0xff011627),
              width: 8.0,
            )
          )
        )
    );

  }

}