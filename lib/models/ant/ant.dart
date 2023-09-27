import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';


class Ant {
  int id = 0;
  int countOfDeadCell = 0;
  int countOfLiveCell = 0;
  String type = 'regular';
  Cell currentCell;
  int cellsTraveled = 0;
  int nextDirection = 0;
  int currentDirection = 0;
  bool isClockwise = true;
  bool isDiagonalMovement = false;
  bool isOnlyDiagonalMovement = true;
  Color colorOfAnt = Colors.black;
  Color colorForDeadCell = Colors.red;
  Color colorForLifeCell = Colors.green;
  Color colorForSpecialCell = Colors.blue;
  String symbolOfAnt = 'A';

  Ant({
    this.id=0,
    required this.currentCell,
    this.currentDirection = 0,
    this.isClockwise = true,
    this.isDiagonalMovement = false,
    this.colorOfAnt = Colors.black,
    this.colorForDeadCell = Colors.red,
    this.colorForLifeCell = Colors.green,
    this.colorForSpecialCell = Colors.blue,
    this.isOnlyDiagonalMovement = false,
  });
}


