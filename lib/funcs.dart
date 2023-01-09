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
  //Todo: Set up the API tag
  //Todo: After API setup, start on app:database integration
  try {
    final String response =
        await rootBundle.loadString('databases/teamEvents.json'); // Issue here
    final data = await json.decode(response);
    print(data[compName]);
    return data[compName];
  } catch (Exception) {
    return ["Competition Name Error"];
  }
}
