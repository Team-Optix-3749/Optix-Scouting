import 'package:flutter/material.dart';
import 'package:optix_scouting/utilities/scanQR.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const Pit());

class Pit extends StatefulWidget {
  const Pit({Key? key}) : super(key: key);

  static const String routeName = "/PitPage";

  @override
  _PitState createState() => _PitState();
}

class _PitState extends State<Pit> {
  @override
  void initState() {
    // TODO: implement initState
  

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PIT SCOUTING'),
      ),
      body: ScanQrPage(),
    );
  }
}
