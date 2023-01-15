import 'package:cosecheros/models/polygon.dart';
import 'package:flutter/material.dart';

class AlertBottom extends StatelessWidget {
  const AlertBottom({Key key, this.polygons}) : super(key: key);

  final Set<SMNPolygon> polygons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.info_outline_rounded),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hay una alerta del Servicio Metereologico Nacional",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                // Text("Hace x minutos"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
