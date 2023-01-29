class MatchInfo {
  String teamNumber = "";
  int matchNumber = 0;
  String teamName = "";
  String comp = "";

  MatchInfo(
      {required this.teamNumber,
      required this.matchNumber,
      required this.teamName,
      required this.comp});
}

class MatchTeam {
  final String teamName;
  final int teamNumber;
  const MatchTeam({
    required this.teamName,
    required this.teamNumber,
  });
  @override
  String toString() {
    return '$teamNumber';
  }
}

class ScoutData {
  MatchInfo matchInfo = MatchInfo(
      teamNumber: "3749",
      teamName: "Team Optix",
      matchNumber: 42,
      comp: "San Diego Regional");
  List<Event> events = [];
  int autoBalanced; // 0 = none, 1 = docked, 2 = engaged
  int teleBalanced; // 0 = none, 1 = docked, 2 = engaged
  String notes;
  bool didBreak;

  ScoutData(
      {required this.matchInfo,
      required this.events,
      required this.autoBalanced,
      required this.teleBalanced,
      required this.notes,
      required this.didBreak});

  toJSON() {
    int balanced = autoBalanced * 10 + teleBalanced;
    return '{"teamNumber": ${matchInfo.teamNumber}, "teamName": "${matchInfo.teamName}", "matchNumber": ${matchInfo.matchNumber}, "comp": "${matchInfo.comp}", "events": ${Event.eventsToJSON(events)}, "balanced": $balanced, "notes": "$notes", "break": $didBreak}';
  }
}

class Event {
  double x = 0;
  double y = 0;
  bool isAuto;

  Event({required this.x, required this.y, required this.isAuto});

  static eventsToJSON(List<Event> events) {
    List<List<int>> list = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ];
    for (Event event in events) {
      if (event.isAuto) {
        list[event.x.toInt()][event.y.toInt()] = 2;
      } else {
        list[event.x.toInt()][event.y.toInt()] = 1;
      }
    }

    return "[${list.map((l) => '[${l.join(',')}]').join(',')}]";
  }
}

class Point {
  bool clicked;
  bool isAuto;

  Point({required this.clicked, required this.isAuto});
}

class BtnState {
  String name;
  BtnState({required this.name});

  not() {
    if (name == "true") {
      return FALSE;
    }
    if (name == "false") {
      return TRUE;
    }

    if (name == "one") {
      return TWO;
    }
    if (name == "two") {
      return THREE;
    }
    if (name == "three") {
      return ONE;
    }
  }

  toNum() {
    if (name == "true") {
      return 1;
    }
    if (name == "false") {
      return 0;
    }
    if (name == "one") {
      return 0;
    }
    if (name == "two") {
      return 1;
    }
    if (name == "three") {
      return 2;
    }
  }

  static BtnState TRUE = BtnState(name: "true");
  static BtnState FALSE = BtnState(name: "false");

  static BtnState ONE = BtnState(name: "one");
  static BtnState TWO = BtnState(name: "two");
  static BtnState THREE = BtnState(name: "three");
}

class HistoryEntry {
  const HistoryEntry(this.teamName, this.teamNumber, this.matchNumber, this.id,
      this.index, this.compName, this.date);
  final String teamName;
  final int teamNumber;
  final int matchNumber;
  final String id;
  final int index;
  final String date;
  final String compName;
}
