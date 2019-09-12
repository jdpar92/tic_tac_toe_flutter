

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/settings.dart';
import 'package:tic_tac_toe/stateless_widgets/winner_screen.dart';

class TicTacToeBoard extends StatefulWidget {

  TicTacToeBoard({this.numOfPlayers});

  final int numOfPlayers;

  @override
  TicTacToeBoardState createState() => TicTacToeBoardState();
}

class TicTacToeBoardState extends State<TicTacToeBoard> {


  int currentPlayer = 1;
  List<int> moves = List.generate(9, (index) => 0);
  static const List<List<int>> possibleWinningMoves = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8]];

  // This will return 0 if there is no winner otherwise it will return the player that won
  int checkForWinner() {

    for(var movesToCheck in possibleWinningMoves) {

      int startIndex = movesToCheck[0];
      int middleIndex = movesToCheck[1];
      int endIndex = movesToCheck[2];
      int startMove = moves[startIndex];
      int middleMove = moves[middleIndex];
      int endMove = moves[endIndex];

      // If the middle move is 0 then we move to check the next possible winning moves
      if(middleMove == 0) {
        continue;
      }

      // If the middle is not 0 then we know that a player has taken the square and we can check surrounding squares
      if(middleMove == startMove && middleMove == endMove) {
        Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return WinnerScreen(winnerId: middleMove);
            }
        ));
      }

    }

    // If the middle move does not match any of the surrounding squares then we don't have a winner
    return 0;

  }

  void handlePressed(currentMove, newMove) {
    if(currentMove == 0) {
      setMove(newMove);
      checkForWinner();
      switchPlayer();
    }
  }

  void makeMove() {
//
//    switch(widget.difficultySetting) {
//      case DifficultySettings.easy: {
//
//      }
//    }

  }

  void switchPlayer() {
    setState(() {
      currentPlayer = currentPlayer == 1 ? 2 : 1;
    });

//    if(widget.numOfPlayers == 1) {
//      makeMove();
//    }

  }

  void setMove(int index) {
    setState(() {
      int a = currentPlayer;
      moves[index] = a;
    });
  }

  @override
  Widget build(BuildContext context) {

    print(moves);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [0, 3, 6].map((startIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moves.sublist(startIndex, startIndex + 3).asMap().map((index, move) {
            return MapEntry(index, FlatButton(
              color: Colors.white,
              child: Text('${move == 0 ? '' : move == 1 ? 'x' : 'o'}'),
              onPressed: () => handlePressed(move, startIndex + index),
            ));
          }).values.toList(),
        );
      }).toList(),
    );

  }
}