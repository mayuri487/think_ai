import 'package:flutter/material.dart';

import './screens/tabs_screen.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
        canvasColor: Colors.grey[100],
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(color: Colors.indigo)
        )
      ),
      home: TabsScreen(),
      
    );
  }
}