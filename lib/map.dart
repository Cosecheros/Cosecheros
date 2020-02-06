import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapRecent extends StatefulWidget {
  @override
  MapRecentState createState() => MapRecentState();
}

class MapRecentState extends State<MapRecent> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initPosition = CameraPosition(
    target: LatLng(-31.416998, -64.183657),
    zoom: 10,
  );

  final Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
      },
    );
  }
}