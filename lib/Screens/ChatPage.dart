import 'package:flutter/material.dart';
import 'package:openchat/Constants/Colors.dart';
import 'package:openchat/Services/api_service.dart';

import '../Constants/loadingIcon.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = false;
  final GeminiService geminiService = GeminiService();
  final TextEditingController userText = TextEditingController();
  String responseText = '';

  @override
  void dispose() {
    userText.dispose();
    super.dispose();
  }
  void _changeLoadingStatus(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _resetuserText(){
    setState(() {
      userText.clear();
    });
  }

  void _callGenerateContentAPI() async {
    try {
      String prompt = userText.text;
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
                  Card(
                    color: primaryColor, // Set background color to red
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        responseText,
                        style: TextStyle(color: primaryTextColor),
                      ),
                    ),
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      _callGenerateContentAPI();
                      _changeLoadingStatus();
                    },
                    icon: const Icon(
                      Icons.done,
                      size: 25,
                      color: lightText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
