
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/stateful_widgets/tic_tac_toe_board.dart';
import 'package:tic_tac_toe/stateless_widgets/menu_button.dart';

class Menu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MenuButton(title: 'One Player', numOfPlayers: 1),
          MenuButton(title: 'Two Player', numOfPlayers: 2),
        ]
    );
  }
}