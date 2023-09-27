import 'dart:math';

import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/ant/ant.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';
import 'package:langtons_ant_game/models/grid/grid.dart';

class AntController {
  static int nextId =
      0; // Статическая переменная для хранения следующего идентификатора

  final Ant ant;
  final Grid grid;

  AntController({required this.ant, required this.grid});

  static Ant createDefaultAnt(Cell initialCell) {
    return Ant(
      id: nextId++, // Используем текущее значение nextId и увеличиваем его на 1
      currentCell: initialCell,
    );
  }

  static Ant createRandomAnt(Cell initialCell) {
    List<Color> colorsOfAnt = [Colors.white10, Colors.white30, Colors.white60];
    List<Color> colorsForDeadCell = [
      Colors.red.shade200,
      Colors.red.shade400,
      Colors.red.shade600
    ];
    List<Color> colorsForLifeCell = [
      Colors.green.shade300,
      Colors.green.shade600,
      Colors.green.shade900
    ];
    return Ant(
      id: nextId++,
      currentCell: initialCell,
      isClockwise: Random().nextBool(),
      colorOfAnt: colorsOfAnt[Random().nextInt(colorsOfAnt.length)],
      colorForDeadCell:
          colorsForDeadCell[Random().nextInt(colorsForDeadCell.length)],
      colorForLifeCell:
          colorsForLifeCell[Random().nextInt(colorsForLifeCell.length)],
    );
  }

  void moveNewStyle() {
    int sideId = ant.currentDirection;
    int rowIncrement = 0;
    int colIncrement = 0;
    if (ant.isDiagonalMovement && !ant.isOnlyDiagonalMovement) {
      print('ant.isDiagonalMovement && !ant.isOnlyDiagonalMovement');
      print('sideId = $sideId');
      switch (sideId) {
        case 0:
          rowIncrement = -1;
          break;
        case 1:
          rowIncrement = -1;
          colIncrement = 1;
          break;
        case 2:
          colIncrement = 1;
          break;
        case 3:
          rowIncrement = 1;
          colIncrement = 1;
          break;
        case 4:
          rowIncrement = 1;
          break;
        case 5:
          rowIncrement = 1;
          colIncrement = -1;
          break;
        case 6:
          colIncrement = -1;
          break;
        case 7:
          rowIncrement = -1;
          colIncrement = -1;
          break;
      }
    } else if (ant.isDiagonalMovement && ant.isOnlyDiagonalMovement) {
      // мурoвей двигается по кластическим правилам Лэнгтона но с диагональным движением
      switch (sideId) {
        case 0:
          rowIncrement = -1;
          colIncrement = 1;
          break;
        case 1:
          rowIncrement = 1;
          colIncrement = 1;
          break;
        case 2:
          rowIncrement = 1;
          colIncrement = -1;
          break;
        case 3:
          rowIncrement = -1;
          colIncrement = -1;
          break;
      }
    } else {
      // мурoвей двигается по кластическим правилам Лэнгтона
      switch (sideId) {
        case 0:
          rowIncrement = -1;
          break;
        case 1:
          colIncrement = 1;
          break;
        case 2:
          rowIncrement = 1;
          break;
        case 3:
          colIncrement = -1;
          break;
      }
    }

    int newRow = (ant.currentCell.row + rowIncrement) % grid.rows;
    int newCol = (ant.currentCell.col + colIncrement) % grid.columns;

    // Проверка на выход за границы сетки
    if (newRow < 0) newRow = grid.rows - 1;
    if (newCol < 0) newCol = grid.columns - 1;

    Cell nextCell = grid.cells[newRow][newCol];

    // Сохраняем предыдущую клетку
    Cell previousCell = ant.currentCell;
    // Обновляем текущую клетку муравья
    ant.currentCell = nextCell;
    // Восстанавливаем цвет предыдущей клетки
    switch (previousCell.isAlive) {
    // 0 - мертвая клетка, 1 - живая клетка, 2 - специальная клетка
      case false:
        previousCell.color = ant.colorForDeadCell;
        break;
      case true:
        previousCell.color = ant.colorForLifeCell;
        break;
    }
    switch (nextCell.isAlive) {
      case false:
        handleCell(nextCell, true, ant.colorForLifeCell, ant.isClockwise, 1);
        break;
      case true:
        handleCell(nextCell, false, ant.colorForDeadCell, !ant.isClockwise, 1);
        break;
    }
    // Окрашиваем текущую клетку в цвет муравья
    nextCell.color = ant.colorOfAnt;
  }

  void changeDirection(bool isClockwise, int increment) {
    if (ant.isDiagonalMovement && !ant.isOnlyDiagonalMovement) {
      increment = increment * 2;
      ant.currentDirection = isClockwise
          ? (ant.currentDirection + increment) % 8 // Изменено на 8 направлений
          : (ant.currentDirection - increment + 8) %
          8; // Изменено на 8 направлений
    } else {
      ant.currentDirection = isClockwise
          ? (ant.currentDirection + increment) % 4 // Изменено на 4 направления
          : (ant.currentDirection - increment + 4) %
          4; // Изменено на 4 направления
    }
  }

  void handleCell(Cell cell, bool newStatus, Color newColor,
      bool changeDirectionClockwise, int countChange) {
    cell.isAlive = newStatus;
    cell.color = newColor;
    if (newStatus == true) {
      ant.countOfLiveCell += countChange;
    } else if (newStatus == false) {
      ant.countOfDeadCell += countChange;
    }
    changeDirection(changeDirectionClockwise, 1);
  }

  // создаем муравья
  static Ant createAnt(Cell cell) {
    return Ant(
      currentCell: cell,
    );
  }

// создаем муравья с заданными параметрами
  static Ant createAntWithParams(
      int id,
      Cell cell,
      int currentDirection,
      {bool isClockwise = true, // значение по умолчанию
        bool isDiagonalMovement = false, // значение по умолчанию
        bool isOnlyDiagonalMovement = false, // значение по умолчанию
        Color colorOfAnt = Colors.black,
        Color colorForDeadCell = Colors.red,
        Color colorForLifeCell = Colors.green,
        Color colorForSpecialCell = Colors.blue,}) {
    return Ant(
      id: id,
      currentCell: cell,
      currentDirection: currentDirection,
      isClockwise: isClockwise,
      isDiagonalMovement: isDiagonalMovement,
      isOnlyDiagonalMovement: isOnlyDiagonalMovement,
      colorOfAnt: colorOfAnt,
      colorForDeadCell: colorForDeadCell,
      colorForLifeCell: colorForLifeCell,
      colorForSpecialCell: colorForSpecialCell,
    );
  }
}
