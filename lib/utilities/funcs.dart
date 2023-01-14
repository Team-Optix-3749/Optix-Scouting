import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:optix_scouting/utilities/classes.dart';

Future<String> getTeamName(String number) async {
  //Todo: Set up the API tag
  //Todo: After API setup, start on app:database integration
  try {
    final String response =
        await rootBundle.loadString('databases/database.json'); // Issue here
    final data = await json.decode(response);
    print(data[number]);
    return data[number];
  } catch (Exception) {
    return "Team does not exist";
  }
}

Future<List> getCompetitonList(String compName) async {
  try {
    final String response =
        await rootBundle.loadString('databases/Events.json'); // Issue here
    final data = await json.decode(response);

    return data[compName];
  } catch (Exception) {
    print("err");
    return ["Competition List Error"];
  }
}

Future<List> getCompetitionNames() async {
  try {
    final String response =
        await rootBundle.loadString('databases/Events.json'); // Issue here
    Map<String, dynamic> data = await json.decode(response);
    List<String> names = [];
    data.forEach((key, value) => {names.add(value["name"].toString())});
    return names; //data.keys.toL\ist();
  } catch (e) {
    return ["Competition Name Error", e];
  }
}

Future<List<String>> getCompetitionTeams(String teamName) async {
  List<String> names = [];
  String curKey = "HW";
  try {
    final String response =
        await rootBundle.loadString('databases/Events.json'); // Issue here
    Map<String, dynamic> data = await json.decode(response);
    data.forEach((key, value) {
      if (value['name'] == teamName) {
        curKey = key;
      }
    });
    for (int name in data[curKey]["teams"]) {
      names.add(name.toString());
    }
    return names; //data.keys.toL\ist();
  } catch (e) {
    return [
      "Competition Name Error",
      e.toString(),
      teamName,
      names.toString(),
      curKey
    ];
  }
}

// Future<List<String>> getCompetitionTeams() async {
//   try {
//     final String response =
//         await rootBundle.loadString('databases/database.json'); // Issue here
//     Map<String, dynamic> data = await json.decode(response);
//     List<String> teamNameNumber = [];
//     data.forEach((key, value) => {teamNameNumber.add(value.toString())});
//     return teamNameNumber; //data.keys.toL\ist();
//   } catch (e) {
//     return ["Competition Team Error", e.toString()];
//   }
// }

Future<Map<String, int>> initCompMap() async {
  List names = await getCompetitionNames();
  Map<String, int> map = {};

  for (int i = 0; i < names.length; i++) {
    map[names[i].toString()] = i;
  }
  // for (String name in names) {}
  return map;
}

List zip(List lsta, List lstb) {
  List nlst = [];
  for (int a = 0; a < lsta.length; a += 1) {
    nlst.add([lsta[a], lstb[a]]);
  }
  return nlst;
}
