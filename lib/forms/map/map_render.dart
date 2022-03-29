import 'package:cosecheros/forms/map/map_widget.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
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
      child: StreamBuilder<GeoPos>(
          initialData: element.point,
          stream: element.pointChanged,
          builder: (context, snapshot) {
            return Column(
              children: [
                LabelWidget("¿Donde ocurrió?"),
                SizedBox(height: 16),
                Text(
                  snapshot.data.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: MapWidget(
                    element: element,
                    dispatcher: dispatcher,
                  ),
                )
              ],
            );
          }),
    );
  }
}
