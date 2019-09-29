

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/settings.dart';
import 'package:tic_tac_toe/stateless_widgets/menu_button.dart';

import 'tic_tac_toe_board.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({ Key key }) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();

}

class SettingsScreenState extends State<SettingsScreen> {

  var settings = {

    'difficulty': Difficulties.easy,
    'mode': Modes.classic,
    'numOfPlayers': 1,
    'time': 5,

  };

  Function handleValueChanged(String settingKey) {
    return (var selectedSetting) => {
      setState(() {
        settings[settingKey] = selectedSetting;
      })
    };
  }

  void startGame() {
    Navigator.push(context, MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return TicTacToeBoard(settings: settings);
        }
    ));
  }

  @override
  Widget build(BuildContext context) {

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Players: '),
                      CupertinoSegmentedControl(
                        children: {
                          1: Text('One'),
                          2: Text('Two'),
                        },
                        groupValue: settings['numOfPlayers'],
                        onValueChanged: handleValueChanged('numOfPlayers'),
                      ),
                    ]
                ),

                if(settings['numOfPlayers'] == 1) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Difficulty: '),
                    CupertinoSegmentedControl(
                      children: {
                        Difficulties.easy: Text('easy'),
                        Difficulties.medium: Text('medium'),
                        Difficulties.hard: Text('hard'),
                      },
                      groupValue: settings['difficulty'],
                      onValueChanged: handleValueChanged('difficulty'),
                    ),
                  ]
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Mode: '),
                      CupertinoSegmentedControl(
                        children: {
                          Modes.classic: Text('Classic'),
                          Modes.timed: Text('Timed'),
                        },
                        groupValue: settings['mode'],
                        onValueChanged: handleValueChanged('mode'),
                      ),
                    ]
                ),

                if(settings['mode'] == Modes.timed) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Seconds: '),
                      CupertinoSegmentedControl(
                        children: {
                          5: Text('Five'),
                          10: Text('Ten'),
                        },
                        groupValue: settings['time'],
                        onValueChanged: handleValueChanged('time'),
                      ),
                    ]
                ),

              ],
            )
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MenuButton(title: 'Start', onPressed: startGame),
              ]
            )
          ),
        ]
    );

  }

}