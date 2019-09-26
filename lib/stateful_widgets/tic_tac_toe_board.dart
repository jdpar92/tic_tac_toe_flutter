

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
  int numOfPossibleMoves = 9;
  List<int> board = generateCleanBoard();
  final Random random = new Random();

  // 0 1 2
  // 3 4 5
  // 6 7 8
  static const List<List<int>> possibleWinningMoves = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];

  // This will return 0 if there is no winner otherwise it will return the player that won
  int getWinner(board) {

    if(numOfPossibleMoves == 0) {
      return 0;
    }

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
    return -1;

  }

  void handlePressed(newMove) {

    if(getWinner(board) > -1) {
      return;
    }

    // Update the board
    updateBoard(newMove);

    setState(() {
      numOfPossibleMoves -= 1;
    });

    // Update game state
    if(getWinner(board) > -1) {
      setState(() {
        winnerId = getWinner(board);
      });
    } else {
      switchPlayer();
      if(widget.numOfPlayers == 1 && currentPlayer == 2) {
        makeMove();
      }
    };

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

    double bestScore = -INFINITY;
    int bestMove = 0;
    int numOfMoves = numOfPossibleMoves;

    for(int i = 0; i < board.length; i++) {

      // If the square is open
      if(board[i] == 0) {

        // Make a move in that square
        board[i] = 2;
        numOfMoves -= 1;

        // Get a score for this move
        double miniMaxScore = getMiniMaxScore(board, 0, true, numOfMoves);

        // Set the best score if the score for this move is higher than the score for the last move
        if(bestScore < miniMaxScore) {
          bestScore = miniMaxScore;
          bestMove = i;
        }

        // Reset the move
        board[i] = 0;
        numOfMoves += 1;

      }
    }

    this.handlePressed(bestMove);

  }

  // Mixed?
  void makeMediumMove() {
    int move = random.nextInt(8);
    if(board[move] == 0) {
      this.handlePressed(move);
    } else {
      makeMediumMove();
    }
  }

  // Best Move - Minimax algorithm
  void makeHardMove() {

    double bestScore = -INFINITY;
    int bestMove = 0;
    int numOfMoves = numOfPossibleMoves;

    for(int i = 0; i < board.length; i++) {

      // If the square is open
      if(board[i] == 0) {

        // Make a move in that square
        board[i] = 2;
        numOfMoves -= 1;

        // Get a score for this move
        double miniMaxScore = getMiniMaxScore(board, 0, false, numOfMoves);

        // Set the best score if the score for this move is higher than the score for the last move
        if(bestScore < miniMaxScore) {
          bestScore = miniMaxScore;
          bestMove = i;
        }

        // Reset the move
        board[i] = 0;
        numOfMoves += 1;

      }
    }

    this.handlePressed(bestMove);

  }

  double getMiniMaxScore(board, nodeDepth, isMaxMove, numOfMoves) {

    int winner = getWinner(board);

    if(winner == 2) {
//      return 10 - nodeDepth;
      return 10.0 - nodeDepth - numOfMoves;
    }

    if(winner == 1) {
//      return -10 + nodeDepth;
      return -10.0 - nodeDepth - numOfMoves;
    }

    // Draw
    if(numOfMoves == 0) {
      return 0;
    }




    double bestScore = isMaxMove ? -INFINITY : INFINITY;

    for(int i = 0; i < board.length; i++) {

      if(board[i] == 0) {

        board[i] = isMaxMove ? 2 : 1;
        numOfMoves -= 1;

        double miniMaxScore = getMiniMaxScore(board, nodeDepth + 1, !isMaxMove, numOfMoves);

        if(isMaxMove) {
          // Return maximum score
          if(bestScore < miniMaxScore) {
            bestScore = miniMaxScore;
          }
        } else {
          // Return minimal score
          if(bestScore > miniMaxScore) {
            bestScore = miniMaxScore;
          }
        }

        // Undo move
        board[i] = 0;
        numOfMoves += 1;

      }

    }

    return bestScore;

  }



  void resetGame() {
    setState(() {
      board = generateCleanBoard();
      winnerId = 0;
      numOfPossibleMoves = 9;
      currentPlayer = 1;
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
              if(getWinner(board) > -1) Container(
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
                    if(getWinner(board) > -1) FlatButton(
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
