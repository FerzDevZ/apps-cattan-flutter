import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime dateCreated;
  Color color;
  Color textColor;
  double fontSize;
  String fontFamily;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16.0,
    this.fontFamily = 'Poppins',
  });
}
