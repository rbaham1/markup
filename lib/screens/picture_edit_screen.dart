import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:markup/models/markup_point.dart';
import 'package:markup/models/picture.dart';
import 'package:markup/widgets/clear_button.dart';
import 'package:markup/widgets/exit_button.dart';
import 'package:markup/widgets/save_button.dart';

class PictureEditScreen extends StatefulWidget {
  final Picture picture;
  const PictureEditScreen({super.key, required this.picture});

  @override
  State<PictureEditScreen> createState() => _PictureEditScreenState();
}

class _PictureEditScreenState extends State<PictureEditScreen> {
  Color selectedColor = Colors.red;
  List<MarkupPoint?> unsavedMarkupPoints = [];
  late List<MarkupPoint?> savedMarkupPoints = widget.picture.savedMarkupPoints;
  bool changesMade = false;
  int pointerCount = 0;

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
    Navigator.of(context).pop();
  }

  void clearMarkup() {
    setState(() {
      if(widget.picture.savedMarkupPoints.isNotEmpty) changesMade = true;
      unsavedMarkupPoints = [];
      savedMarkupPoints = [];
    });
  }

  void saveMarkup() {
    widget.picture.savedMarkupPoints = [...savedMarkupPoints, ...unsavedMarkupPoints];
    Navigator.pop(context);
  }

  void addFirstMarkupPoint(DragStartDetails details, Paint paintBrush) {
    setState(() {
      changesMade = true;
      unsavedMarkupPoints.add(
        MarkupPoint(
          offset: details.localPosition, 
          paint: paintBrush
        )
      );
    });
  }

  void addMarkupPoint(PointerMoveEvent details, Paint paintBrush) {
    setState(() {
      unsavedMarkupPoints.add(
        MarkupPoint(
          offset: details.localPosition, 
          paint: paintBrush
        )
      );
    });
  }

  void endMarkupLine(PointerUpEvent event) {
    setState(() {
      unsavedMarkupPoints.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Paint paintBrush = Paint()
      ..color = selectedColor
      ..strokeWidth = 4.0;

    return Scaffold(
      appBar: AppBar(
        leading: ExitButton(isEditing: changesMade),
        actions: [
          ClearButton(onClear: clearMarkup),
          SaveButton(onSave: saveMarkup)
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Pinch to zoom in and out\nDrag with two fingers to pan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Listener(
                  onPointerDown: (_) => setState(() => pointerCount++),
                  onPointerUp: (_) => setState(() => pointerCount--),
                  child: InteractiveViewer(
                    scaleEnabled: pointerCount >= 2,
                    panEnabled: pointerCount >= 2,
                    child: Listener(
                      onPointerMove: (pointerCount == 1
                        ? (event) => addMarkupPoint(event, paintBrush)
                        : null
                      ),
                      onPointerUp: endMarkupLine,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          widget.picture.image,
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MarkupPainter(
                                savedMarkupPoints: savedMarkupPoints, 
                                unsavedMarkupPoints: unsavedMarkupPoints
                              )
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Select Color'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                );
              }
            );
          },
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: selectedColor,
              shape: BoxShape.circle
            ),
          ),
        ),
      ),
    );
  }
}

class MarkupPainter extends CustomPainter {
  final List<MarkupPoint?> savedMarkupPoints;
  final List<MarkupPoint?> unsavedMarkupPoints;

  MarkupPainter({super.repaint, required this.savedMarkupPoints, required this.unsavedMarkupPoints});


  @override
  void paint(Canvas canvas, Size size) {
    List<MarkupPoint?> allPoints = [...savedMarkupPoints, ...unsavedMarkupPoints];
    for (int i = 0; i < allPoints.length - 1; i++) {
      // Connect points sequentially unless an implicit null separator is reached
      if (allPoints[i] != null && allPoints[i + 1] != null) {
        canvas.drawLine(allPoints[i]!.offset, allPoints[i + 1]!.offset, allPoints[i]!.paint);
      }
    }
  }


  @override
  bool shouldRepaint(covariant MarkupPainter oldDelegate) => true;

}