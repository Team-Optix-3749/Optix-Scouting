import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optix_scouting/util.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Match extends StatefulWidget {
  final Function getScoreChanges;
  final Function getLabels;
  final Function setLabels;

  const Match(
      {Key? key,
      required this.getScoreChanges,
      required this.getLabels,
      required this.setLabels})
      : super(key: key);

  static const String routeName = "/MatchPage";

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  List<String> header = [
    "team",
    "match",
    "type",
    "x_pos",
    "y_pos",
  ];
  List<List<String>> data = [];

  var uuid = Uuid();

  String directory = "";

  String currentSelected = "";
  int index = 0;

  GlobalKey _tapKey = GlobalKey();
  Offset? _tapPosition;

  final List<SvgPicture> images = [
    SvgPicture.asset(
      'assets/Solid_red.svg',
      fit: BoxFit.fitWidth,
    ),
  ];

  Widget getPlusMinus(int val, String label) {
    Color color = Colors.black;
    if (label == currentSelected) {
      color = Color.fromARGB(255, 78, 118, 247);
      print(label);
    }
    if (val > 0) {
      return Container(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  top: -40,
                  child: Align(
                    child: Text(
                      textAlign: TextAlign.center,
                      label,
                      style: TextStyle(fontSize: 15, color: color),
                    ),
                  ),
                ),
                Container(
                  child:
                      new Icon(Icons.expand_less_sharp, size: 60, color: color),
                ),
                Positioned.fill(
                  top: 30,
                  child: Align(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${val.toString()} Pts.",
                      style: TextStyle(fontSize: 10, color: color),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (val == 0) {
      return Container(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Align(
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(fontSize: 15, color: color),
                ),
              ),
            ),
            Container(
              child: new Icon(
                Icons.warning,
                color: color,
                size: 25,
              ),
            ),
            Align(
              child: Text(
                textAlign: TextAlign.center,
                "",
                style: TextStyle(fontSize: 10, color: color),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Align(
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(fontSize: 15, color: color),
                ),
              ),
            ),
            Container(
              child: new Icon(
                Icons.save,
                color: color,
                size: 25,
              ),
            ),
            Align(
              child: Text(
                textAlign: TextAlign.center,
                "",
                style: TextStyle(fontSize: 10, color: color),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    data = [header];
    super.initState();
  }

  @override
  dispose() {
    saveFile();
    super.dispose();
  }

  void getTapPosition(TapUpDetails details, String type) async {
    final RenderBox reference =
        _tapKey.currentContext!.findRenderObject() as RenderBox;
    final tapPos = reference.globalToLocal(details.globalPosition);
    setState(() {
      _tapPosition = tapPos;
    });
    if (type == "") {
      showDialog(
        context: context,
        builder: ((context) => Util.buildPopupDialog(
            context, "No type", <Widget>[Text("Select a point type")])),
      );
    } else {
      data.add([
        widget.getLabels()[0],
        widget.getLabels()[1],
        type,
        _tapPosition!.dx.toStringAsFixed(2),
        _tapPosition!.dy.toStringAsFixed(2),
      ]);
      currentSelected = "";
    }
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   // final path = await _localPath;
  //   File file =
  //       File('${DateFormat('EEEE, d MMM, yyyy').format(DateTime.now())}.csv');
  //   final doesExist = await file.exists();
  //   if (!doesExist) file = await file.create();

  //   return file;
  // }

  Future<String> getFilePath(String fileName) async {
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName'; // 3
    return filePath;
  }

  void saveFile() async {
    if (data.length > 1) {
      String id = uuid.v1();
      String fileName =
          'MATCH_${DateFormat('EEEE, d MMM, yyyy').format(DateTime.now())}_${widget.getLabels()[0]}_${widget.getLabels()[1]}_${id}.csv';
      io.File file = io.File(await getFilePath(fileName)); // 1
      String csv = ListToCsvConverter().convert(data);
      file.writeAsString(csv);
      data.clear(); //hi
      data.add(header);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> scoreChanges = widget.getScoreChanges();
    scoreChanges["Penalty"] = 0;
    scoreChanges["Save"] = -3749;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Match Scouting'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              // height: MediaQuery.of(context).size.height * 0.65,
              child: AspectRatio(
                aspectRatio: 1 / 2,
                child: GestureDetector(
                    key: _tapKey,
                    // child: images[0],
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        child: images[0],
                      ),
                    ),
                    onTapUp: (details) =>
                        getTapPosition(details, currentSelected)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: scoreChanges.keys
                    .map(
                      (k) => TextButton(
                        child: getPlusMinus(scoreChanges[k]!, k),
                        onPressed: () {
                          setState(() {
                            if (currentSelected == k) {
                              currentSelected = "";
                            } else {
                              currentSelected = k;
                            }
                            if (scoreChanges[k] == -3749) {
                              currentSelected = "";
                              print("${data.length}");
                              saveFile();

                              // writeData;
                              // Todo: write data to sqflite database
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
