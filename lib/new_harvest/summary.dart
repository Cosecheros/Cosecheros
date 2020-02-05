import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Resumen",
      backgroundColor: Color(0xfff5a623),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Granizada"),
              model.hailStorm != null
                  ? Image.file(model.hailStorm)
                  : Text("Arreglar esto xD"),
              Text("Granizo"),
              model.hail != null
                  ? Image.file(model.hail)
                  : Text("alarma configurada"),
              Text("Fecha/Hora: ${model.dateTime}"),
              Text(
                  "GeoPoint: ${model.geoPoint.latitude}/${model.geoPoint.longitude}"),
              Text("Lluvia: ${model.rain}"),
              Text("Tamaño: ${model.size}"),
            ],
          ),
        ),
      ),
    );
  }
}