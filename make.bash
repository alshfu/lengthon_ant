#!/bin/bash

# Create directories
mkdir -p langtons_ant_game/lib/models
mkdir -p langtons_ant_game/lib/screens
mkdir -p langtons_ant_game/lib/services
mkdir -p langtons_ant_game/test

# Create files
echo "// This is the Ant model class file" > langtons_ant_game/lib/models/ant.dart
echo "// This is the Grid model class file" > langtons_ant_game/lib/models/grid.dart
echo "// This is the GameScreen file" > langtons_ant_game/lib/screens/game_screen.dart
echo "// This is the GameService file" > langtons_ant_game/lib/services/game_service.dart
echo "// This is the main file" > langtons_ant_game/lib/main.dart
echo "// This is the widget test file" > langtons_ant_game/test/widget_test.dart

# Create .gitignore
echo ".DS_Store\n.idea/\n.vscode/\n*.iml\n*.o\n*.so\n*.log\n*.apk\n*.map\n*.aab\nbuild/\n.flutter-plugins\n.flutter-plugins-dependencies\n.pub-cache/\n.pub/\n/packages/\nPodfile.lock\nPods/\n.dart_tool/\n.flutter_module_packages/\n.flutter/\nGenerated.xcconfig\nFlutter.podspec\nFlutter/\nFlutter.xcworkspace/\nUserInterfaceState.xcuserstate\nFlutter/Flutter-Debug.xcconfig\nFlutter/Flutter-Release.xcconfig\nFlutter/Flutter-Profile.xcconfig\nFlutter/App.framework/\nFlutter/Flutter.framework/\nFlutter/Dart.framework/\nFlutter/FlutterPluginRegistrant/\nServiceDefinitions.json\nRunner/GeneratedPluginRegistrant.h\nRunner/GeneratedPluginRegistrant.m\n" > langtons_ant_game/.gitignore

# Create pubspec.yaml
echo "name: langtons_ant_game\ndescription: A new Flutter project.\n\nversion: 1.0.0+1\n\nenvironment:\n  sdk: \">=2.7.0 <3.0.0\"\n\ndependencies:\n  flutter:\n    sdk: flutter\n  flame: ^1.0.0\n\ndev_dependencies:\n  flutter_test:\n    sdk: flutter\n\nflutter:\n  uses-material-design: true\n" > langtons_ant_game/pubspec.yaml

# Create README.md
echo "# Langton's Ant Game\n\nThis is a Flutter project that implements the Langton's Ant cellular automaton game using the Flame game engine." > langtons_ant_game/README.md

echo "Project structure created successfully!"
