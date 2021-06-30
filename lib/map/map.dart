import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:cosecheros/shared/marker_icon_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cosecha_preview.dart';
import 'model.dart';

class HomeMap extends StatefulWidget {
  @override
  HomeMapState createState() => HomeMapState();
}

class HomeMapState extends State<HomeMap> with AutomaticKeepAliveClientMixin {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  BitmapDescriptor _markerIcon;

  PersistentBottomSheetController _bottomSheetController;

  static CameraPosition initPos =
      CameraPosition(target: LatLng(-31.416998, -64.183657), zoom: 10);

  void initMarkerIcon() async {
    _markerIcon = await MarkerGenerator(96.0).bitmapDescriptorFrom(
        Icons.place, Colors.black, Colors.transparent, Colors.transparent);
  }

  @override
  void initState() {
    super.initState();
    initPosition();
    // initMarkerIcon();

    rootBundle.loadString('assets/app/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _createMarkerImageFromAsset(context);
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(Constants.collection)
              .where("timestamp",
                  isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
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
                    return _createMarker(model);
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
                if (_bottomSheetController != null)
                  _bottomSheetController.close();
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

  void updateByCurrentPos() async {
    final pos = await getCurrentPosition();
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

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size.square(48));
      final bitmap = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/app/plant_1.png');
      setState(() {
        _markerIcon = bitmap;
      });
    }
  }

  Marker _createMarker(Cosecha model) {
    if (_markerIcon != null) {
      return Marker(
        markerId: MarkerId(model.id),
        position: model.latLng,
        icon: _markerIcon,
        onTap: () => {
          _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) => ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: double.infinity),
              child: Card(
                margin: EdgeInsets.only(top: 36),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: CosechaPreview(model),
              ),
            ),
          ),
          _bottomSheetController.closed
              .then((_) => _bottomSheetController = null)
        },
      );
    } else {
      return Marker(
        markerId: MarkerId(model.id),
        position: model.latLng,
      );
    }
  }
}
