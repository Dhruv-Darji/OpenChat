import 'package:flutter/material.dart';
import 'package:openchat/Constants/Colors.dart';

loadingIndicator(){
  return const Center(
    child: CircularProgressIndicator(
      color: primaryTextColor,
  ));
}