
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/stateless_widgets/menu_button.dart';

import 'account_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class Menu extends StatefulWidget {

  Menu({ Key key }) : super(key: key);

  @override
  MenuState createState() => MenuState();

}

class MenuState extends State<Menu> {

  int selectedScreenIndex = 1;

  List<Widget> screens = <Widget>[
    HistoryScreen(),
    SettingsScreen(),
    AccountScreen(),
  ];

  void handleItemTapped(int index) {
    setState(() {
      selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe')
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: screens.elementAt(selectedScreenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            title: Text('Play'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          )
        ],
        currentIndex: selectedScreenIndex,
        onTap: handleItemTapped,
      ),
    );
  }
}