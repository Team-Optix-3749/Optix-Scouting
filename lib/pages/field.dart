import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const Field());

class Field extends StatefulWidget {
  const Field({Key? key}) : super(key: key);

  static const String routeName = "/FieldPage";

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('FIELD'),
      ),
    );
  }
}
