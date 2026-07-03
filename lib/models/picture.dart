import 'package:flutter/material.dart';
import 'package:markup/models/markup_point.dart';

class Picture {
  final int id;
  final Image image;
  final String title;
  List<MarkupPoint?> savedMarkupPoints = [];

  Picture({required this.id, required this.image, required this.title});
}