import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';

class CellPainter extends CustomPainter {
  final Cell cell;

  CellPainter(this.cell);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cell.color
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset(0, 0) & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Возвращает true, чтобы перерисовать, если данные клетки изменились
  }
}

class CellWidget extends StatelessWidget {
  final Cell cell;

  const CellWidget({required this.cell});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CellPainter(cell),
    );
  }
}
