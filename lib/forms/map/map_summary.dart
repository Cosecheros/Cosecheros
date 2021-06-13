import 'dart:async';

import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';

class MapSummary extends SummaryWidget<Map> {
  @override
  Widget render(BuildContext context, Map element) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MapInfo(element: element),
    );
  }
}

class MapInfo extends StatefulWidget {
  final Map element;
  MapInfo({@required this.element});

  @override
  _MapInfoState createState() => _MapInfoState();
}

class _MapInfoState extends State<MapInfo> {
  String subtitle;

  @override
  void initState() {
    super.initState();
    getPlacemarks();
  }

  void getPlacemarks() async {
    GeoPos pos = widget.element.point;
    var places = await Geolocator().placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
      localeIdentifier: 'es',
    );
    for (var p in places) {
      print(p.toJson());
    }
    if (places.length > 0) {
      setState(() {
        var p = places.first;
        subtitle = "Cerca de " +
            (p.subLocality.isNotEmpty
                ? p.subLocality
                : p.locality.isNotEmpty
                    ? p.locality
                    : p.subAdministrativeArea.isNotEmpty
                        ? p.subAdministrativeArea
                        : p.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoItem(
      title: "Ubicación.",
      subtitle: "${subtitle ?? ''}",
      childImage: MiniMapWidget(latLngFromGeoPos(widget.element.point)),
    );
  }
}

class MiniMapWidget extends StatefulWidget {
  final LatLng position;

  MiniMapWidget(this.position);

  @override
  State<MiniMapWidget> createState() => MiniMapWidgetState();
}

class MiniMapWidgetState extends State<MiniMapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/app/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: GoogleMap(
        mapType: MapType.normal,
        markers: Set.of([
          Marker(
            markerId: MarkerId('selected'),
            position: widget.position,
          )
        ]),
        mapToolbarEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        compassEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        liteModeEnabled: true,
        initialCameraPosition: CameraPosition(
          target: widget.position,
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(_mapStyle);
        },
      ),
    );
  }
}
