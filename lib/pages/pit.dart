import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:optix_scouting/util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'dart:io' as io;

class Pit extends StatefulWidget {
  const Pit({Key? key, required this.teamName, required this.competition})
      : super(key: key);
  final String teamName;
  final String competition;
  static const String routeName = "/PitPage";
  @override
  _PitState createState() => _PitState();
}

class _PitState extends State<Pit> {
  var uuid = Uuid();

  final _imageKey = GlobalKey<ImagePainterState>();

  late ImagePicker imagePicker;
  late String autoPath;
  var _image;
  String? typePreset;
  Map<String, int> typePresets = {
    "Defense": 0,
    "Offense": 1,
    "All rounder": 2,
    // "Add preset": 2,
  };
  Map<int, Stack> typePresetIcons = {
    0: Stack(
      children: const [
        Icon(
          Icons.shield,
          color: Colors.black54,
        ),
      ],
    ),
    1: Stack(
      children: const [
        Icon(
          Icons.colorize,
          color: Colors.black54,
        ),
      ],
    ),
    2: Stack(
      alignment: Alignment.bottomLeft,
      children: const [
        Icon(
          Icons.shield,
          color: Colors.black54,
          size: 25,
          shadows: <Shadow>[
            Shadow(
              color: Colors.black54,
              blurRadius: 10,
            )
          ],
        ),
        Icon(
          Icons.colorize_outlined,
          color: Colors.white,
          size: 27,
          shadows: <Shadow>[
            Shadow(
              color: Colors.black54,
              blurRadius: 10,
            )
          ],
        ),
      ],
    ),
  };
  String? drivePreset;
  Map<String, int> drivePresets = {
    "West Coast": 0,
    "Swerve": 1,
    "Other": 2,
    // "Add preset": 2,
  };
  Map<int, Stack> drivePresetIcons = {
    0: Stack(
      children: const [
        Icon(
          Icons.open_with,
          color: Colors.black54,
        ),
      ],
    ),
    1: Stack(
      children: const [
        Icon(
          Icons.south,
          color: Colors.black54,
        ),
        Icon(
          Icons.north,
          color: Colors.black54,
        ),
      ],
    ),
    2: Stack(
      alignment: Alignment.bottomLeft,
      children: const [],
    ),
  };
  String? armPreset;
  Map<String, int> armPresets = {
    "Elevator": 0,
    "Telescope": 1,
    "None": 2,
    // "Add preset": 2,
  };
  Map<int, Stack> armPresetIcons = {
    0: Stack(
      children: const [
        Icon(
          Icons.elevator,
          color: Colors.black54,
        ),
      ],
    ),
    1: Stack(
      children: const [
        Icon(
          OctIcons.telescope_fill_16,
          color: Colors.black54,
        ),
      ],
    ),
    2: Stack(
      alignment: Alignment.bottomLeft,
      children: const [
        Icon(
          Icons.hide_source,
          color: Colors.black54,
          size: 25,
          shadows: <Shadow>[
            Shadow(
              color: Colors.black54,
              blurRadius: 10,
            )
          ],
        ),
      ],
    ),
  };

  void imagePopup(File image) {
    if (image != null) {
      print(image.path);
      showDialog(
        context: context,
        builder: (context) => Util.buildPopupDialog(
          context,
          "Robot",
          <Widget>[
            Image.file(
              _image,
              width: 500.0,
              height: 500.0,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      );
    }
  }

  void painter() {
    showDialog(
      context: context,
      builder: (context) => Util.buildPitPopupDialog(
        context,
        "Auto path",
        <Widget>[
          ImagePainter.asset(
            "assets/blue.png",
            height: 500.0,
            key: _imageKey,
            scalable: true,
            initialStrokeWidth: 3.5,
            initialColor: Colors.green,
            initialPaintMode: PaintMode.freeStyle,
            width: 331.0,
            controlsAtTop: false,
          ),
        ],
        savePainter,
      ),
    );
  }

  void savePainter() async {
    Uint8List image = await _imageKey.currentState!.exportImage() as Uint8List;
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/pits').create(recursive: true);
    String id = uuid.v1();

    final fullPath =
        '$directory/pits/${widget.teamName}_${widget.competition}_${typePreset!}_${drivePreset!}_${armPreset!}_${id}';
    autoPath = fullPath;
    final imageFile = File(fullPath + '_auto.png');
    imageFile.writeAsBytesSync(image);
  }

  void save(File robotFile, String robotType, String driveTrain,
      String clawType) async {
    // print(path.basename(robotFile.path.split("/").last));
    GallerySaver.saveImage(
      robotFile.path,
      albumName:
          '${widget.teamName}-${widget.competition}-${robotType}-${driveTrain}-${clawType}',
    ).then((bool? success) {
      setState(() {
        print('Image is saved');
      });
    });
    File other = await robotFile.copy(autoPath + '_robot.png');
  }

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIT'),
      ),
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 255),
            child: Center(
              child: Container(
                child: Stack(
                  children: [
                    _image != null
                        ? Stack(
                            children: [
                              Image.file(
                                _image,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                              Positioned(
                                right: 5.0,
                                bottom: 5.0,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_image != null) {
                                      imagePopup(_image);
                                    }
                                  },
                                  child: Icon(
                                    Icons.fullscreen,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () async {
                              var source = ImageSource.camera;
                              XFile? image = await imagePicker.pickImage(
                                  source: source,
                                  preferredCameraDevice: CameraDevice.rear);
                              setState(() {
                                _image = File(image!.path);
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                hint: const Text(
                  'Select Robot Type',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                items: typePresets.keys
                    .map(
                      (p) => DropdownMenuItem<String>(
                        value: p,
                        child: Container(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  p.trim(),
                                  strutStyle: StrutStyle(fontSize: 15.0),
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                child: typePresetIcons[typePresets[p]],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                value: typePreset,
                onChanged: (value) {
                  setState(() {
                    typePreset = value!;
                  });
                },
                buttonHeight: 40,
                dropdownWidth: 140,
                itemHeight: 40,
                dropdownMaxHeight: 160,
                onMenuStateChange: (isOpen) {
                  // if (!isOpen) {
                  //   _PresetController.clear();
                  // }
                },
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: const Text(
                'Select Drive Train',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              items: drivePresets.keys
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Container(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                p.trim(),
                                strutStyle: StrutStyle(fontSize: 15.0),
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              child: drivePresetIcons[drivePresets[p]],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: drivePreset,
              onChanged: (value) {
                setState(() {
                  drivePreset = value!;
                });
              },
              buttonHeight: 40,
              dropdownWidth: 140,
              itemHeight: 40,
              dropdownMaxHeight: 160,
              onMenuStateChange: (isOpen) {
                // if (!isOpen) {
                //   _PresetController.clear();
                // }
              },
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              hint: const Text(
                'Select Arm Type',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              items: armPresets.keys
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Container(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                p.trim(),
                                strutStyle: StrutStyle(fontSize: 15.0),
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              child: drivePresetIcons[drivePresets[p]],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: armPreset,
              onChanged: (value) {
                setState(() {
                  armPreset = value!;
                });
              },
              buttonHeight: 40,
              dropdownWidth: 140,
              itemHeight: 40,
              dropdownMaxHeight: 160,
              onMenuStateChange: (isOpen) {
                // if (!isOpen) {
                //   _PresetController.clear();
                // }
              },
            ),
          ),
          TextButton(
            onPressed: () {
              if (_image == null || typePreset == null || drivePreset == null) {
                showDialog(
                  context: context,
                  builder: (context) => Util.buildPopupDialog(
                    context,
                    "Fields missing",
                    <Widget>[Container(child: Text("Some fields are missing"))],
                  ),
                );
              } else {
                painter();
              }
            },
            child: Container(
              child: Text("Auto Path"),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_image == null ||
                  typePreset == null ||
                  drivePreset == null ||
                  autoPath == null) {
                showDialog(
                  context: context,
                  builder: (context) => Util.buildPopupDialog(
                    context,
                    "Fields missing",
                    <Widget>[
                      Container(child: Text(" Some fields are missing "))
                    ],
                  ),
                );
              } else {
                save(_image, typePreset!, drivePreset!, armPreset!);
              }
            },
            child: Container(
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
