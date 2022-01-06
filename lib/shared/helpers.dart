import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/forms/map/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

GeoPoint geoPoinFromGeoPos(GeoPos pos) => GeoPoint(pos.latitude, pos.longitude);
GeoPos geoPosFromLatLng(LatLng latLng) =>
    GeoPos(latLng.latitude, latLng.longitude);

GeoPos geoPosFromPosition(Position pos) => GeoPos(pos.latitude, pos.longitude);
Future<LatLng> getCurrentPosition() async {
  var pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  if (pos != null) {
    return latLngFromPosition(pos);
  }
  return null;
}
// LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);

Future<LatLng> getLastPosition() async {
  // Test if location services are enabled.
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return null;
    }
  }

  // Permissions are denied forever, handle appropriately.
  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  var pos = await Geolocator.getLastKnownPosition();
  if (pos == null) {
    return null;
  }

  return latLngFromPosition(pos);
}

LatLng latLngFromGeoPos(GeoPos pos) => LatLng(pos.latitude, pos.longitude);

LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);
