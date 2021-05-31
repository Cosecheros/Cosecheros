import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/shared/helpers.dart';
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

class HomeMapState extends State<HomeMap> with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  BitmapDescriptor markerIcon;

  static CameraPosition initPos =
      CameraPosition(target: LatLng(-31.416998, -64.183657), zoom: 10);

  void initMarkerIcon() async {
    markerIcon = await MarkerGenerator(96.0).bitmapDescriptorFrom(
        Icons.place, Colors.black, Colors.transparent, Colors.transparent);
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
    }
  }

  void initPosition() async {
    var pos = await getLastPosition();
    if (pos != null) {
      print("initPosition: $pos");
      // Intentamos ganarle al mapa y reescribir la posición inicial
      initPos = CameraPosition(target: pos, zoom: 10);
      print("initPosition: $pos: wait for map controller");
      final GoogleMapController controller = await _controller.future;
      print("initPosition: $pos: controller ready, move!");
      controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 10.0),
      ));
    }
    updateByCurrentPos();
  }

  @override
  void initState() {
    super.initState();
    initPosition();
    initMarkerIcon();

    rootBundle.loadString('assets/app/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(Constants.collection)
              // TODO filtrar por gps/tiempo
              // .where("timestamp", isGreaterThan: from)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Set<Marker> _markers = Set();

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState != ConnectionState.waiting) {
              _markers.addAll(
                snapshot.data.docs.map(
                  (QueryDocumentSnapshot doc) {
                    print(doc.data());
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
              initialCameraPosition: initPos,
              onMapCreated: (GoogleMapController controller) {
                print("onMapCreated");
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
