

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/settings.dart';
import 'package:tic_tac_toe/stateless_widgets/tic_tac_toe_square.dart';
import 'package:tic_tac_toe/stateless_widgets/winner_screen.dart';

class TicTacToeBoard extends StatefulWidget {

  TicTacToeBoard({this.difficultySetting = DifficultySettings.hard, this.numOfPlayers});

  final DifficultySettings difficultySetting;
  final int numOfPlayers;

  @override
  TicTacToeBoardState createState() => TicTacToeBoardState();
}

const double INFINITY = 1.0 / 0.0;

List<int> generateCleanBoard() {
  return List.generate(9, (index) => 0);
}

class TicTacToeBoardState extends State<TicTacToeBoard> {

  int currentPlayer = 1;
  int winnerId = 0;
  int numOfPossibleMoves = 8;
  List<int> board = generateCleanBoard();
  final Random random = new Random();

  // 0 1 2
  // 3 4 5
  // 6 7 8
  static const List<List<int>> possibleWinningMoves = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];

  bool gameIsOver(board) {

    if(getWinner(board) != 0) return true;

    for(int i = 0; i < board.length; i++) {
      if(board[i] == 0) return false;
    }

    return false;
  }

  // This will return 0 if there is no winner otherwise it will return the player that won
  int getWinner(board) {

    for(var movesToCheck in possibleWinningMoves) {

      int startIndex = movesToCheck[0];
      int middleIndex = movesToCheck[1];
      int endIndex = movesToCheck[2];
      int startMove = board[startIndex];
      int middleMove = board[middleIndex];
      int endMove = board[endIndex];

      // If the middle move is 0 then we move to check the next possible winning moves
      if(middleMove == 0) {
        continue;
      }

      // If the middle is not 0 then we know that a player has taken the square and we can check surrounding squares
      if(middleMove == startMove && middleMove == endMove) {
//        Navigator.push(context, MaterialPageRoute<void>(
//            builder: (BuildContext context) {
//              return WinnerScreen(winnerId: middleMove);
//            }
//        ));
        return middleMove;
      }

    }

    // If the middle move does not match any of the surrounding squares then we don't have a winner
    return 0;

  }

  void handlePressed(newMove) {

    if(gameIsOver(board)) {
      return;
    }

    // Update the board
    updateBoard(newMove);

    // Update game state
    if(gameIsOver(board)) {
      setState(() {
        winnerId = getWinner(board);
      });
    } else {
      switchPlayer();
      if(widget.numOfPlayers == 1 && currentPlayer == 2) {
        makeMove();
      }
    };

    setState(() {
      numOfPossibleMoves -= 1;
    });

  }

  void makeMove() {

    switch(widget.difficultySetting) {

      case DifficultySettings.easy: {
        makeEasyMove();
        break;
      }

      case DifficultySettings.medium: {
        makeMediumMove();
        break;
      }

      case DifficultySettings.hard: {
        makeHardMove();
        break;
      }

    }

  }

  // Random
  void makeEasyMove() {
    int move = random.nextInt(8);
    if(board[move] == 0) {
      this.handlePressed(move);
    } else {
      makeEasyMove();
    }
  }

  // Mixed?
  void makeMediumMove() {

  }

  // Best Move - Minimax algorithm
  void makeHardMove() {

    double bestScore = -INFINITY;
    int bestMove = 0;

    for(int i = 0; i < board.length; i++) {

      if(board[i] == 0) {

        board[i] = 2;

//        print('makehardmove');
//        print(i);
//        print(board);

        double miniMaxScore = getMiniMaxScore(board, 0, false);

        print('minimaxscore');
        print(miniMaxScore);

        if(bestScore < miniMaxScore) {
          bestScore = miniMaxScore;
          bestMove = i;
          print('best move');
          print(bestMove);
          
        }

        board[i] = 0;
      }
    }

    if(bestMove != 0) this.handlePressed(bestMove);

  }

  double getMiniMaxScore(board, nodeDepth, isMaxMove) {

    if(getWinner(board) == 1) {
//      return 10 - nodeDepth;
      return 10;
    }

    if(getWinner(board) == 2) {
//      return -10 + nodeDepth;
      return -10;
    }

    double bestScore = isMaxMove ? -INFINITY : INFINITY;

    for(int i = 0; i < board.length; i++) {

      if(board[i] == 0) {

        board[i] = isMaxMove ? 2 : 1;

//        print('minimax');
//        print(i);
//        print(board);
//        print('nodeDepth');
//        print(nodeDepth);

        double miniMaxScore = getMiniMaxScore(board, nodeDepth + 1, !isMaxMove);
//        print('minimaxscore');
//        print(miniMaxScore);

        if(isMaxMove) {
          if(bestScore < miniMaxScore) {
            bestScore = miniMaxScore;
          }
        } else {
          if(bestScore > miniMaxScore) {
            bestScore = miniMaxScore;
          }
        }

        board[i] = 0;

      }

    }

    return bestScore;

  }



  void resetGame() {
    setState(() {
      board = generateCleanBoard();
      winnerId = 0;
      numOfPossibleMoves = 8;
    });
  }

  void switchPlayer() {
    setState(() {
      currentPlayer = currentPlayer == 1 ? 2 : 1;
    });
  }

  void updateBoard(int index) {
    setState(() {
      int move = currentPlayer;
      board[index] = move;
    });
  }

  @override
  Widget build(BuildContext context) {

    print(board);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Header
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if(gameIsOver(board)) Container(
                child: winnerId == 0 ? Text('Draw!') : Text('Winner $winnerId'),
              )
            ]
          )
        ),

        // Board
        Container(
          height: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: Column(
            children: [0, 3, 6].map((startIndex) {

              return Expanded( child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: board.sublist(startIndex, startIndex + 3).asMap().map((index, move) {

                return MapEntry(index, TicTacToeSquare(
                  child: Text('${move == 0 ? '' : move == 1 ? 'x' : 'o'}'),
                  onPressed: () => {
                    if(move == 0) this.handlePressed(startIndex + index)
                  }
                ));

              }).values.toList(),

            ));

          }).toList(),
          )
        ),

        // Footer
        Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded( child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if(gameIsOver(board)) FlatButton(
                      color: Colors.white,
                      onPressed: this.resetGame,
                      child: Text('Play Again'),
                    ),
                  ]
                ))
              ]
            )
        ),
      ],

    );

  }
}
