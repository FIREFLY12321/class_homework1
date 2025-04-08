// import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
// import 'dart:typed_data';
// import 'dart:ui'as ui;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// // Extra utility - create a shareable image from a color and icon
// class ShareableImage {
//   static Future<Uint8List?> createIconImage(Color color, IconData icon, String title) async {
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder);
//     final size = const Size(300, 300);
//
//     // Draw background
//     final paint = Paint()
//       ..shader = RadialGradient(
//         colors: [color, color.withOpacity(0.7), color.withOpacity(0.5)],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
//
//     // Draw icon
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: String.fromCharCode(icon.codePoint),
//         style: TextStyle(
//           fontSize: 150,
//           fontFamily: icon.fontFamily,
//           color: Colors.white.withOpacity(0.9),
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//
//     textPainter.layout();
//     textPainter.paint(
//       canvas,
//       Offset(
//         (size.width - textPainter.width) / 2,
//         (size.height - textPainter.height) / 2 - 20,
//       ),
//     );
//
//     // Draw title
//     final titlePainter = TextPainter(
//       text: TextSpan(
//         text: title,
//         style: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     );
//
//     titlePainter.layout(maxWidth: size.width);
//     titlePainter.paint(
//       canvas,
//       Offset(
//         (size.width - titlePainter.width) / 2,
//         size.height - titlePainter.height - 30,
//       ),
//     );
//
//     // Convert to image
//     final picture = recorder.endRecording();
//     final img = await picture.toImage(size.width.toInt(), size.height.toInt());
//     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//
//     return byteData?.buffer.asUint8List();
//   }
// }