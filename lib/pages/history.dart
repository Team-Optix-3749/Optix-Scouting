import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:optix_scouting/utilities/classes.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../util.dart';

void main() => runApp(const History());

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  static const String routeName = "/HistoryPage";

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late SlidableController slidableConroller;
  List<HistoryEntry> items = [];
  List<Slidable> widgets = [];

  List<io.FileSystemEntity> files = [];

  int reset = 0;

  List<String> fileNames = [];

  Future<String> getFilePath(String fileName) async {
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName'; // 3
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
      if (basename(file.path.split("/").last).split("_").first == "MATCH" &&
          file.path.contains("json")) {
        files.add(file);
        fileNames.add(basename(file.path.split("/").last));
      }
    }
    items = List.generate(
      fileNames.length,
      (index) => HistoryEntry(
        fileNames[index].split("_")[4],
        int.parse(fileNames[index].split("_")[2]),
        int.parse(fileNames[index].split("_")[3]),
        fileNames[index].split("_")[6].split(".").first,
        index,
        fileNames[index].split("_")[5],
        fileNames[index].split("_")[1],
      ),
    );
    setState(() {});
  }

  readFile(String fileName) async {
    io.File file = io.File(await getFilePath(fileName)); // 1
    String fileContent = await file.readAsString(); // 2

    return fileContent;
  }

  Widget _slidableWithLists(BuildContext context, int index, Axis direction) {
    final HistoryEntry item = items[index];

    return Slidable(
      direction: direction,
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
            key: UniqueKey(),
            onDismissed: () {
              items.removeAt(index);
              files[index].delete();
              files.removeAt(index);
              fileNames.removeAt(index);
              setState(() {});
            }),
        children: [
          SlidableAction(
            onPressed: (con) {
              setState(() {});
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          // SlidableAction(
          //   onPressed: (BuildContext) {
          //     setState(() {});
          //   },
          //   backgroundColor: Color(0xFF0bbcd2),
          //   foregroundColor: Colors.white,
          //   icon: Icons.archive,
          //   label: 'Archive',
          // ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (con) async {
              String data = await readFile(fileNames[index]);
              showDialog(
                context: context,
                builder: (context) => Util.buildPopupDialog(
                  context,
                  "QR Code",
                  <Widget>[
                    SizedBox(
                      height: 295,
                      width: 295,
                      child: QrImage(
                        data: data,
                        version: QrVersions.auto,
                        size: 295,
                      ),
                    ),
                  ],
                ),
              );
              setState(() {});
            },
            backgroundColor: const Color(0xFF0b2262),
            foregroundColor: Colors.white,
            icon: Icons.qr_code_2,
            label: 'Qr Code',
          ),
          SlidableAction(
            onPressed: (con) async {
              String data = await readFile(fileNames[index]);
              JsonCodec codec = const JsonCodec();
              Map<String, dynamic> parsed = codec.decode(data);
              dynamic values = parsed["events"];
              print(parsed);
              List<dynamic> lst = values;
              Color color = Colors.black;
              if (parsed["balanced"].toString().split('').contains('1')) {
                color = const Color.fromARGB(255, 78, 118, 247);
              }
              if (parsed["balanced"].toString().split('').contains('2')) {
                color = const Color.fromARGB(255, 243, 57, 82);
              }
              showDialog(
                context: context,
                builder: (context) => Util.buildPopupDialog(
                  context,
                  parsed["comp"],
                  <Widget>[
                    Row(
                      children: [
                        Text(
                          "Match ${parsed["matchNumber"]}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Balance",
                                  style: TextStyle(fontSize: 13, color: color),
                                ),
                              ),
                              Icon(
                                Icons.check_box,
                                color: color,
                                size: 25,
                              ),
                              Align(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "",
                                  style: TextStyle(fontSize: 5, color: color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.417,
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5,
                              ),
                              itemCount: 27, // <-- required
                              itemBuilder: (_, i) {
                                if (lst[i % 3][(i / 3).floor()] == 0) {
                                  return Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Center(
                                      // child: Text('$index'),

                                      child: OutlinedButton(
                                        onPressed: (() {}),
                                        child: Container(
                                            // child: Text("${initialData[index]}"),
                                            ),
                                      ),
                                    ),
                                  );
                                } else if (lst[i % 3][(i / 3).floor()] == 1) {
                                  return Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Center(
                                      // child: Text('$index'),

                                      child: ElevatedButton(
                                        onPressed: (() {}),
                                        child: Container(
                                            // child: Text("${initialData[index]}"),
                                            ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Center(
                                      // child: Text('$index'),

                                      child: ElevatedButton(
                                        onPressed: (() {}),
                                        child: Container(
                                            // child: Text("${initialData[index]}"),
                                            ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                    ),

                    // Container(
                    //   height: 295,
                    //   width: 295,
                    //   child: QrImage(
                    //       data: data, version: QrVersions.auto, size: 295),
                    // ),
                  ],
                ),
              );
              setState(() {});
            },
            backgroundColor: const Color(0xFFb2F218),
            foregroundColor: Colors.white,
            icon: Icons.calendar_view_month,
            label: 'View',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: TextButton(
            onPressed: () async {
              var content = await readFile(fileNames[index]);
              showDialog(
                context: context,
                builder: ((context) =>
                    Util.buildPopupDialog(context, "QR Code", <Widget>[
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: QrImage(
                            data: content.replaceAll("\n", "---"),
                            version: QrVersions.auto,
                            size: 300),
                      )
                    ])),
              );
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              items[index].teamNumber.toString(),
                              // fileNames[index].split("_")[2],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              items[index].teamName,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14.5,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          "Match: ${items[index].matchNumber}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          "FIRST ENERGIZED: ${items[index].compName}",
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
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    "${items[index].date} : ${items[index].id}",
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      //const ListTile(title: Text('Slide me')),
    );
  }

  @override
  void initState() {
    getFiles();
    // MATCH_2023-01-18_3749_42_Team Optix_Rocket City Regional_37a52010-9780-11ed-8cce-a7459fb9f657
    // Team name 4
    // team number 2
    // Match number 3
    // Id 6
    // Index N/a
    // Competition name 5

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
        child: OrientationBuilder(builder: (context, orientation) {
          return ListView.builder(
            itemBuilder: ((context, index) {
              final Axis slidableDirection = orientation == Axis.horizontal
                  ? Axis.vertical
                  : Axis.horizontal;
              return _slidableWithLists(context, index, slidableDirection);
            }),
            itemCount: items.length,
          );
        }),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[

        //     Expanded(

        // child: ListView.builder(
        //   itemCount: fileNames.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container(
        //       padding: EdgeInsets.only(left: 16, right: 16),
        //       child: Column(
        //         children: [
        //           TextButton(
        //             onPressed: () async {
        //               var content = await readFile(fileNames[index]);
        //               showDialog(
        //                 context: context,
        //                 builder: ((context) => Util.buildPopupDialog(
        //                         context, "QR Code", <Widget>[
        //                       Container(
        //                         height: 300,
        //                         width: 300,
        //                         child: QrImage(
        //                             data: content.replaceAll("\n", "---"),
        //                             version: QrVersions.auto,
        //                             size: 300),
        //                       )
        //                     ])),
        //               );
        //             },
        //             child: Column(
        //               children: [
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                       child: Container(
        //                         padding: EdgeInsets.only(right: 8),
        //                         child: Column(
        //                           crossAxisAlignment:
        //                               CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               overflow: TextOverflow.ellipsis,
        //                               fileNames[index].split("_")[2],
        //                               style: TextStyle(
        //                                 fontSize: 15,
        //                               ),
        //                             ),
        //                             Text(
        //                               overflow: TextOverflow.ellipsis,
        //                               fileNames[index].split("_")[4],
        //                               style: TextStyle(
        //                                 color: Colors.grey[500],
        //                                 fontSize: 14.5,
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                     Column(
        //                       crossAxisAlignment:
        //                           CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           overflow: TextOverflow.ellipsis,
        //                           "Match: " +
        //                               fileNames[index].split("_")[3],
        //                           style: TextStyle(
        //                             fontSize: 15,
        //                           ),
        //                         ),
        //                         Text(
        //                           overflow: TextOverflow.ellipsis,
        //                           "FIRST ENERGIZED: " +
        //                               fileNames[index].split("_")[5],
        //                           style: TextStyle(
        //                             color: Colors.grey[500],
        //                             fontSize: 14.5,
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //                 Container(
        //                   padding: EdgeInsets.only(top: 4),
        //                   child: Text(
        //                     overflow: TextOverflow.ellipsis,
        //                     fileNames[index].split("_")[1] +
        //                         " : " +
        //                         fileNames[index]
        //                             .split("_")[6]
        //                             .split(".")
        //                             .first,
        //                     style: TextStyle(fontSize: 10),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             padding: EdgeInsets.only(bottom: 8, top: 4),
        //             child: Divider(
        //               thickness: 2,
        //               color: Color.fromARGB(64, 0, 0, 0),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
      // ],
      // ),
      // ),
    );
  }
}
