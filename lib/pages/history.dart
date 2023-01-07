import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const History());

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  static const String routeName = "/HistoryPage";

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _contentOfFile = "";
  List<io.FileSystemEntity> files = [];
  List<String> fileNames = [];

  Future<String> getFilePath() async {
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath =
        '$appDocumentsPath/MATCH_Saturday, 7 Jan, 2023_3749_42_7dfa6f10-8e6c-11ed-9e9b-e57557456788.csv'; // 3
    setState(() {
      getFiles();
    });
    return filePath;
  }

  void getFiles() async {
    files.clear();
    fileNames.clear();
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); //
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    setState(() {
      List<io.FileSystemEntity> tempFiles =
          io.Directory('$appDocumentsPath/').listSync();
      for (io.FileSystemEntity file in tempFiles) {
        if (basename(file.path.split("/").last).split("_").first == "MATCH") {
          files.add(file);
          fileNames.add(basename(file.path.split("/").last));
        }
      }
    });
  }

  void saveFile(String text) async {
    io.File file = io.File(await getFilePath()); // 1
    file.writeAsString(text); // 2
  }

  void readFile() async {
    io.File file = io.File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HISTORY'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _contentOfFile,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => {saveFile("hehehehawhawhaw")},
              child: Text("Save File"),
            ),
            TextButton(
              onPressed: () => {readFile()},
              child: Text("Read File"),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: fileNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(children: [
                      Text(fileNames[index].split("_")[])
                    ],);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
