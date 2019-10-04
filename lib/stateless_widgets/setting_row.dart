


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {

  SettingRow({
    Key key,
    this.settingTitle,
    this.options,
    this.selectedOption,
    this.onValueChanged,
  }) : super(key: key);

  final String settingTitle;
  final options;
  final selectedOption;
  final Function onValueChanged;



  @override
  Widget build(BuildContext context) {

    return Row(
        children: <Widget>[
          Expanded(
            child: CupertinoSegmentedControl(
              children: options,
              borderColor: Theme.of(context).primaryColor,
              selectedColor: Theme.of(context).primaryColor,
              groupValue: selectedOption,
              onValueChanged: onValueChanged,
            )
          ),
        ]
    );

  }

}