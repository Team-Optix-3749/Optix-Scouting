import 'package:flutter/material.dart';

void main() => runApp(const FieldView());

class FieldView extends StatefulWidget {
  const FieldView({Key? key}) : super(key: key);

  static const String routeName = "/FieldViewPage";

  @override
  _FieldViewPage createState() => _FieldViewPage();
}

class _FieldViewPage extends State<FieldView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PIT SCOUTING'),
      ),
    );
  }
}
