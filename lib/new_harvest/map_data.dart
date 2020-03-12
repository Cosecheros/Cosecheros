import 'dart:async';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapData extends StatefulWidget {
  @override
  State<MapData> createState() => MapDataState();
}

class MapDataState extends State<MapData> {
  Completer<GoogleMapController> _controller = Completer();
  bool isLastKnownPos = false;
  HarvestModel noListenModel;

  void _goTo(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void _updatePos(Position pos) async {
    final GoogleMapController controller = await _controller.future;
    LatLng latLng = LatLng(pos.latitude, pos.longitude);
    noListenModel.latLng = latLng;
    controller.moveCamera(CameraUpdate.newLatLng(latLng));
  }

  void _initPos() async {
    Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      if (noListenModel.latLng == null && pos != null) {
        isLastKnownPos = true;
        _updatePos(pos);
      }
    });

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      if (pos != null && (noListenModel.latLng == null || isLastKnownPos)) {
        _updatePos(pos);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    noListenModel = Provider.of<HarvestModel>(context, listen: false);
    _initPos();
  }

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Mapa",
      description: "Selecciona donde pasó la granizada",
      backgroundColor: Color(0xFF01A0C7),
      scrollable: false,
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => GoogleMap(
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapToolbarEnabled: false,
          markers: model.latLng != null
              ? Set.of([
                  Marker(
                      markerId: MarkerId('selected'),
                      position: model.latLng,
                      consumeTapEvents: true)
                ])
              : null,
          initialCameraPosition: CameraPosition(
              target: model.latLng ?? LatLng(-31.416998, -64.183657), zoom: 10),
          onMapCreated: _controller.complete,
          onTap: _goTo,
          onCameraMove: (CameraPosition pos) => model.latLng = pos.target,
          onCameraIdle: () async {  },
        ),
      ),
    );
  }
}
