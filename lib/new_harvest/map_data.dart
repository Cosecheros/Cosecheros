import 'dart:async';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapData extends StatefulWidget {
  final Function callback;

  MapData(this.callback);

  @override
  State<MapData> createState() => MapDataState();
}

class MapDataState extends State<MapData> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initPosition = CameraPosition(
    target: LatLng(-31.416998, -64.183657),
    zoom: 10,
  );

  final Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Mapa",
      description: "Selecciona donde pasó la granizada",
      backgroundColor: Color(0xfff5a623),
      centerWidget: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _initPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

        onTap: (latLong) {
          Provider.of<HarvestModel>(context, listen: false).latLng = latLong;
          setState(() {
            _markers.clear();
            _markers
                .add(Marker(markerId: MarkerId('selected'), position: latLong));
            widget.callback(widget, slideOptions.NEXT_ENABLED);
          });
        },
      )
    );
  }
}
