import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'models/harvest.dart';

class MapRecent extends StatefulWidget {
  @override
  MapRecentState createState() => MapRecentState();
}

class MapRecentState extends State<MapRecent> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  String _mapStyle;

  static final CameraPosition _initPosition = CameraPosition(
    target: LatLng(-31.416998, -64.183657),
    zoom: 10,
  );

  void getPos() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    getPos();
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('cosechas')
            // TODO filtrar por gps/tiempo
            // .where("timestamp", isGreaterThan: from)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if (snapshot.connectionState != ConnectionState.waiting) {
            _markers.addAll(snapshot.data.documents.map((DocumentSnapshot doc) {
              HarvestModel model = HarvestModel.fromSnapshot(doc);
              return Marker(
                  markerId: MarkerId(doc.documentID),
                  position: model.latLng,
                  onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 230,
                          child: Card(
                              margin: EdgeInsets.all(4),
                              child: showHarvest(model)),
                        ),
                      ));
            }));
          }
          return GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            compassEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _initPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
          );
        });
  }

  Widget showHarvest(HarvestModel model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              mayShowImage(model.stormThumb),
              SizedBox(width: 8),
              mayShowImage(model.hailThumb)
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            DateFormat.yMMMMd().format(model.dateTime),
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Lluvia: ${rainToString(model.rain)}",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Usuario: Anonimo",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 14,
        )
      ],
    );
  }

  Widget mayShowImage(String url) {
    return url != null
        ? CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              ),
            ),
            imageUrl: url,
            fit: BoxFit.cover,
            height: 100,
          )
        : Container();
  }
}
