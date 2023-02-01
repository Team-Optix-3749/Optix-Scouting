import 'dart:io' as io;

import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:optix_scouting/utilities/classes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optix_scouting/util.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Match extends StatefulWidget {
  final Function getScoreChanges;
  final MatchInfo Function() getMatchInfo;

  const Match(
      {Key? key, required this.getScoreChanges, required this.getMatchInfo})
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
    "val",
  ];
  // name : isSelected
  Map<String, BtnState> defaults = {
    "Balance": BtnState.ONE,
    "Tele Start": BtnState.FALSE,
    "Save": BtnState.FALSE
  };
  List<Point> initialData = [];
  List<String> initialDataTypes = [];

  var uuid = Uuid();

  String directory = "";

  String currentSelected = "";
  int index = 0;
  bool isAuto = true;
  int balancedAuto = 0;
  int balancedTele = 0;

  GlobalKey _tapKey = GlobalKey();
  Offset? _tapPosition;

  final List<SvgPicture> images = [
    SvgPicture.asset(
      'assets/field.svg',
      fit: BoxFit.fitWidth,
    ),
  ];
  Widget getStaticDefaults(int val, String label) {
    Color color = Color.fromARGB(255, 78, 118, 247);
    return Container(
      width: 50,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Positioned.fill(
                top: -30,
                child: Align(
                  child: Text(
                    textAlign: TextAlign.center,
                    label,
                    style: TextStyle(fontSize: 13, color: color),
                  ),
                ),
              ),
              Container(
                child:
                    new Icon(Icons.expand_less_sharp, size: 40, color: color),
              ),
              Positioned.fill(
                top: 30,
                child: Align(
                  child: Text(
                    textAlign: TextAlign.center,
                    "${val.toString()} Pts.",
                    style: TextStyle(fontSize: 8, color: color),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getDefaults(String label) {
    Color color = Colors.black;
    if (defaults[label]! == BtnState.TRUE || defaults[label]! == BtnState.TWO) {
      color = Color.fromARGB(255, 78, 118, 247);
      print(label);
    }
    if (defaults[label]! == BtnState.THREE) {
      color = Color.fromARGB(255, 243, 57, 82);
    }
    if (label == "Balance") {
      return Container(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Align(
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(fontSize: 13, color: color),
                ),
              ),
            ),
            Container(
              child: new Icon(
                Icons.check_box,
                color: color,
                size: 25,
              ),
            ),
            Align(
              child: Text(
                textAlign: TextAlign.center,
                "",
                style: TextStyle(fontSize: 5, color: color),
              ),
            ),
          ],
        ),
      );
    } else if (label == "Tele Start") {
      return Container(
        width: 57,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Align(
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(fontSize: 13, color: color),
                ),
              ),
            ),
            Container(
              child: new Icon(
                Icons.play_arrow,
                color: color,
                size: 25,
              ),
            ),
            Align(
              child: Text(
                textAlign: TextAlign.center,
                "",
                style: TextStyle(fontSize: 5, color: color),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Align(
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(fontSize: 13, color: color),
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
                style: TextStyle(fontSize: 5, color: color),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget getPlusMinus(int val, String label) {
    Color color = Colors.black;
    if (label == currentSelected) {
      color = Color.fromARGB(255, 78, 118, 247);
      print(label);
    }

    return Container(
      width: 50,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Positioned.fill(
                top: -30,
                child: Align(
                  child: Text(
                    textAlign: TextAlign.center,
                    label,
                    style: TextStyle(fontSize: 13, color: color),
                  ),
                ),
              ),
              Container(
                child:
                    new Icon(Icons.expand_less_sharp, size: 40, color: color),
              ),
              Positioned.fill(
                top: 30,
                child: Align(
                  child: Text(
                    textAlign: TextAlign.center,
                    "${val.toString()} Pts.",
                    style: TextStyle(fontSize: 8, color: color),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    initialData = [
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
      Point(clicked: false, isAuto: false),
    ];

    Map<String, int> scoreChanges = widget.getScoreChanges();
    for (int i = 0; i < initialData.length; i++) {
      initialDataTypes.add((scoreChanges).keys.toList()[i % 3].toString());
    }
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  // void getTapPosition(TapUpDetails details, String type) async {
  //   final RenderBox reference =
  //       _tapKey.currentContext!.findRenderObject() as RenderBox;
  //   final tapPos = reference.globalToLocal(details.globalPosition);
  //   setState(() {
  //     _tapPosition = tapPos;
  //   });
  //   if (type == "") {
  //     showDialog(
  //       context: context,
  //       builder: ((context) => Util.buildPopupDialog(
  //           context, "No type", <Widget>[Text("Select a point type")])),
  //     );
  //   } else {
  //     data.add([
  //       widget.getMatchInfo().teamNumber,
  //       widget.getMatchInfo().matchNumber,
  //       type,
  //       _tapPosition!.dx.toStringAsFixed(2),
  //       _tapPosition!.dy.toStringAsFixed(2),
  //     ]);
  //     currentSelected = "";
  //   }
  // }

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

  void enterFinalInfo() {
    if (mounted) {
      TextEditingController commentsController = TextEditingController();
      bool checkedValue = false;
      double defense = 0;
      double offense = 0;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Final Data"),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Comments',
                    ),
                    controller: commentsController,
                    maxLines: 3,
                  ),
                  CheckboxListTile(
                    title: const Text("Robot broke?"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const Text("Offense"),
                  Slider(
                    value: offense,
                    max: 10,
                    divisions: 10,
                    label: offense.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        offense = value;
                      });
                    },
                  ),
                  const Text("Defense"),
                  Slider(
                    value: defense,
                    max: 10,
                    divisions: 10,
                    label: defense.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        defense = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (commentsController.value.text.isNotEmpty) {
                  Navigator.pop(context);
                  saveFile(commentsController.value.text, checkedValue,
                      defense.toInt(), offense.toInt());
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    }
  }

  void saveFile(String comments, bool broken, int offense, int defense) async {
    String id = uuid.v1();
    String fileName =
        'MATCH_${DateFormat('yyyy-MM-dd').format(DateTime.now())}_${widget.getMatchInfo().teamNumber}_${widget.getMatchInfo().matchNumber}_${widget.getMatchInfo().teamName}_${widget.getMatchInfo().comp}_$id.json';
    io.File file = io.File(await getFilePath(fileName)); // 1
    // for (int i = 0; i < initialData.length; i++) {
    //   data.add([
    //     widget.getMatchInfo().teamNumber,
    //     widget.getMatchInfo().matchNumber.toString(),
    //     initialDataTypes[i],
    //     i.remainder(9).toString(),
    //     (i % 3).toString(),
    //     initialData[i].toString(),
    //   ]);
    // }
    List<Event> events = [];
    for (int i = 0; i < initialData.length; i++) {
      if (initialData[i].clicked) {
        events.add(
          Event(
            x: (i % 3),
            y: (i.toDouble() / 3).floor().toDouble(),
            isAuto: initialData[i].isAuto,
          ),
        );
      }
    }
    ScoutData data = ScoutData(
      matchInfo: widget.getMatchInfo(),
      events: events,
      teleBalanced: balancedTele,
      autoBalanced: balancedAuto,
      notes: comments,
      didBreak: broken,
      offense: offense,
      defense: defense
    );

    file.writeAsString(data.toJSON());

    // QR Code
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => Util.buildPopupDialog(
          context,
          "QR Code",
          <Widget>[
            Container(
              height: 300,
              width: 300,
              child: QrImage(
                  data: data.toJSON(), version: QrVersions.auto, size: 300),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> scoreChanges = widget.getScoreChanges();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Match Scouting'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 0,
              // height: MediaQuery.of(context).size.height * 0.65,
              // child: AspectRatio(
              //   aspectRatio: 1 / 2,
              //   child: GestureDetector(
              //       key: _tapKey,
              //       // child: images[0],
              //       child: RotatedBox(
              //         quarterTurns: 1,
              //         child: Container(
              //           child: images[0],
              //         ),
              //       ),
              //       onTapUp: (details) =>
              //           getTapPosition(details, currentSelected)),
              // ),
              child: Container(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                  child: GridView.builder(
                    itemCount: 27,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (initialData[index].clicked) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: Center(
                            // child: Text('$index'),

                            child: ElevatedButton(
                              child: Container(
                                  // child: Text("${initialData[index]}"),
                                  ),
                              onPressed: () {
                                setState(() {
                                  initialData[index].clicked =
                                      !initialData[index].clicked;
                                  initialData[index].isAuto = isAuto;
                                  print(initialData[index].clicked.toString() +
                                      " " +
                                      index.toString());
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: Center(
                            // child: Text('$index'),
                            child: OutlinedButton(
                              child: Container(
                                  // child: Text("${initialData[index]}"),
                                  ),
                              onPressed: () {
                                setState(() {
                                  initialData[index].clicked =
                                      !initialData[index].clicked;
                                  initialData[index].isAuto = isAuto;
                                  print(initialData[index].clicked.toString() +
                                      " " +
                                      index.toString());
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: scoreChanges.keys
                    .map(
                      (k) => Container(
                        child: getStaticDefaults(scoreChanges[k]!, k),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: defaults.keys
                    .map(
                      (k) => TextButton(
                        child: getDefaults(k),
                        onPressed: () {
                          setState(
                            () {
                              if (k == "Balance") {
                                setState(() {
                                  defaults[k] = defaults[k]!.not();
                                });
                                if (isAuto) {
                                  balancedAuto = defaults[k]!.toNum();
                                } else {
                                  balancedTele = defaults[k]!.toNum();
                                }
                              }
                              if (k == "Save") {
                                enterFinalInfo();
                              }
                              if (k == "Tele Start") {
                                setState(() {
                                  defaults[k] = BtnState.TRUE;
                                  defaults["Balance"] = BtnState.ONE;
                                  isAuto = false;
                                });
                              }
                            },
                          );
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
