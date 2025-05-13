import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime dateCreated;
  Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.color = Colors.white,
  });
}
