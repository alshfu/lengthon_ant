import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/ant/ant.dart';
import 'package:langtons_ant_game/models/ant/ant_controller.dart';
import 'package:langtons_ant_game/models/ant/create_ant_menu.dart';
import 'package:langtons_ant_game/models/cell/cell.dart';
import 'package:langtons_ant_game/models/grid/grid.dart';

enum ScreenMode {
  CreateAnts,
  PlayGame,
}

class GridScreen extends StatefulWidget {
  final Grid grid;
  final ScreenMode screenMode;

  const GridScreen({required this.grid, required this.screenMode});

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  int steps = 0;
  final Map<int, List<Ant>> antsInCells = {};
  final List<Ant> ants = [];
  Timer? movementTimer;
  Timer? gameOfLifeTimer;
  ScreenMode screenMode = ScreenMode.CreateAnts;
  double speed = 1.0;
  String birthRule = "3";
  String survivalRule = "23";
  int stepsCountForGameOfLife = 0;
  int newAntDirection = 0;

  @override
  @override
  void initState() {
    super.initState();
    birthRule = "3";
    survivalRule = "23";
    if (widget.screenMode == ScreenMode.PlayGame) {
      _createAnts();
    }
  }

  int _countAliveNeighbors(int row, int column) {
    int aliveNeighbors = 0;
    for (int i = 0; i < widget.grid.directions.length; i++) {
      Point<int> direction = widget.grid.directions[i];
      int neighborRow = row + direction.x;
      int neighborColumn = column + direction.y;
      if (widget.grid.gridType == "torus") {
        neighborRow = (neighborRow + widget.grid.rows) % widget.grid.rows;
        neighborColumn =
            (neighborColumn + widget.grid.columns) % widget.grid.columns;
      }
      if (neighborRow >= 0 &&
          neighborRow < widget.grid.rows &&
          neighborColumn >= 0 &&
          neighborColumn < widget.grid.columns) {
        if (widget.grid.cells[neighborRow][neighborColumn].isAlive) {
          aliveNeighbors++;
        }
      }
    }
    return aliveNeighbors;
  }

  void _gameOfLife(String birthRule, String survivalRule) {
    List<int> birthNumbers =
        birthRule.split('').map((e) => int.parse(e)).toList();
    List<int> survivalNumbers =
        survivalRule.split('').map((e) => int.parse(e)).toList();

    countOfSteps = 0;
    List<List<Cell>> tempGrid = List.generate(
        widget.grid.rows,
        (i) => List.generate(
            widget.grid.columns, (j) => Cell.createDefaultCell(i, j)));
    for (int i = 0; i < widget.grid.rows; i++) {
      for (int j = 0; j < widget.grid.columns; j++) {
        int aliveNeighbors = _countAliveNeighbors(i, j);

        if (widget.grid.cells[i][j].isAlive) {
          if (survivalNumbers.contains(aliveNeighbors)) {
            tempGrid[i][j].changeStatus(true);
            tempGrid[i][j].changeColor(Color(Random().nextInt(0xffffffff)));
          } else {
            tempGrid[i][j].changeStatus(false);
            tempGrid[i][j].changeColor(Colors.black);
          }
        } else {
          if (birthNumbers.contains(aliveNeighbors)) {
            tempGrid[i][j].changeStatus(true);
            tempGrid[i][j].changeColor(Color(Random().nextInt(0xffffffff)));
          } else {
            tempGrid[i][j].changeStatus(false);
            tempGrid[i][j].changeColor(Colors.black);
          }
        }
      }
    }

    setState(() {
      for (int i = 0; i < widget.grid.rows; i++) {
        for (int j = 0; j < widget.grid.columns; j++) {
          widget.grid.cells[i][j] = tempGrid[i][j];
        }
      }
    });
  }

  void _newAntFromGameOfLife(int i, int j) {
    ant_id++;
    Ant newAnt = AntController.createAntWithParams(
        ant_id, widget.grid.cells[i][j], newAntDirection);
    ants.add(newAnt);
    newAntDirection = (newAntDirection + 1) % 4;
  }

  void _removeAnts(int i, int j) {
    ants.removeWhere((ant) => ant.currentCell == widget.grid.cells[i][j]);
  }

  void _addAnt(int row, int column) {
    //print('row: $row, col: $column');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAntMenu(),
      ),
    ).then((returnedAnts) {
      if (returnedAnts != null && mounted) {
        setState(() {
          ants.addAll(returnedAnts as List<Ant>);
        });
      }
    });
  }

  void _createAnts() {
    for (int i = 0; i < 101; i++) {
      int row = Random().nextInt(widget.grid.rows);
      int column = Random().nextInt(widget.grid.columns);
      Cell initialCell = widget.grid.cells[row][column];
      Ant ant = AntController.createRandomAnt(initialCell);
      ants.add(ant);
    }
  }

  int countOfSteps = 0;

  void _startAntsMovement() {
    movementTimer =
        Timer.periodic(Duration(milliseconds: 100 ~/ speed), (timer) {
      countOfSteps = countOfSteps + 1;
      //  print('countOfSteps: $countOfSteps' + ' steps: $steps');
      if (countOfSteps == stepsCountForGameOfLife) {
        _gameOfLife(birthRule, survivalRule);
      }
      steps = steps + 1;
      setState(() {
        for (Ant ant in ants) {
          AntController antController =
              AntController(ant: ant, grid: widget.grid);
          antController.moveNewStyle();
        }
      });
    });
  }

  void _stopAnts() {
    movementTimer?.cancel();
    gameOfLifeTimer?.cancel();
  }

  void _pauseAnts() {
    movementTimer?.cancel();
    gameOfLifeTimer?.cancel();
  }

  void _stepForward() {
    setState(() {
      steps = steps + 1;
      for (Ant ant in ants) {
        AntController antController =
            AntController(ant: ant, grid: widget.grid);
        antController.moveNewStyle();
      }
    });
  }

  void _autoPlay() {
    _startAntsMovement();
  }

  void _toggleMode() {
    setState(() {
      if (screenMode == ScreenMode.CreateAnts) {
        screenMode = ScreenMode.PlayGame;
      } else {
        screenMode = ScreenMode.CreateAnts;
      }
    });
  }

  @override
  void dispose() {
    movementTimer?.cancel();
    gameOfLifeTimer?.cancel();
    super.dispose();
  }

  Widget _buildIconButton(
      String iconText, Color color, Function onPressed, String tooltip) {
    return IconButton(
      icon: Text(iconText, style: TextStyle(fontSize: 24, color: color)),
      onPressed: onPressed as void Function()?,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final gridSideLength =
        min(screenWidth, MediaQuery.of(context).size.height - 100);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: Text('Langton\'s Ant Game'),
        actions: [
          IconButton(
            icon: Icon(
              screenMode == ScreenMode.CreateAnts
                  ? Icons.play_arrow
                  : Icons.create,
              color: Colors.white70,
            ),
            onPressed: _toggleMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                // Добавлено для центрирования сетки
                child: SizedBox(
                  width: gridSideLength,
                  height: gridSideLength,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onTapUp: (details) {
                        RenderBox box = context.findRenderObject() as RenderBox;
                        Offset localPosition =
                            box.globalToLocal(details.globalPosition);
                        double cellWidth = gridSideLength / widget.grid.columns;
                        double cellHeight = gridSideLength / widget.grid.rows;
                        int col = (localPosition.dx / cellWidth).floor();
                        int row = (localPosition.dy / cellHeight).floor();
                        _addAnt(row, col);
                      },
                      child: CustomPaint(
                        size: Size(gridSideLength, gridSideLength),
                        painter: GridPainter(widget.grid, _addAnt),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Slider(
              value: speed,
              onChanged: (newSpeed) {
                setState(() {
                  speed = newSpeed;
                  if (movementTimer != null && movementTimer!.isActive) {
                    _stopAnts();
                    _startAntsMovement();
                  }
                });
              },
              min: 0.000001,
              max: 4000.0,
              divisions: 5000,
              label: "Speed: ${speed.toStringAsFixed(1)}x",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  "Number of ants: ${ants.length}"), // Статистика о количестве муравьев
            ),
            // Статистика о количестве клеток
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  "Number of cells: ${widget.grid.rows * widget.grid.columns}"),
            ),
            // Статистика о количестве шагов

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Number of steps: ${steps}"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Number of steps: ${steps}"),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    birthRule = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Birth Rule",
                  hintText: "Enter birth rule for Game of Life",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    survivalRule = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Survival Rule",
                  hintText: "Enter survival rule for Game of Life",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                // когда количество изменяется, шагов в countOfSteps обнуляется
                onChanged: (value) {
                  setState(() {
                    stepsCountForGameOfLife = int.parse(value);
                    countOfSteps = 0;
                  });
                },
                decoration: InputDecoration(
                  labelText: "After how many steps use Game of Life Rule",
                  hintText: "Enter count of steps for Game of Life",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Number of steps: ${steps}"),
            ), // Статистика о количестве шагов
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton('⏹️', Colors.red, _stopAnts, 'Stop'),
            _buildIconButton('⏸️', Colors.orange, _pauseAnts, 'Pause'),
            _buildIconButton('⏭️', Colors.blue, _stepForward, 'Step Forward'),
            _buildIconButton(
                '🆙',
                Colors.blue,
                () => _gameOfLife(birthRule, survivalRule),
                'Implement game of life!'),
            _buildIconButton('▶️', Colors.green, _autoPlay, 'Auto Play'),
          ],
        ),
      ),
    );
  }
}
