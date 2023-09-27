import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/ant/ant.dart';

class AntStatisticsScreen extends StatelessWidget {
  final List<Ant> ants;

  AntStatisticsScreen({required this.ants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ant Statistics'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Dead Cells')),
            DataColumn(label: Text('Live Cells')),
            DataColumn(label: Text('Cells Traveled')),
            DataColumn(label: Text('Current Direction')),
            DataColumn(label: Text('Is Clockwise')),
          ],
          rows: ants.map((ant) {
            return DataRow(cells: [
              DataCell(Text(ant.id.toString())),
              DataCell(Text(ant.type)),
              DataCell(Text(ant.countOfDeadCell.toString())),
              DataCell(Text(ant.countOfLiveCell.toString())),
              DataCell(Text(ant.cellsTraveled.toString())),
              DataCell(Text(ant.currentDirection.toString())),
              DataCell(Text(ant.isClockwise ? 'Yes' : 'No')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
