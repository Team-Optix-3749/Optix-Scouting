import 'package:flutter/material.dart';

void main() => runApp(const Pit());

class Pit extends StatefulWidget {
  const Pit({Key? key}) : super(key: key);

  static const String routeName = "/PitPage";

  @override
  _PitState createState() => _PitState();
}

class _PitState extends State<Pit> {
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
