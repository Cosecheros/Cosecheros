import 'dart:io';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HailData extends StatelessWidget {
  final Function callback;

  HailData(this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de un granizo",
      marginTitle:
          EdgeInsets.only(top: 70.0, bottom: 0.0, left: 20.0, right: 20.0),
      widgetDescription: Text(
        "1. Elige un granizo.\n2. Levantalo con una bolsa.\n3. Quitale todo el aire que puedas.\n4. Metelo en el congelador por 30 minutos." +
            "\n5. Y por último tomale una foto con una regla.",
        style: TextStyle(color: Colors.white, fontSize: 18.0),
        textAlign: TextAlign.start,
        maxLines: 100,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Color(0xff9932CC),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: model.hail == null
                    ? Image.asset("assets/FotoGranizo.jpg")
                    : Image.file(model.hail)),
            SizedBox(
              height: 20,
            ),
            RawMaterialButton(
              onPressed: () async {
                File file =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  model.hail = file;
                  callback(this, slideOptions.NEXT_ENABLED);
                }
              },
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: 40.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blueAccent,
              padding: const EdgeInsets.all(15.0),
            ),
            SizedBox(
              height: 4,
            ),

            FlatButton(
                textColor: Colors.white,
                child: Text("Subir desde la galería",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async {
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    model.hail = file;
                    callback(this, slideOptions.NEXT_ENABLED);
                  }
                }),
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
