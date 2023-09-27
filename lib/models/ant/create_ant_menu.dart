import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:langtons_ant_game/models/ant/ant.dart';
import 'package:langtons_ant_game/models/ant/ant_controller.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';

class CreateAntMenu extends StatefulWidget {
  CreateAntMenu();

  @override
  _CreateAntMenuState createState() => _CreateAntMenuState();
}

int ant_id = 0;

class _CreateAntMenuState extends State<CreateAntMenu> {
  // Variables related to ant's properties
  Cell initialCell = Cell.createDefaultCell(0, 0);
  int currentDirection = 0;
  bool isClockwise = true;
  bool isDiagonalMovement = false;
  bool isOnlyDiagonalMovement = false;
  Color colorOfAnt = Colors.black;
  Color colorForDeadCell = Colors.black;
  Color colorForLifeCell = Colors.black;
  Color colorForSpecialCell = Colors.black;
  List<Ant> ants = [];

  // Вынесенные списки направлений
  static const List<String> allDirections = [
    '⬆️ Up Arrow',
    '↗️ Up-Right Arrow',
    '➡️ Right Arrow',
    '↘️ Down-Right Arrow',
    '⬇️ Down Arrow',
    '↙️ Down-Left Arrow',
    '⬅️ Left Arrow',
    '↖️ Up-Left Arrow'
  ];

  static const List<String> limitedDirections = [
    '⬆️ Up Arrow',
    '➡️ Right Arrow',
    '⬇️ Down Arrow',
    '⬅️ Left Arrow',
  ];

  static const List<String> diagonalDirections = [
    '↗️ Up-Right Arrow',
    '↘️ Down-Right Arrow',
    '↙️ Down-Left Arrow',
    '↖️ Up-Left Arrow'
  ];


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ant"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Diagonal Movement Section
          const Text(
            "Movement Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text("Diagonal Movement"),
            value: isDiagonalMovement,
            onChanged: (value) => setState(() => isDiagonalMovement = value),
          ),
          SwitchListTile(
            title: const Text("Only Diagonal Movement"),
            value: isOnlyDiagonalMovement,
            onChanged: (value) => setState(() => isOnlyDiagonalMovement = value),
          ),
          const Divider(),
          // Direction Section
          const Text(
            "Ant Initial Coordinates",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            // вводим координаты муравья
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Row",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final newRow = int.tryParse(value) ?? initialCell.row;
                    setState(() {
                      initialCell = Cell(row: newRow, col: initialCell.col);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Column",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final newCol = int.tryParse(value) ?? initialCell.col;
                    setState(() {
                      initialCell = Cell(row: initialCell.row, col: newCol);
                    });
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: currentDirection,
            items: List.generate(
              isDiagonalMovement ? (isOnlyDiagonalMovement ? 4 : 8) : 4,
                  (index) {
                List<String> directions;
                if (isDiagonalMovement) {
                  if (isOnlyDiagonalMovement) {
                    directions = diagonalDirections;
                  } else {
                    directions = allDirections;
                  }
                } else {
                  directions = limitedDirections;
                }

                return DropdownMenuItem(
                  value: index,
                  child: Text(directions[index]),
                );
              },
            ),
            onChanged: (value) => setState(() => currentDirection = value!),
          ),
          const Divider(),

          // Clockwise Section
          SwitchListTile(
            title: const Text("Is Clockwise"),
            value: isClockwise,
            onChanged: (value) {
              setState(() {
                isClockwise = value;
                colorOfAnt = value ? Colors.white : Colors.black;
              });
            },
          ),
          const Divider(),

          // Color Section
          const Text(
            "Color Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        _buildColorPicker(
          "Color of Ant",
          colorOfAnt,
              (color) => setState(() => colorOfAnt = color),
        ),
          _buildColorPicker(
            "Color for Life Cell",
            colorForLifeCell,
                (color) => setState(() => colorForLifeCell = color),
          ),
          _buildColorPicker(
            "Color for Dead Cell",
            colorForDeadCell,
                (color) => setState(() => colorForDeadCell = color),
          ),
          const Divider(),

          // Ant Actions Section
          const Text(
            "Ant Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 3),
          ElevatedButton(
            onPressed: () {
              // Генерируем случайные цвета для живых и мертвых клеток
              colorForDeadCell = Color.fromRGBO(
                  Random().nextInt(255),
                  Random().nextInt(255),
                  Random().nextInt(255),
                  1);   // генерируем случайный цвет для мертвых клеток
              colorForLifeCell = Color.fromRGBO(  // генерируем случайный цвет для живых клеток
                  Random().nextInt(255),
                  Random().nextInt(255),
                  Random().nextInt(255),
                  1);
            },
            child: const Text("Random Colors for Ants"),
          ),
          const SizedBox(height: 3),
          ElevatedButton(
            onPressed: () {
              ant_id = ant_id + 1;
              ants.add(AntController.createAntWithParams(
                  ant_id,
                  initialCell, // <-- Changed from widget.initialCell
                  currentDirection,
                  isClockwise: isClockwise,
                  isDiagonalMovement: isDiagonalMovement,
                  isOnlyDiagonalMovement: isOnlyDiagonalMovement,
                  colorOfAnt: colorOfAnt,
                  colorForDeadCell: colorForDeadCell,
                  colorForLifeCell: colorForLifeCell,
                  colorForSpecialCell: colorForSpecialCell
              ));
              Navigator.pop(context, ants);
            },
            child: const Text("Create Ant"),
          ),
          const SizedBox(height: 3),
          ElevatedButton(
            onPressed: () {
              // создаем муравьёв с заданными параметрами но со всеми возможными направлениями
              // в зависимости от isDiagonalMovement и isOnlyDiagonalMovement
              for (int i = 0; i < (isDiagonalMovement ? (isOnlyDiagonalMovement ? 4 : 8) : 4); i++) {
                ants.add(AntController.createAntWithParams(
                    ant_id,
                    initialCell,
                    i,
                    isClockwise: isClockwise,
                    isDiagonalMovement: isDiagonalMovement,
                    isOnlyDiagonalMovement: isOnlyDiagonalMovement,
                    colorOfAnt: colorOfAnt,
                    colorForDeadCell: colorForDeadCell,
                    colorForLifeCell: colorForLifeCell,
                    colorForSpecialCell: colorForSpecialCell));
              }
              Navigator.pop(context, ants);
            },
            child: const Text("Create Same Ants but with different directions in same cell"),
          ),
          const SizedBox(height: 3),
          ElevatedButton(
            onPressed: () {
              // создаем муравьёв с заданными параметрами но со всеми возможными направлениями
              // в зависимости от isDiagonalMovement и isOnlyDiagonalMovement
              for (int i = 0; i < (isDiagonalMovement ? (isOnlyDiagonalMovement ? 4 : 8) : 4); i++) {
                print("i = $i");
                ants.add(AntController.createAntWithParams(
                    ant_id,
                    initialCell,
                    i,
                    isClockwise:!isClockwise,
                    isDiagonalMovement:!isDiagonalMovement,
                    isOnlyDiagonalMovement:!isOnlyDiagonalMovement ,
                    colorOfAnt: Color.fromRGBO(
                        Random().nextInt(255),
                        Random().nextInt(255),
                        Random().nextInt(255),
                        1)
                    // random color for dead cell and life cell
                ));
              }
              Navigator.pop(context, ants);
            },
            child: const Text("Create Same Ants but with different directions and colors in same cell"),
          ),
          const SizedBox(height: 3),
          ElevatedButton(
            onPressed: () {
              // создаем муравьёв от клетни с координатами 0,0 до клетки с координатами 198,198, и от 0,198 до 198,0
              for (int i = 0; i < 199; i++) {
                for (int j = 0; j < 199; j++) {
                  ants.add(AntController.createAntWithParams(
                      ant_id,
                      Cell.createDefaultCell(i, j),
                      currentDirection,
                      isClockwise: isClockwise,
                      isDiagonalMovement: isDiagonalMovement,
                      isOnlyDiagonalMovement: isOnlyDiagonalMovement,
                      colorOfAnt: colorOfAnt,
                      colorForDeadCell: colorForDeadCell,
                      colorForLifeCell: colorForLifeCell,
                      colorForSpecialCell: colorForSpecialCell));
                }
              }
              Navigator.pop(context, ants);
            },
            child: const Text("Create Same Ants but with different directions and colors in same cell"),
          ),
        ],
      ),
    );
  }


  Widget _buildColorPicker(String title, Color color, Function(Color) onColorChanged) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: Icon(Icons.color_lens, color: color),
        onPressed: () => _showColorPickerDialog(context, color, onColorChanged),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a color!"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: initialColor,
              onColorChanged: onColorChanged,
            ),
          ),
        );
      },
    );
  }
}