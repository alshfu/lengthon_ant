import 'package:flutter/material.dart';


class Cell {
  //final int numberOfSides;
  bool isAlive;
  Color color = Colors.black87;
  final int timesOfStatusChange;
  int row;
  int col;
  bool hasChanged = false;

  Cell({
    required this.row,
    required this.col,
    //this.numberOfSides = 4,
    this.isAlive = false,
    this.timesOfStatusChange = 0,
    this.hasChanged = false,
  });

  int get x => row;

  int get y => col;

  static Cell createDefaultCell(int row, int col) {

    return Cell(
  //    id: id,
      row: row,
      col: col,
      //numberOfSides: numberOfSides,
    );
  }

  void changeStatus(bool newStatus) {
    this.isAlive = newStatus;
    this.hasChanged = true;
  }

  void changeColor(Color newColor) {
    this.color = newColor;
    this.hasChanged = true;
  }
}

