import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../shared/image_selector.dart';

class HailStormData extends StatelessWidget {
  final Function callback;

  HailStormData(this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de la granizada",
      description: "Sacá una foto al granizo como indica el dibujo.",
      backgroundColor: Color(0xFF01A0C7),
      scrollable: false,
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          children: <Widget>[
            Expanded(
                child: model.hailStorm == null
                    ? Image.asset("assets/Granizada.jpg")
                    : Image.file(model.hailStorm)),
            SizedBox(
              height: 20,
            ),
            ImageSelector(onPicked: (file) {
              model.hailStorm = file;
              callback(this, slideOptions.NEXT_ENABLED);
            }),
          ],
        ),
      ),
    );
  }
}
