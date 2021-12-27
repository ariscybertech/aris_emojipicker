import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:emoji_picker/emoji_picker.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Emoji Picker Test"),
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