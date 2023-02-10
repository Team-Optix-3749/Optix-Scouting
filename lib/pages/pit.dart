import 'package:flutter/material.dart';
import 'package:optix_scouting/utilities/scanQR.dart';
import 'package:permission_handler/permission_handler.dart';
// camera dependencies
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Pit());

class Pit extends StatefulWidget {
  const Pit({Key? key, required this.camera}) : super(key: key);
  /// testingg resomethin rq
  /// Ill add itt gotchu
  /// p good
  /// my phone can run a server lol
  /// how's everything going
  /// w ne ed to add a require tag in the consturgot ok 
  /// @nVarap wha is the thing for camera
  final  camera;
  static const String routeName = "/PitPage";
  @override
  _PitState createState() => _PitState();
}

class _PitState extends State<Pit> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  } // alr

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PIT SCOUTING'),
      ),
      body: ScanQrPage(),
      // body: Container(),
    );
  }
}

// Imma add camera functionlity 
// added dependencies already
// oki Doki(doki), doki doki literature  club 😈
// LMAO
// I'll help when I finsih my world notes 
// tell me when to test alr