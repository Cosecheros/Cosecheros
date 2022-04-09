import 'dart:math';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/**
 * Inspirado en:
 * https://www.azavea.com/blog/2013/01/14/wms-on-android/
 */
class WMSTileProvider implements TileProvider {
  final String layer;
  final String style;

  /**
   * image/vnd.jpeg-png: el servidor elije entre jpeg o png
   * image/png: sabe ser una mala opción
   * image/png8: png pero con la paleta de colores reducida
   * image/jpeg: sabe ser la opción más ligera (pero sin transparencia!)
   */
  final String format;

  WMSTileProvider(
      {this.layer, this.style, this.format = "image/vnd.jpeg-png8"});

  static final String BASE = "gn-idecor.mapascordoba.gob.ar";
  static final String PATH = "/geoserver/wms";

  static final TILE_ORIGIN = [-20037508.34789244, 20037508.34789244];
  static final double MAP_SIZE = 20037508.34789244 * 2;

  static const int width = 256;
  static const int height = 256;

  List<double> getBoundingBox(int x, int y, int zoom) {
    double tileSize = MAP_SIZE / pow(2, zoom);

    double minx = TILE_ORIGIN[0] + x * tileSize;
    double maxx = TILE_ORIGIN[0] + (x + 1) * tileSize;
    double miny = TILE_ORIGIN[1] - (y + 1) * tileSize;
    double maxy = TILE_ORIGIN[1] - y * tileSize;

    return [minx, miny, maxx, maxy];
  }

  Uri getUri(List<double> bbox) {
    return Uri.https(BASE, PATH, {
      "layers": layer,
      "format": format,
      "transparent": "true",
      "service": "WMS",
      "version": "1.1.1",
      "request": "GetMap",
      "styles": style,
      "tiled": "true",
      "srs": "EPSG:900913",
      "bbox": bbox.join(","),
      "width": "256",
      "height": "256",
    });
  }

  @override
  Future<Tile> getTile(int x, int y, int zoom) async {
    Uri uri = getUri(getBoundingBox(x, y, zoom));
    print("getTile: uri: $uri");
    var file = await DefaultCacheManager().getSingleFile(uri.toString());
    var bytes = await file.readAsBytes();
    print("getTile: size: ${(bytes.length / 1024).toStringAsFixed(2)} kb");
    return Tile(width, height, bytes);
  }
}
