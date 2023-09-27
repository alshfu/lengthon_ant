import 'package:flutter/material.dart';
import 'package:langtons_ant_game/models/grid/grid.dart';
import 'package:langtons_ant_game/screen/grid_screen.dart';

class MainScreen extends StatefulWidget {
  final Grid grid = Grid(rows: 199, columns: 199);

  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isDarkMode = false;

  void _resetGrid() {
    setState(() {
      widget.grid.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Стиль для кнопок
    final buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.deepPurple,
      onPrimary: Colors.white,
      textStyle: TextStyle(fontSize: 16),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Langton\'s Ant Game'),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        iconTheme: IconThemeData(color: textColor), toolbarTextStyle: TextTheme(
          headline6: TextStyle(color: textColor, fontSize: 20),
        ).bodyText2, titleTextStyle: TextTheme(
          headline6: TextStyle(color: textColor, fontSize: 20),
        ).headline6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Choose your action',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Text('🐜', style: TextStyle(fontSize: 24)),
              label: Text('Create Ants Manually'),
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GridScreen(
                        grid: widget.grid, screenMode: ScreenMode.CreateAnts),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Text('🐜', style: TextStyle(fontSize: 24)),
              label: Text('Create Random Ants'),
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GridScreen(
                        grid: widget.grid, screenMode: ScreenMode.PlayGame),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Text('🔄', style: TextStyle(fontSize: 24)),
              label: Text('Reset Grid'),
              style: buttonStyle,
              onPressed: _resetGrid,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Text('🌖', style: TextStyle(fontSize: 24)),
              label: Text('Toggle Dark Mode'),
              style: buttonStyle,
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
