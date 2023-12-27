import 'package:flutter/material.dart';
import 'package:openchat/Constants/Colors.dart';
import 'package:openchat/Services/api_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Constants/loadingIcon.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  bool _emptyText = true;
  bool _micStatus = false;
  SpeechToText _speechToText = SpeechToText();
  final GeminiService geminiService = GeminiService();
  final TextEditingController userText = TextEditingController();
  String responseText = '';
  String question = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _micStatus = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async{
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
    });
  }
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result){
    setState(() {
      userText.text = result.recognizedWords;
      _emptyText = false;
    });
    if(result.finalResult){
      _callGenerateContentAPI();
    }
  }

  void _changeLoadingStatus(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _resetuserText(){
    setState(() {
      userText.clear();
      _emptyText=true;
    });
  }

  void _callGenerateContentAPI() async {
    _changeLoadingStatus();
    try {
      String prompt = userText.text;
      setState(() {
        question = prompt;
      });
      print('Prompt value:$prompt');
      String response = await geminiService.generateContent(prompt);
      print('response:$response');
      setState(() {
        responseText = response;
        _resetuserText();        
      });
      _changeLoadingStatus();
    } catch (e) {
      print('Error:$e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themecolor,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          "OpenChat",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ),
      body: 
      isLoading?
      loadingIndicator()
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [            
            Expanded(
              child: ListView(
                children: [
                  responseText==''?
                  const Center(
                    heightFactor: 2,
                    child: Text(
                      'Start Serching With GEMINI \n Introduced by Google',
                      style: TextStyle(
                        fontSize: 16,
                        color: lightText
                      ) ,              
                    ),
                  ):
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("Quesion: $question",style:TextStyle(
                        color: lightText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),),
                      SizedBox(
                        height: 20,
                      ),
                      Card(                        
                        color: primaryColor, // Set background color to red
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Answer:\n\n$responseText",
                            style: TextStyle(color: primaryTextColor,fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: userText,
                style: const TextStyle(
                  color: primaryTextColor,
                ),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3.0)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3.0)),
                  hintText: 'Message to Gemini',
                  hintStyle:
                      const TextStyle(color: lightText, fontWeight: FontWeight.bold),                  
                  suffixIcon: _emptyText? 
                  IconButton(
                    onPressed: 
                    _speechToText.isNotListening?_startListening :_stopListening, 
                    icon: Icon(Icons.mic),
                    color: whatsappcolor,
                  ):
                  IconButton(
                    onPressed:_callGenerateContentAPI,
                    icon: const Icon(
                      Icons.done,
                      size: 25,
                      color: whatsappcolor,
                    ),
                  ),
                ),
                onChanged: (value){
                  setState(() {
                    _emptyText = value.isEmpty;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
