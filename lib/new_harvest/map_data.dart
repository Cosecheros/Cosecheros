import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapData extends StatefulWidget {
  final int index;
  final Function callback;

  MapData(this.index, this.callback);

  @override
  State<MapData> createState() => MapDataState();
}

class MapDataState extends State<MapData> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Mapa",
      description: "Selecciona donde pasó la granizada",
      backgroundColor: Color(0xfff5a623),
      centerWidget: Expanded(
          child: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (latLong) {
          var geoPoint = GeoPoint(latLong.latitude, latLong.longitude);
          Provider.of<HarvestModel>(context, listen: false).geoPoint = geoPoint;
          setState(() {
            _markers.clear();
            _markers
                .add(Marker(markerId: MarkerId('selected'), position: latLong));
            widget.callback(widget.index, true);
          });
        },
      )),
    );
  }
}
