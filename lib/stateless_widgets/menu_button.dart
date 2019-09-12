

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/stateful_widgets/tic_tac_toe_board.dart';

class MenuButton extends StatelessWidget {

  MenuButton({this.title, this.numOfPlayers});

  final String title;
  final int numOfPlayers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(title),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return TicTacToeBoard(numOfPlayers: numOfPlayers);
                }
            ));
          },
        )
      ]
    );
  }

}