import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/details/tweet_preview.dart';
import 'package:cosecheros/map/multichoice_dialog.dart';
import 'package:cosecheros/map/tile_provider_wms.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

import '../details/cosecha_preview.dart';
import 'tile_provider_debug.dart';

class HomeMap extends StatefulWidget {
  @override
  HomeMapState createState() => HomeMapState();
}

class HomeMapState extends State<HomeMap> with AutomaticKeepAliveClientMixin {
  static CameraPosition initPos = CameraPosition(
    target: LatLng(-31.416998, -64.183657),
    zoom: 10,
  );

  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  //BitmapDescriptor _markerProfile;
  Map<String, BitmapDescriptor> _markerIcons;

  PersistentBottomSheetController _bottomSheetController;

  static final _streamCosecha = Database.instance.cosechasRef.snapshots().map(
      (event) =>
          event.docs.map((e) => e.data()).where((e) => e.latLng != null));

  _streamTweets() => Database.instance
          .tuits(DateTime.now().subtract(Duration(days: 360)))
          .snapshots(includeMetadataChanges: true)
          .map((event) {
        if (event.metadata.isFromCache) {
          print("_streamTweets: from cache! ${event.docs.length}");
        } else {
          print("_streamTweets: online: ${event.docs.length}");
        }

        return event.docs
            .map((e) => e.data())
            .where((e) => e != null && e.isValid())
            .toList();
      });

  Stream<Iterable<dynamic>> markerStream() =>
      _streamCosecha.combineLatest(_streamTweets(), (a, b) => [...a, ...b]);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initPosition();
    CurrentUser.instance.setupToken();

    rootBundle.loadString('assets/app/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  void initPosition() async {
    var pos = await getLastPosition();
    if (pos != null) {
      print("initPosition: $pos");
      // Intentamos ganarle al mapa y reescribir la posición inicial
      initPos = CameraPosition(target: pos, zoom: 10);
      print("initPosition: wait for map controller");
      final GoogleMapController controller = await _controller.future;
      print("initPosition: controller ready, move!");
      controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 10.0),
      ));
    }
    updateByCurrentPos();
  }

  void updateByCurrentPos() async {
    final pos = await getCurrentPosition();
    final latlng = latLngFromPosition(pos);
    if (pos != null) {
      print("updateByCurrentPos: wait for map controller");
      final GoogleMapController controller = await _controller.future;
      print("updateByCurrentPos: controller ready, animating...");
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 12.0),
      ));
      // Asíncronamente guardar la posición del usuario (no usar wait)
      CurrentUser.instance.savePosition(geoPosFromLatLng(latlng));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _createMarkerImageFromAsset(context);
    return StreamBuilder<Iterable<dynamic>>(
      stream: markerStream(),
      builder: (BuildContext context, snapshot) {
        Set<Marker> _markers = Set();

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState != ConnectionState.waiting) {
          _markers.addAll(snapshot.data
              .expand((e) => _createMarker(e))
              .where((e) => e != null));
        }

        return Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: initPos,
            tileOverlays: selectedTilesProvider,
            onMapCreated: (GoogleMapController controller) {
              print("onMapCreated");
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
            onTap: (e) {
              hideBottomSheet();
              print(e);
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: getLogo(context),
              ),
            ),
          ),
          SafeArea(
            child: Align(alignment: Alignment.topRight, child: topButtons()),
          ),
          if (snapshot.connectionState == ConnectionState.waiting)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              ),
            )
        ]);
      },
    );
  }

  String getInitials(String input) =>
      input.split(' ').map((e) => e[0]).take(2).join();

  Widget getLogo(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          'Cosecheros',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Color(0xFFF5F5F5),
          ),
        ),
        // Solid text as fill.
        Text(
          'Cosecheros',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  void hideBottomSheet() {
    if (_bottomSheetController != null) {
      Navigator.of(context).pop();
      _bottomSheetController = null;
    }
  }

  showProfile() async {
    String name = CurrentUser.instance.data.name?.trim() ?? "";
    String photoURL = CurrentUser.instance.data.photo;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  foregroundImage:
                      photoURL == null ? null : NetworkImage(photoURL),
                  child: Text(name.isEmpty ? 'A' : getInitials(name)),
                ),
                SizedBox(height: 16),
                Text(
                  name.isEmpty ? "Anónimo" : name,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Cosechero aprendiz",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 16),
                TextButton(
                  child: Text(
                    "cambiar tipo de usuario".toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .set({"type": null});
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "cerrar sesión".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.red[600]),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget topButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.gps_fixed,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              updateByCurrentPos();
            },
          ),
          SizedBox(width: 4),
          FloatingActionButton(
            heroTag: null,
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.face_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              showProfile();
            },
          ),
          SizedBox(width: 4),
          FloatingActionButton(
            heroTag: null,
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.layers_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              showLayerSelector();
            },
          ),
        ],
      ),
    );
  }

  List<Marker> _createMarker(dynamic model) {
    if (_markerIcons == null) {
      return null;
    }
    if (model is Cosecha) {
      return [
        Marker(
          markerId: MarkerId(model.id),
          position: model.latLng,
          icon: _markerIcons.getOr(model.form.toLowerCase(), 'fallback'),
          anchor: Offset(0.5, 0.5),
          onTap: () {
            hideBottomSheet();
            _bottomSheetController = showBottomSheet(
              context: context,
              builder: (context) => previewContainer(
                child: CosechaPreview(model),
              ),
            );
          },
        )
      ];
    }
    if (model is Tweet) {
      return model.places
          .map((e) => Marker(
                markerId: MarkerId(model.id),
                position: LatLng(e.lat, e.lon),
                anchor: Offset(0.5, 0.5),
                icon: _markerIcons.getOr(
                    model.event_type + "-tuit", 'fallback-tuit'),
                onTap: () {
                  hideBottomSheet();
                  _bottomSheetController = showBottomSheet(
                    context: context,
                    builder: (context) => previewContainer(
                      child: TweetPreview(model),
                    ),
                  );
                },
              ))
          .toList();
    }
    // if (model is Position) {
    //   return [
    //     Marker(
    //       markerId: MarkerId("user_profile"),
    //       position: latLngFromPosition(model),
    //       icon: _markerProfile,
    //       zIndex: 100,
    //       anchor: Offset(0.5, 0.5),
    //       rotation: model.heading,
    //       onTap: showProfile,
    //     )
    //   ];
    // }
    return null;
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcons == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);

      final icons = {
        'fallback': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/pin.png'),
        'fallback-tuit': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/fallback-tuit.png'),
        'granizada': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/granizo.png'),
        'granizo-tuit': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/granizo-tuit.png'),
        'helada': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/helada.png'),
        'helada-tuit': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/helada-tuit.png'),
        'inundacion': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/inundacion.png'),
        'inundaciones-tuit': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/inundacion-tuit.png'),
        'sequia': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/sequia.png'),
        'deriva': await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/app/deriva.png'),
      };

      // final profile = await BitmapDescriptor.fromAssetImage(
      //     imageConfiguration, 'assets/app/profile.png');

      setState(() {
        _markerIcons = icons;
        // _markerProfile = profile;
      });
    }
  }

  Widget previewContainer({Widget child}) => ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: double.infinity),
        child: Card(
          margin: EdgeInsets.only(top: 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: child,
        ),
      );

  final allTilesProviders = {
    if (kDebugMode)
      "Debug": TileOverlay(
        tileOverlayId: const TileOverlayId('debug_overlay'),
        tileProvider: DebugTileProvider(),
        zIndex: 4,
      ),
    "Cartas del suelo": TileOverlay(
      tileOverlayId: const TileOverlayId('cartas_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.IDECOR_HOST,
        path: Constants.IDECOR_PATH,
        layer: "idecor:cartas_suelo_unidas_2021",
      ),
      zIndex: 2,
    ),
    "Humedad del suelo IDECOR": TileOverlay(
      tileOverlayId: const TileOverlayId('humedad_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.IDECOR_HOST,
        path: Constants.IDECOR_PATH,
        layer: "idecor:DSS_MSM_1",
      ),
      zIndex: 2,
    ),
    "Humedad del suelo CONAE": TileOverlay(
      tileOverlayId: const TileOverlayId('humedad_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.CONAE_HOST,
        path: Constants.CONAE_PATH,
        layer: "HumedadDeSuelos:DSS_MSM_1",
        format: "image/png",
      ),
      zIndex: 2,
    ),
    "Coberturas horticolas": TileOverlay(
      tileOverlayId: const TileOverlayId('horticolas_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.IDECOR_HOST,
        path: Constants.IDECOR_PATH,
        layer: "idecor:Nivel3_28_dic_2018_30m_completo",
      ),
      zIndex: 2,
    ),
    "Parcelas": TileOverlay(
      tileOverlayId: const TileOverlayId('parcelas_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.IDECOR_HOST,
        path: Constants.IDECOR_PATH,
        layer: "idecor:parcelas_graf",
        style: "sty_parcelas_vuelos",
      ),
      zIndex: 3,
    ),
    "Satelite": TileOverlay(
      tileOverlayId: const TileOverlayId('satelite_hires_overlay'),
      tileProvider: WMSTileProvider(
        host: Constants.IDECOR_HOST,
        path: Constants.IDECOR_PATH,
        layer: "idecor:Mosaico_CBAFeb2021",
        format: "image/jpeg",
      ),
      zIndex: 2,
    ),
  };

  Set<TileOverlay> selectedTilesProvider = {};

  void showLayerSelector() async {
    var selected = await showDialog<Set<TileOverlay>>(
      context: context,
      builder: (BuildContext context) {
        return MultiChoiceDialog(
          options: allTilesProviders,
          selected: selectedTilesProvider,
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedTilesProvider = selected;
      });
    }
  }
}
