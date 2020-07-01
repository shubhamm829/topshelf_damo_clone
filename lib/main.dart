import 'package:flutter/material.dart';
import './screens/home.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      brightness: Brightness.light,
       primaryColor: Colors.orange,
           accentColor: Colors.orangeAccent
    ),
  ));
}