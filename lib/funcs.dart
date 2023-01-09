import 'dart:convert';
import 'package:flutter/services.dart';

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
        await rootBundle.loadString('databases/teamEvents.json'); // Issue here
    final data = await json.decode(response);
    print(data[compName]);
    return data[compName];
  } catch (Exception) {
    print("err");
    return ["Competition Name Error"];
  }
}

Future<List> getCompetitionNames() async {
  try {
    final String response =
        await rootBundle.loadString('databases/teamEvents.json'); // Issue here
    final data = await json.decode(response);
    print(data.keys);
    return data.keys;
  } catch (Exception) {
    return ["Competition Name Error"];
  }
}

Map<String, int> initCompMap() {
  List names = getCompetitionNames() as List;
  List nums = [for (var a = 0; a < names.length; a += 1) a];
  return {for (var pair in zip(names, nums)) pair[0]: pair[1]};
}

List zip(List lsta, List lstb) {
  List nlst = [];
  for (int a = 0; a < lsta.length; a += 1) {
    nlst.add([lsta[a], lstb[a]]);
  }
  return nlst;
}
