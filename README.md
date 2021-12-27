# Flutter Emoji Keyboard - Version 0.0.2

[![pub package](https://img.shields.io/pub/v/emoji_picker.svg)](https://pub.dartlang.org/packages/emoji_picker)

A Flutter package that provides an Emoji Keyboard widget.

## Key Features
* View and select 390 emojis
* 6 categories
* Optionally add keywords to recommend emojis
* Material Design and Cupertino mode

## Dependencies
* shared_preferences: [![pub package](https://img.shields.io/pub/v/shared_preferences.svg)](https://pub.dartlang.org/packages/shared_preferences) (to save your Emoji history)

## Usage
To use this plugin, add `emoji_picker` as dependency in your pubspec.yaml file.

## Sample Usage

```
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:emoji_picker/emoji_picker.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Emoji Picker Example",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Emoji Picker Example"),
        ),
        body: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      rows: 3,
      columns: (MediaQuery.of(context).size.width / 40).round(),
      numRecommended: 28,
      buttonMode: defaultTargetPlatform == TargetPlatform.iOS ? ButtonMode.CUPERTINO : ButtonMode.MATERIAL,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }
}
```
See the `example` directory for the complete sample app.
