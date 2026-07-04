import 'package:flutter/material.dart';
import 'package:markup/data/picture_data.dart';
import 'package:markup/models/picture.dart';
import 'package:markup/widgets/picture_card.dart';

class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Markup'),
      ),
      body: SafeArea(
        child: Expanded(
          // List each image 
          child: ListView.builder(
            itemCount: pictures.length,
            itemBuilder: (context, index) {
              final Picture picture = pictures[index];

              return PictureCard(picture: picture);
            }
          )
        )
      ),
    );
  }
}