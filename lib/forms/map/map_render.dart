import 'package:cosecheros/forms/map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

import 'map.dart';

class MapRenderer extends FormElementRenderer<Map> {
  @override
  Widget render(
      Map element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<GeoPos>(
            initialData: element.point,
            stream: element.pointChanged,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Text(
                    "¿Donde ocurrió?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 16),
                  Text(
                    snapshot.data.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // TODO: 60% de la pantalla
                    child: MapWidget(
                      element: element,
                      dispatcher: dispatcher,
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
