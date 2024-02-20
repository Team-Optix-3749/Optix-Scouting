import 'dart:async';
import 'dart:convert';
import 'dart:io' as io; // Add this import for 'io.File'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optix_scouting/utilities/classes.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:optix_scouting/util.dart';
// import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'noteMapping.dart';
import 'humanPlayer.dart';

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

  Map<String, BtnState> defaults = {
    "Balance": BtnState.ONE,
    "Start Match": BtnState.FALSE,
    "Mobility": BtnState.FALSE,
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
  bool mobility = false;
  bool park = false;

  Timer? _autoTimer;
  Timer? _teleOpTimer;
  int _autoDuration = 17;
  int _teleOpDuration = 135;
  bool isCountdownRunning = false;
  int autospeakerCount = 0;
  int autoampCount = 0;
  int telespeakerCount = 0;
  int teleampCount = 0;
  int trapCount = 0;
  int harmonyCount = 0;

  int test = 0;

  List<int> _threeNotes = [];
  List<int> _fiveNotes = [];
  List<int> _humanPlayer = [];

  void setThreeNotes(List<int> threeNotes) {
    setState(() {
      _threeNotes = threeNotes;
    });
  }

  void setFiveNotes(List<int> fiveNotes) {
    setState(() {
      _fiveNotes = fiveNotes;
    });
  }

  void setHumanPlayer(List<int> humanPlayer) {
    setState(() {
      _humanPlayer = humanPlayer;
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  void _startAutoTimer() {
    setState(() {
      isAuto = true;
    });
    _autoTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_autoDuration > 1) {
          _autoDuration--;
        } else {
          _autoDuration = 0;
          isAuto = false;

          _autoTimer!.cancel();
          if (isCountdownRunning) {
            _startTeleOpTimer();
          }
        }
      });
    });
  }

  void _startTeleOpTimer() {
    _teleOpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_teleOpDuration > 0) {
          _teleOpDuration--;
        } else {
          _teleOpTimer!.cancel();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _autoDuration = 17;
      _teleOpDuration = 135;
      isCountdownRunning = false;
    });
    _autoTimer?.cancel();
    _teleOpTimer?.cancel();
  }

  @override
  dispose() {
    _autoTimer?.cancel();
    _teleOpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, int> scoreChanges = widget.getScoreChanges();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Match Scouting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isAuto)
                  _buildCounter("Speaker", autospeakerCount)
                else
                  _buildCounter("Speaker", telespeakerCount),
                if (isAuto)
                  _buildCounter("Amp", autoampCount)
                else
                  _buildCounter("Amp", teleampCount),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCounter("Trap", trapCount),
                _buildCounter("Harmony", harmonyCount),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CheckboxListTile(
                    title: const Text("Park"),
                    value: park,
                    onChanged: (newValue) {
                      setState(() {
                        park = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                )
              ],
            ),
            if (_teleOpDuration > 25)
              NoteMapping(
                threeNotes: _threeNotes,
                fiveNotes: _fiveNotes,
                setThreeNotes: setThreeNotes,
                setFiveNotes: setFiveNotes,
                isRightSide: widget.getMatchInfo().alliance == "Blue",
              ),
            if (_teleOpDuration <= 25)
              HumanPlayer(
                  isBlue: widget.getMatchInfo().alliance == "Blue",
                  setHumanPlayerList: setHumanPlayer,
                  humanPlayerList: _humanPlayer),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimer("Auto", _autoDuration),
                _buildTimer("Tele-Op", _teleOpDuration),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                onPressed: () {
                  _resetTimer();
                  isCountdownRunning = true;
                  _startAutoTimer();
                },
                child: Text('Start Countdown'),
              ),
              ElevatedButton(
                onPressed: () {
                  _resetTimer();
                  isCountdownRunning = false;
                },
                child: Text('Reset Timer'),
              ),
              ElevatedButton(
                onPressed: () {
                  enterFinalInfo();
                },
                child: Text('Save'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<String> getFilePath(String fileName) async {
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName'; // 3
    return filePath;
  }

  void reset() {
    setState(() {
      autoampCount = 0;
      autospeakerCount = 0;
      telespeakerCount = 0;
      teleampCount = 0;
      harmonyCount = 0;
      trapCount = 0;
    });

    _resetTimer();
  }

  Widget _buildCounter(String label, int count) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (label == "Speaker") {
                      if (isAuto) {
                        if (autospeakerCount > 0) autospeakerCount--;
                      } else {
                        if (telespeakerCount > 0) telespeakerCount--;
                      }
                    } else if (label == "Amp") {
                      if (isAuto) {
                        if (autoampCount > 0) autoampCount--;
                      } else {
                        if (teleampCount > 0) teleampCount--;
                      }
                    } else if (label == "Trap") {
                      if (trapCount > 0) trapCount--;
                    } else if (label == "Harmony") {
                      if (harmonyCount > 0) harmonyCount--;
                    }
                  });
                },
                icon: Icon(Icons.remove, size: 40),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (label == "Speaker") {
                      if (isAuto) {
                        autospeakerCount++;
                      } else {
                        telespeakerCount++;
                      }
                    } else if (label == "Amp") {
                      if (isAuto) {
                        autoampCount++;
                      } else {
                        teleampCount++;
                      }
                    } else if (label == "Trap") {
                      trapCount++;
                    } else if (label == "Harmony") {
                      if (harmonyCount < 3) harmonyCount++;
                    }
                  });
                },
                icon: Icon(Icons.add, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(String label, int duration) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(duration.toString(),
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
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
                      offense.toInt(), defense.toInt());
                } else {
                  saveFile("", checkedValue, offense.toInt(), defense.toInt());
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
    io.File file = io.File(await getFilePath(fileName));
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
        notes: comments,
        didBreak: broken,
        offense: offense,
        defense: defense,
        park: park,
        autospeakerCount: autospeakerCount,
        autoampCount: autoampCount,
        teleampCount: teleampCount,
        telespeakerCount: telespeakerCount,
        trapCount: trapCount,
        harmonyCount: harmonyCount,
        threeCount: _threeNotes,
        fiveCount: _fiveNotes,
        humanPlayer: _humanPlayer);

    file.writeAsString(jsonEncode(data.toJSON()));

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
                data: jsonEncode(data.toJSON()),
                version: QrVersions.auto,
                size: 295,
              ),
            ),
          ],
        ),
      );
    }

    reset();
  }
}
