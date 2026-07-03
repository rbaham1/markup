import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  final bool isEditing;
  const ExitButton({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isEditing) {
          showDialog(
            context: context,
            builder: (context) {
              // Show confirmation message to confirm exiting edit mode
              return AlertDialog(
                title: Text("Exit?"),
                content: Text("Unsaved changes will be erased."),
                actions: [
                  // Add a cancel button that closes the confirmation message only
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.blue
                    ),
                    child: Text("Cancel")
                  ),
                  // Add a confirm button that closes the confirmation message and clears the unsaved edits
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Confirm")
                  )
                ],
              );
            }
          );
        } else {
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.clear)
    );
  }
}