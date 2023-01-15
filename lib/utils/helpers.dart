import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/geo_pos.dart';

GeoPoint geoPoinFromGeoPos(GeoPos pos) => GeoPoint(pos.latitude, pos.longitude);

GeoPos geoPosFromLatLng(LatLng latLng) =>
    GeoPos(latLng.latitude, latLng.longitude);

GeoPos geoPosFromPosition(Position pos) => GeoPos(pos.latitude, pos.longitude);

LatLng latLngFromGeoPos(GeoPos pos) => LatLng(pos.latitude, pos.longitude);

LatLng latLngFromPosition(Position pos) => LatLng(pos.latitude, pos.longitude);

Future<Position> getCurrentPosition() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Stream<Position> streamCurrentPosition() {
  return Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  );
}

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

  if (kIsWeb) {
    // getLastKnownPosition no está soportado en web
    // Pero está bueno pedir el permiso antes.
    return null;
  }

  var pos = await Geolocator.getLastKnownPosition();
  if (pos == null) {
    return null;
  }

  return latLngFromPosition(pos);
}

Future<String> download(String body, String name) async {
  if (await Permission.storage.request().isGranted) {
    var savedDir = Directory('/storage/emulated/0/Download');
    if (!(await savedDir.exists())) {
      savedDir = await getExternalStorageDirectory();
    }

    File f = File("${savedDir.path}/$name");
    f.writeAsString(body);
    return f.path;
  }
  return null;
}
