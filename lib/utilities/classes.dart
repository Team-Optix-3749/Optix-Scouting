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

class ScoutData {
  MatchInfo matchInfo = MatchInfo(
      teamNumber: "3749",
      teamName: "Team Optix",
      matchNumber: 42,
      comp: "San Diego Regional");
  List<Event> events = [];

  ScoutData({required this.matchInfo, required this.events});

  toJSON() {
    return "";
  }
}

class Event {
  String name = "";
  double x = 0;
  double y = 0;

  Event({required this.name, required this.x, required this.y});

  toJSON() {
    return "";
  }
}
