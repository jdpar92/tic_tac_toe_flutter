

import 'package:flutter/material.dart';

class TicTacToeSquare extends StatelessWidget {

  const TicTacToeSquare({
    Key key,
    this.onPressed,
    this.move,
    this.position,
    this.textColor
  }) : super(key: key);

  final onPressed;
  final int move;
  final int position;
  final textColor;

  @override
  Widget build(BuildContext context) {

    final BorderSide borderSide = BorderSide(
      color: textColor,
      width: 3.0,
    );

    var borders = {
      0: Border(
        right: borderSide,
        bottom: borderSide
      ),
      1: Border(
        right: borderSide,
        bottom: borderSide
      ),
      2: Border(
        bottom: borderSide
      ),
      3: Border(
        right: borderSide,
        bottom: borderSide
      ),
      4: Border(
        right: borderSide,
        bottom: borderSide
      ),
      5: Border(
        bottom: borderSide
      ),
      6: Border(
        right: borderSide
      ),
      7: Border(
        right: borderSide
      ),
      8: Border(),
    };

    return(
        Expanded(
          child: RawMaterialButton(
            constraints: BoxConstraints.expand(),
            fillColor: Theme.of(context).canvasColor,
            child: AnimatedDefaultTextStyle(
              child: Text(
                '${move == 0 ? '' : move == 1 ? 'X' : 'O'}',
                style: TextStyle(
                  color: textColor,
                )
              ),
              curve: Curves.easeInCubic,
              duration: Duration(
                milliseconds: 1000,
              ),
              style: move == 0 ? TextStyle(
                  fontSize: 1,
              ) : TextStyle(
                  fontSize: 85
              ),
            ),
            onPressed: onPressed,
            shape: borders[position]
          )
        )
    );

  }

}