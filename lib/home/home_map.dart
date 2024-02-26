import 'dart:async';

import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/details/cosecha_detail.dart';
import 'package:cosecheros/details/preview_marker.dart';
import 'package:cosecheros/details/tweet_detail.dart';
import 'package:cosecheros/home/alert_bottom.dart';
import 'package:cosecheros/home/button_csv.dart';
import 'package:cosecheros/home/button_filters.dart';
import 'package:cosecheros/home/button_layers.dart';
import 'package:cosecheros/home/button_location.dart';
import 'package:cosecheros/home/button_profile.dart';
import 'package:cosecheros/home/logo.dart';
import 'package:cosecheros/home/maker_helper.dart';
import 'package:cosecheros/main.dart';
import 'package:cosecheros/models/MapMarker.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/polygon.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/utils/extensions.dart';
import 'package:cosecheros/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

import '../utils/helpers.dart';

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
  List<dynamic> lastMarkers; // Últimos markers para el csv

  bool isLoading = true;
  StreamSubscription _filterSubscription;

  Set<Polygon> polygons = <Polygon>{};
  StreamSubscription _polygonsSubscription;

  //BitmapDescriptor _markerProfile;
  Map<String, BitmapDescriptor> _markerIcons;

  PersistentBottomSheetController _bottomSheetController;
  PersistentBottomSheetController _alertBottomSheetController;
  Cluster<MapMarker> selected;

  Set<TileOverlay> selectedTilesProvider = {};

  StreamController<Duration> filterController =
      StreamController<Duration>.broadcast();

  Stream<Iterable<Cosecha>> _streamCosecha() => filterController.stream
      .startWith(Duration(days: 1))
      .switchMap((filter) => Database.instance
          .cosechas(DateTime.now().subtract(filter))
          .snapshots()
          .map((event) {
            if (event.metadata.isFromCache) {
              print("_streamCosecha: from cache! ${event.docs.length}");
            } else {
              print("_streamCosecha: online: ${event.docs.length}");
            }
            return event.docs.map((e) => e.data()).where((e) => e.latLng != null);
          })
          .startWith([])
      );

  Stream<Iterable<Tweet>> _streamTweets() => filterController.stream
      .startWith(Duration(days: 1))
      .switchMap((filter) => Database.instance
              .tuits(DateTime.now().subtract(filter))
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
          }).startWith([]));

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

    _markerSubscription = markerStream.listen((event) async {
      print('Home: markerStream: ${event.length}');

      //print('Home: simule DELAY');
      //await Future.delayed(const Duration(seconds: 5));

      lastMarkers = event;
      _cluster.setItems(event
          .expand((e) => _createMarker(e))
          .where((e) => e != null)
          .toList(growable: false));
    });

    _polygonsSubscription = Database.instance
        .polygons(DateTime.now().subtract(Duration(hours: 3)))
        .snapshots()
        .listen((event) {
      setState(() {
        polygons = event.docs
            .map((e) => e.data())
            .map((polygon) => _buildPolygon(polygon))
            .toSet();
        showAlert();
      });
    });

    _filterSubscription = filterController.stream
      .listen((e) {
        setState(() {
          print("Home: set is loading");
          isLoading = true;
        });
      });
  }

  void showAlert() {
    if (polygons.isNotEmpty && _bottomSheetController == null) {
      _alertBottomSheetController =
          scaffoldKey.currentState.showBottomSheet((context) => AlertBottom());
      _alertBottomSheetController.closed.then((value) {
        _alertBottomSheetController = null;
      });
    }
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Home: Set markers: ${markers.length}');
    setState(() {
      this.markers = markers;
      print("Home: set is not loading");
      this.isLoading = false;
    });
  }

  Polygon _buildPolygon(SMNPolygon polygon) {
    final String polygonIdVal = 'polygon_${polygon.id}';
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final color = Color(0xFFE178F9);

    return Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: color,
      strokeWidth: 2,
      fillColor: color.withOpacity(0.04),
      points: polygon.polygon
          .map((pos) => latLngFromGeoPos(pos))
          .toList(growable: false),
      onTap: () {
        print(polygonId);
      },
    );
  }

  @override
  void dispose() {
    _markerSubscription.cancel();
    _polygonsSubscription.cancel();
    _filterSubscription.cancel();
    super.dispose();
  }

  Future<Marker> Function(Cluster<MapMarker>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          anchor: Offset(0.5, 0.5),
          onTap: () {
            if (cluster.isMultiple) {
              hideAlert();
              showPreviewMarker(cluster);
            } else {
              showDetail(cluster.items.first);
            }
          },
          icon: await _getMarker(cluster),
        );
      };

  void showDetail(MapMarker only) {
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

  void showPreviewMarker(Cluster<MapMarker> cluster) {
    // Guardamos el viejo controller para cerrarlo después del nuevo
    // Hay que cerrarlo a mano porque sinó queda un LocalHistoryEntry extra
    // y luego se necesitan varios "back" para cerrar la app.
    final oldController = _bottomSheetController;

    _bottomSheetController = scaffoldKey.currentState.showBottomSheet(
      (context) => PreviewMarker(cluster.items),
      constraints: BoxConstraints.loose(
        Size(
          double.infinity,
          MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    )
      // Cada vez que se cierre (correctamente) el bottomSheet
      // tratar de levantar la Alerta de nuevo
      ..closed.then((value) {
        _bottomSheetController = null;
        showAlert();
      });

    // Ahora tenemos otro bottomSheet en el Scaffold
    // podemos llamar a close() sin que se complete el closed (Future)
    // y por lo tanto, sin que se vuelva a abrir el Alert.
    if (oldController != null) {
      oldController.close();
    }
  }

  Future<BitmapDescriptor> _getMarker(Cluster<MapMarker> cluster) async {
    if (cluster.isMultiple) {
      return await getMarkerBitmap(cluster, context);
    } else {
      return cluster.items.first.icon;
    }
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
    if (pos != null) {
      final latlng = latLngFromPosition(pos);
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
        polygons: polygons,
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
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ButtonProfile(),
                const SizedBox(height: 4),
                ButtonLayers(
                  selectedTilesProvider: selectedTilesProvider,
                  onSelect: (selected) {
                    setState(() {
                      selectedTilesProvider = selected;
                    });
                  },
                ),
                const SizedBox(height: 4),
                ButtonFilters(controller: filterController),
                const SizedBox(height: 4),
                ButtonCsv(lastMarkers: lastMarkers),
                const SizedBox(height: 4),
                ButtonLocation(onPressed: updateByCurrentPos),
              ],
            ),
          ),
        ),
      ),
      if (isLoading)
        const SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
        ),
      const SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: const Logo(),
        ),
      )
    ]);
  }

  void hideBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController.close();
    }
  }

  void hideAlert() {
    if (_alertBottomSheetController != null) {
      _alertBottomSheetController.close();
    }
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
}
