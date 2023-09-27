import 'dart:math';

import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';

class Grid {
  int rows;
  int columns;
  final String gridType;
  final List<List<Cell>> cells;

  // Добавьте этот список направлений в ваш класс Grid
  final List<Point<int>> directions = [
    Point(-1, 0),   // Верх
    Point(1, 0),    // Низ
    Point(0, -1),   // Лево
    Point(0, 1),    // Право
    Point(-1, 1),   // Верх-право
    Point(1, 1),    // Низ-право
    Point(-1, -1),  // Верх-лево
    Point(1, -1)    // Низ-лево
  ];

  Grid({required this.rows, required this.columns, this.gridType = "torus"})
      : cells = List.generate(rows, (row) {
    return List.generate(columns, (column) {
      int id = row * columns + column; // Уникальный идентификатор для каждой клетки
      return Cell.createDefaultCell(row, column);
    });
  }) {
    // Здесь ищем центральную клетку и меняем её цвет на красный
    int centerRow = (rows / 2).floor();
    int centerColumn = (columns / 2).floor();
    Cell centerCell = cells[centerRow][centerColumn];
    centerCell.color = Colors.red;


  }



  void reset() {
    // Пересоздаем каждую клетку
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        int id = row * columns + column;
        cells[row][column] = Cell.createDefaultCell(row, column);
      }
    }

    // Заново ищем центральную клетку и меняем её цвет на красный
    int centerRow = (rows / 2).floor();
    int centerColumn = (columns / 2).floor();
    Cell centerCell = cells[centerRow][centerColumn];
    centerCell.color = Colors.red;


  }

  Cell getCell(int row, int column) {
    return cells[row][column];
  }

}

class GridPainter extends CustomPainter {
  final Grid grid;

  GridPainter(this.grid, addAnt);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / grid.columns;
    final cellHeight = size.height / grid.rows;

    // Рисуем клетки
    for (int row = 0; row < grid.rows; row++) {
      for (int col = 0; col < grid.columns; col++) {
        final cell = grid.cells[row][col];
        final cellRect = Offset(col * cellWidth, row * cellHeight) & Size(cellWidth, cellHeight);
        canvas.drawRect(cellRect, Paint()..color = cell.color);
        canvas.drawRect(cellRect, Paint()..color = cell.color..style = PaintingStyle.stroke..strokeWidth = 0.5);

      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Возвращает true, чтобы перерисовать, если данные сетки изменились
  }
}



