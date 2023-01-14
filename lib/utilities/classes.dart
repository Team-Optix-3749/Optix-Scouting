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

  ScoutData({required this.matchInfo, required this.events});

  toJSON() {
    return '{"teamNumber": ${matchInfo.teamNumber}, "teamName": "${matchInfo.teamName}", "matchNumber": ${matchInfo.matchNumber}, "comp": "${matchInfo.comp}", "events": ${Event.eventsToJSON(events)} }';
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
