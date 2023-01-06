import 'dart:io' as io;


import 'package:flutter/material.dart';
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



  Future<String> getFilePath() async {
    io.Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/Friday, 6 Jan, 2023.csv'; // 3
    setState(() {
    files = io.Directory('$appDocumentsPath/').listSync();  
    });
    return filePath;
  }

  void saveFile(String text) async {
    io.File file = io.File(await getFilePath()); // 1
    // file.writeAsString(text); // 2
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
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(files[index].toString());
                        }),
                  )

          ],
        ),),
    );
  }
}
