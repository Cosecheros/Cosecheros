import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/shared/marker_icon_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cosecha_mini.dart';
import 'model.dart';

class HomeMap extends StatefulWidget {
  @override
  HomeMapState createState() => HomeMapState();
}

class HomeMapState extends State<HomeMap> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  BitmapDescriptor markerIcon;

  static final CameraPosition _initPosition = CameraPosition(
    target: LatLng(-31.416998, -64.183657),
    zoom: 10,
  );

  getPos() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    var current = await getPos();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(current.latitude, current.longitude),
        zoom: 12.0,
      ),
    ));
  }

  void initMarkerIcon() async {
    markerIcon = await MarkerGenerator(96.0).bitmapDescriptorFrom(
        Icons.place, Colors.black, Colors.transparent, Colors.transparent);
  }

  @override
  void initState() {
    super.initState();
    getPos();

    initMarkerIcon();

    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = Set();
    initMarkerIcon();

    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('dev')
              // TODO filtrar por gps/tiempo
              // .where("timestamp", isGreaterThan: from)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (snapshot.connectionState != ConnectionState.waiting) {
              _markers.addAll(
                snapshot.data.docs.map(
                  (QueryDocumentSnapshot doc) {
                    Cosecha model = Cosecha.fromSnapshot(doc);
                    return Marker(
                      markerId: MarkerId(doc.id),
                      position: model.latLng,
                      icon: markerIcon,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ConstrainedBox(
                          constraints: BoxConstraints.loose(
                            Size(double.infinity, 230),
                          ),
                          child: Card(
                            margin: EdgeInsets.all(16),
                            child: CosechaMini(model),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: _initPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(_mapStyle);
              },
              onTap: (e) {
                print(e);
              },
            );
          },
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
                  _currentLocation();
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
