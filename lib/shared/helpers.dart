import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/forms/map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng latLngFromGeoPos(GeoPos pos) => LatLng(pos.latitude, pos.longitude);
LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);

GeoPos geoPosFromLatLng(LatLng latLng) => GeoPos(latLng.latitude, latLng.longitude);
GeoPos geoPosFromPosition(Position pos) => GeoPos(pos.latitude, pos.longitude);
// LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);
