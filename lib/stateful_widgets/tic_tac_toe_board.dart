

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/settings.dart';
import 'package:tic_tac_toe/stateless_widgets/button.dart';
import 'package:tic_tac_toe/stateless_widgets/strike_through.dart';
import 'package:tic_tac_toe/stateless_widgets/tic_tac_toe_square.dart';

class TicTacToeBoard extends StatefulWidget {

  TicTacToeBoard({ Key key, this.settings }) :
    difficulty = settings['difficulty'],
    mode = settings['mode'],
    numOfPlayers = settings['numOfPlayers'],
    time = settings['time'],
    boardColor = settings['boardColor'],
    super(key: key);

  final Map settings;
  final Difficulties difficulty;
  final Modes mode;
  final int numOfPlayers;
  final double time;
  final Color boardColor;

  @override
  TicTacToeBoardState createState() => TicTacToeBoardState();

}

const double INFINITY = 1.0 / 0.0;

List<int> generateCleanBoard() {
  return List.generate(9, (index) => 0);
}

class TicTacToeBoardState extends State<TicTacToeBoard> {

  final Random random = new Random();

  int currentPlayer = 1;
  int winnerId = 0;
  int numOfPossibleMoves = 9;
  List<int> board = generateCleanBoard();
  Stopwatch stopwatch1 = Stopwatch()..start();
  Stopwatch stopwatch2 = Stopwatch();
  bool gameOver = false;

  bool gameIsOver(board) {

    if(gameOver) return true;

    int winner = getWinner(board);

    if(numOfPossibleMoves == 0 || winner > 0) {

      setState(() {
        winnerId = winner;
        gameOver = true;
      });

      return true;

    }

    return false;

  }

  // This will return 0 if there is no winner otherwise it will return the player that won
  // 0 1 2
  // 3 4 5
  // 6 7 8
  static const List<List<int>> possibleWinningMoves = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];
  int getWinner(board) {

    if(widget.mode == Modes.timed) {
      if(stopwatch1.elapsed.inSeconds >= widget.time) return 2;
      if(stopwatch2.elapsed.inSeconds >= widget.time) return 1;
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

    setState(() {
      numOfPossibleMoves -= 1;
    });

    // Update game state
    if(gameIsOver(board)) {

    } else {
      if(widget.numOfPlayers == 1 && currentPlayer == 2) {
        makeMove();
      }
    }

  }

  void makeMove() {

    switch(widget.difficulty) {

      case Difficulties.easy: {
        makeEasyMove();
        break;
      }

      case Difficulties.medium: {
        makeMediumMove();
        break;
      }

      case Difficulties.hard: {
        makeHardMove();
        break;
      }

    }

  }

  // Worst Move
  void makeEasyMove() {
    this.handlePressed(getWorstMove());
  }

  // Random
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
    this.handlePressed(getBestMove());
  }

  int getBestMove() {
    return getMove(false);
  }

  int getWorstMove() {
    return getMove(true);
  }

  int getMove(isMaxMove) {
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
        double miniMaxScore = getMiniMaxScore(board, 0, isMaxMove, numOfMoves);

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

    return bestMove;
  }

  double getMiniMaxScore(board, nodeDepth, isMaxMove, numOfMoves) {

    int winner = getWinner(board);

    // Maximizer wins
    if(winner == 2) {
      return 10.0 - nodeDepth - numOfMoves;
    }

    // Minimizer wins
    if(winner == 1) {
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
      stopwatch1.stop();
      stopwatch2.start();
      currentPlayer = currentPlayer == 1 ? 2 : 1;
    });
  }

  void updateBoard(int index) {
    setState(() {
      int move = currentPlayer;
      board[index] = move;
    });
    switchPlayer();
  }

  @override
  Widget build(BuildContext context) {

    print(stopwatch1.elapsed.inSeconds);
    print(stopwatch2.elapsed.inSeconds);
    bool gameOver = gameIsOver(board);

    return CustomPaint(
        foregroundPainter: StrikeThrough(),
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Theme.of(context).canvasColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: AnimatedDefaultTextStyle(
                        child: Text(
                          '${winnerId == 0 ? 'Stale Mate!' : winnerId == 1 ? 'You Win!' : 'You Lose!'}',
                          style: TextStyle(color: widget.boardColor)
                        ),
                        curve: Curves.easeInCubic,
                        duration: Duration(
                          milliseconds: 1000,
                        ),
                        style: gameOver
                          ? TextStyle(fontSize: 50)
                          : TextStyle(fontSize: 0),
                      )

                    )
                  ]
                )
              ),

              // Board
              Container(
                height: MediaQuery.of(context).size.width - 8.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.boardColor,
                      blurRadius: 20.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [0, 3, 6].map((startIndex) {

                    return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: board.sublist(startIndex, startIndex + 3).asMap().map((index, move) {

                            int position = startIndex + index;

                            return MapEntry(index, TicTacToeSquare(
                              position: position,
                              move: move,
                              onPressed: () => {
                                if(move == 0) this.handlePressed(position)
                              },
                              textColor: widget.boardColor,
                            ));

                          }).values.toList(),

                        )
                    );

                }).toList(),
              )
            ),

            // Footer
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      Button(
                        title: 'Back',
                        onPressed: () => Navigator.pop(context),
                      ),


                      Button(
                        title: gameOver ? 'Play Again' : 'Start Over',
                        onPressed: this.resetGame,
                      )

                    ]
                  ),

                ]
              )
            ),
          ],
          )
        )
    );

  }
}
