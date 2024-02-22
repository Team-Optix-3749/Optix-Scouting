import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:optix_scouting/util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' as io;

class Pit extends StatefulWidget {
  const Pit(
      {Key? key,
      required this.teamName,
      required this.competition,
      required this.changeIndex})
      : super(key: key);
  final String teamName;
  final String competition;
  final Function changeIndex;

  static const String routeName = "/PitPage";
  @override
  _PitState createState() => _PitState();
}

class _PitState extends State<Pit> {
  List<TextEditingController> commentsController =
      List.generate(16, (i) => TextEditingController());
  List<TextEditingController> teamController =
      List.generate(16, (i) => TextEditingController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIT'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            for (int i = 0; i < 16; i++)
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Team #${i + 1}',
                    ),
                    controller: teamController[i],
                    maxLines: 1,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Team #${i + 1} Comments',
                    ),
                    controller: commentsController[i],
                    maxLines: 3,
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ElevatedButton(
              onPressed: () {
                var data = {};

                for (int i = 0; i < 16; i++) {
                  if (teamController[i].text != "") {
                    data[teamController[i].text] = commentsController[i].text;
                  }
                }

                print(mounted);

                // Save the data
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => Util.buildPopupDialog(
                      context,
                      "QR Code",
                      <Widget>[
                        Container(
                          height: 295,
                          width: 295,
                          child: QrImage(
                            data: jsonEncode(data),
                            version: QrVersions.auto,
                            size: 295,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
