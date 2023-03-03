import 'package:flutter/material.dart';
import 'package:openchat/Screens/ChatPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'OpenChat',
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: ChatPage(),
  ));
}
