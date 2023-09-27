import 'package:flutter/material.dart';
import 'package:langtons_ant_game/screen/main_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    ),
  );
}
