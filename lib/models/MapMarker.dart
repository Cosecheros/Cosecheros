import 'dart:ui';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker with ClusterItem {
  final dynamic model;
  final BitmapDescriptor icon;
  final LatLng latLng;
  final Color color;

  MapMarker({this.model, this.icon, this.color, this.latLng});

  @override
  LatLng get location => latLng;
}