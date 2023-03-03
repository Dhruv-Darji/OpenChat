import 'package:speech_to_text/speech_to_text.dart';
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
  var isListening = false;
  SpeechToText speechToText = SpeechToText();
     
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Container(          
          height: height * 0.65,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 120),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(text,
              style: const TextStyle(
                color:lightText,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                ),
              ),
            )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:AvatarGlow(
        animate: isListening,
        //duration: Duration(milliseconds: 2000),
        glowColor: whatsappcolor,
        repeat: true,
        //repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true, 
        endRadius: 90,
        child:GestureDetector(          
          onTap: () async{
            if(isListening==false){
              setState(() {
                isListening=true;
              });              
              var speechtotextinit = await speechToText.initialize();
              if(speechtotextinit){
                speechToText.listen(
                  onResult: ((result) {
                    setState(() {
                      text=result.recognizedWords;
                    });
                  }),                                    
                );                               
              }         
            }                     
            else{
              setState(() {
                isListening=false;
              });
            }
          },                   
          child:CircleAvatar(
            backgroundColor:whatsappcolor,
            radius: 40,
            child: Icon( isListening==true ?Icons.mic : Icons.mic_none,color: lightText,),
          ),
        ),)
    );
  }
}