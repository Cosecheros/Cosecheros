import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/MapMarker.dart';

Future<BitmapDescriptor> getMarkerBitmap(Cluster<MapMarker> cluster, BuildContext context) async {
  int size = 80;
  if (kIsWeb) size = (size / 2).floor();

  final String text = cluster.count.toString();
  final Color primaryColor = cluster.items.first.color;

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Color backgroundColor = Theme.of(context).colorScheme.background;
  final Paint backgroundPaint = Paint()
    ..color = primaryColor.withOpacity(.04);

  final double stroke = 4;
  final Paint primaryPaint = Paint()
    ..color = primaryColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke;
  final Offset center = Offset(size / 2, size / 2);

  canvas.drawCircle(center, size / 2.0, backgroundPaint);
  canvas.drawCircle(center, size / 2.0 - stroke / 2, primaryPaint);

  TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

  painter.text = TextSpan(
    text: text,
    style: Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: size / 2.5,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = backgroundColor,
    ),
  );
  painter.layout();
  painter.paint(
    canvas,
    Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
  );

  painter.text = TextSpan(
    text: text,
    style: Theme.of(context).textTheme.bodyText1.copyWith(
      fontSize: size / 2.5,
      color: primaryColor,
    ),
  );
  painter.layout();
  painter.paint(
    canvas,
    Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
  );

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}