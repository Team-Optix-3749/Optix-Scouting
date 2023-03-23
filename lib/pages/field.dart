import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';

void main() => runApp(const Field());

class Field extends StatefulWidget {
  const Field({Key? key}) : super(key: key);

  static const String routeName = "/FieldPage";

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final _imageKey = GlobalKey<ImagePainterState>();
  List<String> alliances = ["assets/blue.png", "assets/red.png"];
  String? alliance;

  GlobalKey tapKey = GlobalKey();
  Offset? tapPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    alliance = alliances[0];
    List<ImagePainter> images = [
      ImagePainter.asset(
        alliance!,
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 3.5,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.freeStyle,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('FIELD'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: images[0],
      ),
    );
  }
}
