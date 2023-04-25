import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  NavBar({this.selectedIndex, required this.onClicked});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_numbered),
          label: 'Leaderboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Statistics',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Color.fromARGB(255, 142, 16, 221),
      type: BottomNavigationBarType.fixed,
      onTap: onClicked,
    );
  }
}
