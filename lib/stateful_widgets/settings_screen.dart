

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:tic_tac_toe/constants/settings.dart';
import 'package:tic_tac_toe/stateless_widgets/button.dart';
import 'package:tic_tac_toe/stateless_widgets/setting_row.dart';

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
    'time': 10.0,
    'boardColor': Colors.purpleAccent,

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

    final formatText = (title) => Text(title);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                SettingRow(
                  settingTitle: 'Players',
                  options: {
                    1: formatText('One Player'),
                    2: formatText('Two Player'),
                  },
                  selectedOption: settings['numOfPlayers'],
                  onValueChanged: handleValueChanged('numOfPlayers')
                ),

                if(settings['numOfPlayers'] == 1) SettingRow(
                    settingTitle: 'Difficulty',
                    options: {
                      Difficulties.easy: formatText('Easy'),
                      Difficulties.medium: formatText('Medium'),
                      Difficulties.hard: formatText('Hard'),
                    },
                    selectedOption: settings['difficulty'],
                    onValueChanged: handleValueChanged('difficulty')
                ),

                SettingRow(
                    settingTitle: 'Mode',
                    options: {
                      Modes.classic: formatText('Classic'),
                      Modes.timed: formatText('Timed'),
                    },
                    selectedOption: settings['mode'],
                    onValueChanged: handleValueChanged('mode')
                ),

                if(settings['mode'] == Modes.timed) Slider(
                  value: settings['time'],
                  onChanged: handleValueChanged('time'),
                  min: 10.0,
                  max: 20.0,
                  label: settings['time'].toString(),
                  activeColor: settings['boardColor']
                ),

                Row(
                  children: <Widget>[
                    Button(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text('Board Color'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              color: settings['boardColor'],
                            )
                          )
                        ]
                        ),
                      color: settings['boardColor'],
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  pickerColor: settings['boardColor'],
                                  onColorChanged: handleValueChanged('boardColor'),
                                  enableLabel: true, // only on portrait mode
                                ),
                              ),
                            );
                          }
                        );
                      }
                    )
                  ]
                )

              ],
            )
          ),
          Expanded(
            child: Column(
              children: <Widget>[

                  Row (
                    children: [
                      Button(title: 'Start Game', onPressed: startGame)
                    ]
                  )

              ]
            )
          ),
        ]
    );

  }

}