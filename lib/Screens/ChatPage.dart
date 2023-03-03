import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:openchat/Constants/Colors.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var text = 'Press mic to speech.'; 
  var isListening = true;   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themecolor,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,        
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text("OpenChat",style: TextStyle(
          fontWeight: FontWeight.w600,
          color:lightText ,
        ),),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: Text(text,
          style: const TextStyle(
            color:lightText
            ),
          )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:AvatarGlow(
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: whatsappcolor,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true, 
        endRadius: 90,
        child:GestureDetector(
          onTap: (){
            setState(() {
              isListening == false ? isListening =true : isListening =false;
              }
            );    
          }
          ,          
          child:CircleAvatar(
            backgroundColor:whatsappcolor,
            radius: 40,
            child: Icon( isListening==true ?Icons.mic : Icons.mic_none,color: lightText,),
          ),
        ),)
    );
  }
}