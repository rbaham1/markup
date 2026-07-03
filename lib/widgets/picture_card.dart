import 'package:flutter/material.dart';
import 'package:markup/models/picture.dart';
import 'package:markup/screens/picture_edit_screen.dart';

class PictureCard extends StatelessWidget {
  final Picture picture;
  const PictureCard({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PictureEditScreen(picture: picture),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Use Tween to scale from 0.0 (invisible) to 1.0 (full size)
              var tween = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeInOut));
              
              return ScaleTransition(
                scale: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200)
          )
        );
      },
      child: Card(
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: 4),
          leading: SizedBox(
            width: 80,
            height: 80,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: picture.image,
              ),
            ),
          ),
          title: Text(picture.title),
          trailing: Icon(Icons.edit)
        ),
      ),
    );
  }
}