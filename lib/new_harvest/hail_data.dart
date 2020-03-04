import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/image_selector.dart';

class HailData extends StatelessWidget {
  final Function callback;

  HailData(this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de un granizo",
      marginDescription: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      widgetDescription: Text(
        "1. Elige un granizo.\n" +
            "2. Levantalo con una bolsa.\n" +
            "3. Quitale todo el aire que puedas.\n" +
            "4. Metelo en el congelador por 30 minutos.\n" +
            "5. Y por último tomale una foto con una regla.",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        textAlign: TextAlign.start,
      ),
      backgroundColor: Color(0xFF01A0C7),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: model.hail == null
                    ? Image.asset(
                        "assets/FotoGranizo.jpg",
                      )
                    : Image.file(model.hail)),
            SizedBox(
              height: 20,
            ),
            ImageSelector(
              onPicked: (file) {
                model.hail = file;
                callback(this, slideOptions.NEXT_ENABLED);
              },
            ),
            OutlineButton(
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                highlightedBorderColor: Colors.white,
                child: Text("Configurar alarma",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async {
                  callback(this, slideOptions.NEXT_ENABLED);
                }),
          ],
        ),
      ),
    );
  }
}
