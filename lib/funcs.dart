import 'dart:convert';
import 'package:flutter/services.dart';

Future<String> getNameFromDB(String number) async {
  //Todo: Set up the API tag
  //Todo: After API setup, start on app:database integration
  try {
    final String response =
      await rootBundle.loadString('databases/database.json'); // Issue here
    final data = await json.decode(response);
    print(data[number]);
    return data[number];
  }
  catch (Exception){
    return "Team does not exist";
  }
  
}