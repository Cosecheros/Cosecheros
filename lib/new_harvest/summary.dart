import 'dart:async';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      backgroundColor: Color(0xfff5a623),
      marginTitle: EdgeInsets.all(0),
      marginDescription: EdgeInsets.all(0),
      centerWidget: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer<HarvestModel>(
                  builder: (context, model, child) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text("Cosecha",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          )),
                      Text(
                        "Revisa que todo este bien",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Granizada"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(model.hailStorm),
                              )
                            ],
                          )),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Granizo"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: model.hail != null
                                      ? Image.file(model.hail)
                                      : Text("alarma configurada"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          Text("Localización"),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              height: 200,
                              child: MapSummary(model.latLng))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text.rich(TextSpan(text: "Fecha/Hora: ", children: [
                        TextSpan(
                            text: "${model.dateTime}",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ])),
                      Text.rich(TextSpan(text: "Lluvia: ", children: [
                        TextSpan(
                            text: "${rainToString(model.rain)}",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ])),
//                      Text("Tamaño: ${model.size}"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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
      },
      onTap: (latLong) {},
    );
  }
}
