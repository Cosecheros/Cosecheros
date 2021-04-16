import 'package:cosecheros/shared/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';

class MapWidget extends StatefulWidget {
  final Map element;
  final FormElementEventDispatcherFunction dispatcher;

  MapWidget({@required this.element, this.dispatcher});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  GoogleMapController _controller;
  bool isLastKnownPos = false;
  String _mapStyle;

  void _moveMapTo(LatLng latLng) async {
    _controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void _updatePos(Position pos) async {
    _moveMapTo(latLngFromPosition(pos));
    widget.dispatcher(
      ChangeValueEvent(
          value: geoPosFromPosition(pos),
          elementId: widget.element.id,
          propertyName: Map.pointPropName),
    );
  }

  void _initPos() async {
    Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      if (widget.element.point == null && pos != null) {
        // TODO
        isLastKnownPos = true;
        _updatePos(pos);
      }
    });

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      if (pos != null && (widget.element.point == null || isLastKnownPos)) {
        // TODO
        _updatePos(pos);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initPos();
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    GeoPos point = widget.element.point;

    return GoogleMap(
      mapType: MapType.normal,
      compassEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      markers: point != null
          ? Set.of([
              Marker(
                  markerId: MarkerId('selected'),
                  position: latLngFromGeoPos(point),
                  consumeTapEvents: true)
            ])
          : null,
      initialCameraPosition: CameraPosition(
          target: latLngFromGeoPos(point), zoom: 8),
      onMapCreated: (controller) {
        _controller = controller;
        controller.setMapStyle(_mapStyle);
      },
      onTap: _moveMapTo,
      onCameraMove: (CameraPosition pos) async => widget.dispatcher(
        ChangeValueEvent(
          value: geoPosFromLatLng(pos.target),
          elementId: widget.element.id,
          propertyName: Map.pointPropName),
      ),
      onCameraIdle: () {},
      gestureRecognizers: Set()..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
    );
  }
}
