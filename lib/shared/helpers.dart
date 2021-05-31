import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/forms/map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng latLngFromGeoPos(GeoPos pos) => LatLng(pos.latitude, pos.longitude);
LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);

GeoPos geoPosFromLatLng(LatLng latLng) =>
    GeoPos(latLng.latitude, latLng.longitude);
GeoPos geoPosFromPosition(Position pos) => GeoPos(pos.latitude, pos.longitude);
// LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);

GeoPoint geoPoinFromGeoPos(GeoPos pos) => GeoPoint(pos.latitude, pos.longitude);

Future<LatLng> getLastPosition() async {
  var pos = await Geolocator()
      .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

  if (pos != null) {
    return latLngFromPosition(pos);
  }
  return null;
}

Future<LatLng> getCurrentPosition() async {
  var pos = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  if (pos != null) {
    return latLngFromPosition(pos);
  }
  return null;
}
