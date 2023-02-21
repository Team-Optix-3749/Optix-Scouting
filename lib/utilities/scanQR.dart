// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:optix_scouting/utilities/QRScannerOverlay.dart';
// // DEPRECATED FOR THE TIME BEING
// class ScanQrPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _ScanQrPageState();
// }

// class _ScanQrPageState extends State<ScanQrPage> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mobile Scanner')),
//       body: MobileScanner(
//         // fit: BoxFit.contain,
//         controller: MobileScannerController(
//           facing: CameraFacing.back,
//           torchEnabled: true,
//         ),
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           for (final barcode in barcodes) {
//             debugPrint('Barcode found! ${barcode.rawValue}');
//           }
//         },
//       ),
//     );
//   }
// }
