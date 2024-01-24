import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  // Map to store button states
  Map<String, BtnState> defaults = {
    "Balance": BtnState.ONE,
    "Start Match": BtnState.FALSE, // Updated label for Tele-Op start button
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
  int _autoDuration = 17; // Auto duration in seconds
  int _teleOpDuration = 135; // Tele-Op duration in seconds

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _startAutoTimer(); // Start the Auto timer
    super.initState();
  }

  // Method to start the Auto timer
  void _startAutoTimer() {
    _autoTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_autoDuration > 0) {
          _autoDuration--;
        } else {
          _autoTimer!.cancel();
          _startTeleOpTimer(); 
        }
      });
    });
  }

  // Method to start the Tele-Op timer
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

  @override
  dispose() {
    _autoTimer?.cancel();
    _teleOpTimer?.cancel();
    super.dispose();
  }

  // ... (rest of the existing code remains unchanged)

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
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.only(top: 25),
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
                            child: ElevatedButton(
                              child: Container(),
                              onPressed: () {
                                setState(() {
                                  initialData[index].clicked =
                                      !initialData[index].clicked;
                                  initialData[index].isAuto = isAuto;
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: Center(
                            child: OutlinedButton(
                              child: Container(),
                              onPressed: () {
                                setState(() {
                                  initialData[index].clicked =
                                      !initialData[index].clicked;
                                  initialData[index].isAuto = isAuto;
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
            // ... (rest of the existing code remains unchanged)
          ],
        ),
      ),
    );
  }
}
