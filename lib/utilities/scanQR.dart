import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:optix_scouting/utilities/QRScannerOverlay.dart';

class ScanQrPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  // bool _screenOpened = false;
  // bool found = false;

  // //top left x
  // //top left y
  // //w
  // //h
  // List<double> rect = [0.0, 0.0, 0.0, 0.0];
  // MobileScannerArguments? arguments;
  // Barcode? barcode;
  // BarcodeCapture? capture;
  // Size size = Size(0, 0);

  // Future<void> onDetect(BarcodeCapture barcode) async {
  //   capture = barcode;
  //   List<Offset> tempPoints = barcode.barcodes.first.corners!;

  //   rect[0] = min(tempPoints[0].dx, tempPoints[3].dx) - 5;
  //   rect[1] = min(tempPoints[0].dy, tempPoints[1].dy) - 5;
  //   rect[2] = max(tempPoints[1].dx, tempPoints[2].dx) - rect[0] + 5;

  //   rect[3] = max(tempPoints[2].dy, tempPoints[3].dy) - rect[1] + 5;

  //   setState(() => this.barcode = barcode.barcodes.first);
  // }

  // // QRViewController? controller;
  // // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // // void _onQRViewCreated(QRViewController controller) {
  // //   setState(() => this.controller = controller);
  // //   controller.scannedDataStream.listen((scanData) {
  // //     setState(() => result = scanData);
  // //   });
  // // }

  // // In order to get hot reload to work we need to pause the camera if the platform
  // // is android, or resume the camera if the platform is iOS.
  // // @override
  // // void reassemble() {
  // //   super.reassemble();
  // //   if (Platform.isAndroid) {
  // //     controller!.pauseCamera();
  // //   } else if (Platform.isIOS) {
  // //     controller!.resumeCamera();
  // //   }
  // // }

  // // void readQr() async {
  // //   if (result != null) {
  // //     controller!.pauseCamera();
  // //     print(result!.code);
  // //     controller!.dispose();
  // //   }
  // // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Colors.black.withOpacity(0.5),
  //       appBar: AppBar(
  //         backgroundColor: Colors.pinkAccent,
  //         title: Text("Scanner",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  //         elevation: 0.0,
  //       ),
  //       body: Stack(
  //         children: [
  //           MobileScanner(
  //             onScannerStarted: (arguments) {
  //               setState(() {
  //                 this.arguments = arguments;
  //               });
  //             },
  //             onDetect: onDetect,
  //           ),
  //           CustomPaint(
  //             painter: ScannerOverlay(
  //                 Rect.fromLTWH(rect[0], rect[1], rect[2], rect[3])),
  //           )
  //           // overlay(
  //           //     // overlayColour: Colors.black.withOpacity(0.5),
  //           //     // size: size,
  //           //     // found: found,
  //           //     )
  //         ],
  //       ));
  // }

  // Widget overlay() {
  //   if (found) {
  //     return Positioned(
  //       left: rect[0],
  //       top: rect[1],
  //       width: rect[2],
  //       height: rect[3],
  //       child: CustomPaint(
  //         foregroundPainter: BorderPainter(),
  //         child: Container(
  //             // width: scanArea + 25,
  //             // height: scanArea + 25,

  //             ),
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       child: Text(found.toString()),
  //     );
  //   }
  // }

  // void _foundBarcode(Barcode capture, MobileScannerArguments? arguments) {
  //   found = capture.corners != null;
  //   if (found) {
  //     setState(() {});

  //     List<Offset> tempPoints = capture.corners!;
  //     // I/flutter ( 5061): [Offset(208.0, 47.0), Offset(364.0, 71.0), Offset(380.0, 203.0), Offset(203.0, 183.0)]

  //     // rect[0] = min(tempPoints[0].dx, tempPoints[3].dx) - 5;
  //     // rect[1] = min(tempPoints[0].dy, tempPoints[1].dy) - 5;

  //     rect[0] = min(tempPoints[0].dx, tempPoints[3].dx) - 5;
  //     rect[1] = min(tempPoints[0].dy, tempPoints[1].dy) - 5;
  //     rect[2] = max(tempPoints[1].dx, tempPoints[2].dx) - rect[0] + 5;

  //     rect[3] = max(tempPoints[2].dy, tempPoints[3].dy) - rect[1] + 5;
  //   }
  // }

  // @override
  // void dispose() {
  //   // cameraController.dispose();
  //   super.dispose();
  // }
  late MobileScannerController controller = MobileScannerController();
  Barcode? barcode;
  BarcodeCapture? capture;

  Future<void> onDetect(BarcodeCapture barcode) async {
    capture = barcode;
    setState(() => this.barcode = barcode.barcodes.first);
  }

  MobileScannerArguments? arguments;

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                scanWindow: scanWindow,
                controller: controller,
                onScannerStarted: (arguments) {
                  setState(() {
                    this.arguments = arguments;
                  });
                },
                onDetect: onDetect,
              ),
              if (barcode != null &&
                  barcode?.corners != null &&
                  arguments != null)
                CustomPaint(
                  painter: BarcodeOverlay(
                    barcode: barcode!,
                    arguments: arguments!,
                    boxFit: BoxFit.contain,
                    capture: capture!,
                  ),
                ),
              CustomPaint(
                painter: ScannerOverlay(scanWindow),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          height: 50,
                          child: FittedBox(
                            child: Text(
                              barcode?.displayValue ?? 'Scan something!',
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcode,
    required this.arguments,
    required this.boxFit,
    required this.capture,
  });

  final BarcodeCapture capture;
  final Barcode barcode;
  final MobileScannerArguments arguments;
  final BoxFit boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode.corners == null) return;
    final adjustedSize = applyBoxFit(boxFit, arguments.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final ratioWidth =
        (Platform.isIOS ? capture.width! : arguments.size.width) /
            adjustedSize.destination.width;
    final ratioHeight =
        (Platform.isIOS ? capture.height! : arguments.size.height) /
            adjustedSize.destination.height;

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode.corners!) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
