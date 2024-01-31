import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:optix_scouting/utilities/classes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optix_scouting/util.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Match extends StatefulWidget {
  final Function getScoreChanges;
  final MatchInfo Function() getMatchInfo;

  const Match({Key? key, required this.getScoreChanges, required this.getMatchInfo})
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
  int _autoDuration = 15;
  int _teleOpDuration = 135;
  bool isCountdownRunning = false;

  int autospeakerCount = 0;
  int autoampCount = 0;
  int telespeakerCount = 0;
  int teleampCount = 0;
  int trapCount = 0;
  int harmonyCount = 0;

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
      _autoDuration = 15;
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
    Map<String, int> scoreChanges = widget.getScoreChanges();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isAuto) _buildCounter("Speaker", autospeakerCount)
                else _buildCounter("Speaker", telespeakerCount),
                if (isAuto) _buildCounter("Amp", autoampCount)
                else _buildCounter("Amp", teleampCount),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimer("Auto", _autoDuration),
                _buildTimer("Tele-Op", _teleOpDuration),
              ],
            ),

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
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int count) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (label == "Speaker") {
                    if (isAuto) {
                      autospeakerCount--;
                    } else {
                      telespeakerCount--;
                    }
                  } else if (label == "Amp") {
                    if (isAuto) {
                      autoampCount--;
                    } else {
                      teleampCount--;
                    }
                  } else if (label == "Trap") {
                    trapCount--;
                  } else if (label == "Harmony") {
                    harmonyCount--;
                  }
                });
              },
              icon: Icon(Icons.remove),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
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
                    harmonyCount++;
                  }
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimer(String label, int duration) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(duration.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }
}
