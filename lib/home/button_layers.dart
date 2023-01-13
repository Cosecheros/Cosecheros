import 'package:cosecheros/home/multichoice_dialog.dart';
import 'package:cosecheros/home/tile_provider_debug.dart';
import 'package:cosecheros/home/tile_provider_wms.dart';
import 'package:cosecheros/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ButtonLayers extends StatelessWidget {
  const ButtonLayers({Key key, this.onSelect, this.selectedTilesProvider})
      : super(key: key);

  final Function(Set<TileOverlay>) onSelect;
  final Set<TileOverlay> selectedTilesProvider;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.layers_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        showLayerSelector(context);
      },
    );
  }

  void showLayerSelector(context) async {
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
      onSelect(selected);
    }
  }

  static final allTilesProviders = {
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
}
