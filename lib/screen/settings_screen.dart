import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int rows = 99;
  int columns = 99;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rows'),
              onChanged: (value) {
                setState(() {
                  rows = int.parse(value);
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Columns'),
              onChanged: (value) {
                setState(() {
                  columns = int.parse(value);
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {'rows': rows, 'columns': columns});
              },
              child: Text('Apply'),
            )
          ],
        ),
      ),
    );
  }
}
