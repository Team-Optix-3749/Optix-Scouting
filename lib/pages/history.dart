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
        '$appDocumentsPath/MATCH_Saturday, 7 Jan, 2023_3749_42_Team Optix_b135cdf0-8e73-11ed-9609-31ceb44044e5.csv'; // 3
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

    List<io.FileSystemEntity> tempFiles =
        io.Directory('$appDocumentsPath/').listSync();
    for (io.FileSystemEntity file in tempFiles) {
      if (basename(file.path.split("/").last).split("_").first == "MATCH") {
        files.add(file);
        fileNames.add(basename(file.path.split("/").last));
      }
    }
    setState(() {
      // List<io.FileSystemEntity> tempFiles =
      //     io.Directory('$appDocumentsPath/').listSync();
      // for (io.FileSystemEntity file in tempFiles) {
      //   if (basename(file.path.split("/").last).split("_").first == "MATCH") {
      //     files.add(file);
      //     fileNames.add(basename(file.path.split("/").last));
      //   }
      // }
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
  void initState() {
    getFiles();
    super.initState();
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
            Expanded(
              child: ListView.builder(
                itemCount: fileNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            print("HeHeHeHaww");
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fileNames[index].split("_")[2],
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          fileNames[index].split("_")[4],
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14.5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Match: " +
                                            fileNames[index].split("_")[3],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "FIRST ENERGIZED: " +
                                            fileNames[index].split("_")[5],
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14.5,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  fileNames[index].split("_")[1] +
                                      " : " +
                                      fileNames[index]
                                          .split("_")[6]
                                          .split(".")
                                          .first,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 8, top: 4),
                          child: Divider(
                            thickness: 2,
                            color: Color.fromARGB(64, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
