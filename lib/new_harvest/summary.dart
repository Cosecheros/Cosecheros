import 'dart:async';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Cosecha",
      description: "Revisa que todo esté bien.",
      backgroundColor: Color(0xFF01A0C7),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Fecha y hora", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${model.dateTime}"),
            Text("Lluvia", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${rainToString(model.rain)}"),
//              Text("Tamaño: ${model.size}"),
            SizedBox(height: 10),
            imagesSelected(model),
            SizedBox(height: 10),
            Text("Localización", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                height: 200,
                child: MapSummary(model.latLng))
          ],
        ),
      ),
    );
  }

  Widget imagesSelected(HarvestModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Granizada", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Image.file(model.hailStorm),
            )
          ],
        )),
        Expanded(
          child: Column(
            children: <Widget>[
              Text("Granizo", style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: model.hail != null
                    ? Image.file(model.hail)
                    : Text("alarma configurada"),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MapSummary extends StatefulWidget {
  final LatLng position;

  MapSummary(this.position);

  @override
  State<MapSummary> createState() => MapSummaryState();
}

class MapSummaryState extends State<MapSummary> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set.of(
          [Marker(markerId: MarkerId('selected'), position: widget.position)]),
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        target: widget.position,
        zoom: 11,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(_mapStyle);
      },
      onTap: (latLong) {},
    );
  }
}
