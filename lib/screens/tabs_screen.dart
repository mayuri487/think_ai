import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import './Info_screen.dart';
import './more_screen.dart';
import './profile_screen.dart';
import './status_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  
   List<Map<String, Object>> _pages;
  var _selectedPageIndex = 0;

   @override
  void initState() {
    _pages = [
      {'page': ProfileScreen(), 'title': 'profile'},
      {'page': InfoScreen(), 'title': 'info'},
      {'page': StatusScreen(), 'title': 'Status'},
      {'page': MoreScreen(), 'title': 'More'}
      
      
    ];
    super.initState();
  }


void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: FloatingNavbar(
        backgroundColor: Colors.white70,
        //selectedBackgroundColor: Colors.black87,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          FloatingNavbarItem(icon: Icons.person, title: 'profile'),
           FloatingNavbarItem(icon: Icons.mail, title: 'Info'),
          FloatingNavbarItem(icon: Icons.graphic_eq, title: 'Status'),
           FloatingNavbarItem(icon: Icons.settings, title: 'More'),
        ],
      ),
      
    );
  }
}