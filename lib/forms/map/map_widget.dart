import 'dart:async';

import 'package:cosecheros/shared/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';

class MapWidget extends StatefulWidget {
  final Map element;
  final FormElementEventDispatcherFunction dispatcher;

  MapWidget({@required this.element, this.dispatcher});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget>
    with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  void _animateMapTo(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void _dispatchPos(LatLng latLng) async {
    widget.dispatcher(
      ChangeValueEvent(
        value: geoPosFromLatLng(latLng),
        elementId: widget.element.id,
        propertyName: Map.pointPropName,
      ),
    );
  }

  void updateByCurrentPos() async {
    var pos = await getCurrentPosition();
    if (pos != null) {
      print("updateByCurrentPos: $pos: wait for map controller");
      final GoogleMapController controller = await _controller.future;
      print("updateByCurrentPos: $pos: controller ready, animating...");
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 12.0),
      ));
      _dispatchPos(pos);
    }
  }

  void initPosition() async {
    var pos = await getLastPosition();
    if (pos != null) {
      print("initPosition: $pos: wait for map controller");
      final GoogleMapController controller = await _controller.future;
      print("initPosition: $pos: controller ready, move!");
      controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 10.0),
      ));
      _dispatchPos(pos);
    }
    updateByCurrentPos();
  }

  @override
  void initState() {
    super.initState();

    if (widget.element.point == null) {
      initPosition();
    }

    rootBundle.loadString('assets/app/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    GeoPos point = widget.element.point ?? GeoPos(-31.416998, -64.183657);
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          compassEnabled: false,
          myLocationButtonEnabled: false,
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
          initialCameraPosition:
              CameraPosition(target: latLngFromGeoPos(point), zoom: 10),
          onMapCreated: (controller) {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
          onTap: (pos) {
            _animateMapTo(pos);
            _dispatchPos(pos);
          },
          gestureRecognizers: Set()
            ..add(Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer())),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.gps_fixed,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  updateByCurrentPos();
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
