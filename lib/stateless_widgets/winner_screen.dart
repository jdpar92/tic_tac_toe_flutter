

import 'package:flutter/material.dart';

class WinnerScreen extends StatelessWidget {

  WinnerScreen({this.winnerId});

  final int winnerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Summary')),
      body: Text('winner $winnerId')
    );
  }


}