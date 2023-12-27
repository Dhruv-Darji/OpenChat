import 'package:flutter/material.dart';
import 'package:openchat/Screens/ChatPage.dart';

main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'OpenChat',
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: const ChatPage(),
  ));
}
