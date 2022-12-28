import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/cosechar/local.dart';
import 'package:cosecheros/cosechar/online.dart';
import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/details/cosecha_detail.dart';
import 'package:cosecheros/details/preview_marker.dart';
import 'package:cosecheros/details/tweet_detail.dart';
import 'package:cosecheros/map/MapMarker.dart';
import 'package:cosecheros/map/multichoice_dialog.dart';
import 'package:cosecheros/map/tile_provider_wms.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:cosecheros/widgets/grid_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

import '../models/form_spec.dart';
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

  ClusterManager _cluster;
  Set<Marker> markers = {};
  StreamSubscription _markerSubscription;

  //BitmapDescriptor _markerProfile;
  Map<String, BitmapDescriptor> _markerIcons;

  PersistentBottomSheetController _bottomSheetController;
  Cluster<MapMarker> selected;

  Stream<Iterable<Cosecha>> _streamCosecha() => Database.instance
      .cosechas(DateTime.now().subtract(Duration(days: 30)))
      .snapshots()
      .map((event) =>
          event.docs.map((e) => e.data()).where((e) => e.latLng != null))
      .startWith([]);

  Stream<Iterable<Tweet>> _streamTweets() => Database.instance
          .tuits(DateTime.now().subtract(Duration(days: 7)))
          .snapshots(includeMetadataChanges: true)
          .map((event) {
        if (event.metadata.isFromCache) {
          print("_streamTweets: from cache! ${event.docs.length}");
        } else {
          print("_streamTweets: online: ${event.docs.length}");
        }

        return event.docs
            .map((e) => e.data())
            .where((e) => e != null && e.isValid());
      }).startWith([]);

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

    _cluster = ClusterManager<MapMarker>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 2, 4, 6, 8, 10, 12, 14, 16],
      extraPercent: 0.2,
      stopClusteringZoom: 17.0,
    );

    Stream<List<dynamic>> markerStream =
        _streamCosecha().combineLatest(_streamTweets(), (a, b) => [...a, ...b]);

    _markerSubscription = markerStream.listen((event) {
      _cluster.setItems(event
          .expand((e) => _createMarker(e))
          .where((e) => e != null)
          .toList(growable: false));
    });
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  void dispose() {
    _markerSubscription.cancel();
    super.dispose();
  }

  Future<Marker> Function(Cluster<MapMarker>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          anchor: Offset(0.5, 0.5),
          onTap: () {
            hideBottomSheet();

            final LocalHistoryEntry entry = LocalHistoryEntry(onRemove: () {
              hideBottomSheet();
            });

            ModalRoute.of(context).addLocalHistoryEntry(entry);

            if (cluster.isMultiple) {
              setState(() {
                selected = cluster;
              });
            } else {
              final only = cluster.items.first;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext builder) {
                  return DraggableScrollableSheet(
                    expand: false,
                    builder: (context, scrollController) {
                      if (only.model is Cosecha) {
                        return CosechaDetail(only.model, scrollController);
                      } else if (only.model is Tweet) {
                        return TweetDetail(only.model.id, scrollController);
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            }

            // if (!cluster.isMultiple) {

            // } else {
            //   _bottomSheetController = showBottomSheet(
            //       context: context,
            //       constraints: BoxConstraints.loose(Size(
            //         double.infinity,
            //         MediaQuery.of(context).size.height * 0.9,
            //       )),
            //       builder: (context) => PreviewMarker(cluster.items));
            // }
          },
          icon: await _getMarker(cluster),
        );
      };

  Future<BitmapDescriptor> _getMarker(Cluster<MapMarker> cluster) async {
    if (cluster.isMultiple) {
      return await _getMarkerBitmap(cluster);
    } else {
      return cluster.items.first.icon;
    }
  }

  Future<BitmapDescriptor> _getMarkerBitmap(Cluster<MapMarker> cluster) async {
    int size = 80;
    if (kIsWeb) size = (size / 2).floor();

    final String text = cluster.count.toString();
    final Color primaryColor = cluster.items.first.color;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Color backgroundColor = Theme.of(context).colorScheme.background;
    final Paint backgroundPaint = Paint()
      ..color = primaryColor.withOpacity(.04);

    final double stroke = 4;
    final Paint primaryPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final Offset center = Offset(size / 2, size / 2);

    canvas.drawCircle(center, size / 2.0, backgroundPaint);
    canvas.drawCircle(center, size / 2.0 - stroke / 2, primaryPaint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

    painter.text = TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: size / 2.5,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8
              ..color = backgroundColor,
          ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    painter.text = TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: size / 2.5,
            color: primaryColor,
          ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
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
    return Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        markers: markers,
        compassEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: initPos,
        tileOverlays: selectedTilesProvider,
        onCameraMove: _cluster.onCameraMove,
        onCameraIdle: _cluster.updateMap,
        onMapCreated: (GoogleMapController controller) {
          print("onMapCreated");
          _controller.complete(controller);
          controller.setMapStyle(_mapStyle);
          _cluster.setMapId(controller.mapId);
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
        child: Align(
          alignment: Alignment.topRight,
          child: topButtons(),
        ),
      ),
      if (markers.isEmpty)
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
        ),
      SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _asyncCosecharButton(context),
          ),
        ),
      ),
      if (selected != null)
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: PreviewMarker(selected.items),
            ),
          ),
        ),
    ]);
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
    setState(() {
      selected = null;
    });
    if (_bottomSheetController != null) {
      _bottomSheetController.close();
      _bottomSheetController = null;
    }
  }

  Widget _asyncCosecharButton(BuildContext context) {
    return FutureBuilder<QuerySnapshot<FormSpec>>(
        future: Database.instance.forms().get(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Text(snap.error.toString());
          }

          List<FormSpec> forms;
          if (snap.connectionState == ConnectionState.done) {
            forms = snap.data.docs
                .map((e) => e.data())
                .where((e) => e.isValid())
                .toList();
          }
          print(
              "Home: Cosechar: ${snap.connectionState}, forms=${forms?.length}");

          return FloatingActionButton.extended(
            heroTag: null,
            onPressed: forms == null ? null : () => _onCosechar(context, forms),
            label: Text(
              'Cosechar',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          );
        });
  }

  void _onCosechar(BuildContext context, List<FormSpec> forms) async {
    var selected = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Wrap(
                runSpacing: 12,
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    alignment: Alignment.center,
                    child: Text(
                      '¿Qué vas a cosechar?',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ...forms.map(
                    (e) => SizedBox.square(
                      dimension: 128,
                      child: GridIconButton(
                        title: e.label,
                        background: e.color,
                        icon: e.icon == null
                            ? null
                            : Image.network(
                                e.icon,
                                fit: BoxFit.contain,
                                // En caso de no existir, fallback a este icono
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.report_rounded, size: 48),
                              ),
                        onPressed: () => Navigator.pop(
                          context,
                          e.getUrl().href,
                        ),
                      ),
                    ),
                  ),
                  if (kDebugMode)
                    SizedBox.square(
                      dimension: 128,
                      child: GridIconButton(
                        title: "Local",
                        background: Colors.black87,
                        onPressed: () => Navigator.pop(context, "local"),
                      ),
                    ),
                ],
              ),
            ),
          );
        });

    if (selected == "local") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocalForm()),
      );
    } else if (selected != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnlineForm(selected)),
      );
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          SizedBox(height: 4),
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
          SizedBox(height: 4),
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
        ],
      ),
    );
  }

  // TODO: Traelo desde los forms?
  final colors = {
    'granizada': Color(0xFF5F8FEE),
    'helada': Color(0xFF51C6CC),
    'inundacion': Color(0xFF7075C8),
    'inundaciones': Color(0xFF7075C8),
    'sequia': Color(0xFFF9787A),
    'incendios': Color(0xFFF9787A),
    'deriva': Color(0xFF4ED23A),
    'fallback-tuit': Color(0xFF6E99EF),
  };

  List<MapMarker> _createMarker(dynamic model) {
    if (_markerIcons == null) {
      return null;
    }
    if (model is Cosecha) {
      return [
        MapMarker(
          model: model,
          icon: _markerIcons.getOr(model.form.toLowerCase(), 'fallback'),
          color: colors[model.form.toLowerCase()],
          latLng: model.latLng,
        ),
      ];
    }
    if (model is Tweet) {
      return model.places
          .map((e) => MapMarker(
                model: model,
                icon: _markerIcons.getOr(
                  model.event_type + "-tuit",
                  'fallback-tuit',
                ),
                color: colors.getOr(model.event_type, 'fallback-tuit'),
                latLng: LatLng(e.lat, e.lon),
              ))
          .toList();
    }
    return null;
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcons != null) return;
    final config = createLocalImageConfiguration(context);

    fromAsset(String asset) => BitmapDescriptor.fromAssetImage(config, asset);

    final icons = {
      'fallback': await fromAsset('assets/app/pin.png'),
      'fallback-tuit': await fromAsset('assets/app/fallback-tuit.png'),
      'granizada': await fromAsset('assets/app/granizo.png'),
      'granizo-tuit': await fromAsset('assets/app/granizo-tuit.png'),
      'helada': await fromAsset('assets/app/helada.png'),
      'helada-tuit': await fromAsset('assets/app/helada-tuit.png'),
      'inundacion': await fromAsset('assets/app/inundacion.png'),
      'inundaciones-tuit': await fromAsset('assets/app/inundacion-tuit.png'),
      'sequia': await fromAsset('assets/app/sequia.png'),
      'deriva': await fromAsset('assets/app/deriva.png'),
    };

    setState(() {
      _markerIcons = icons;
    });
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
