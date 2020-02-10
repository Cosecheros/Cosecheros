import 'dart:io';

import 'package:cosecheros/models/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HailStormData extends StatelessWidget {
  final Function callback;

  HailStormData(this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de la granizada",
      description: "Sacá una foto al granizo como indica el dibujo.",
      backgroundColor: Color(0xff203152),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: model.hailStorm == null
                    ? Image.asset("assets/Granizada.jpg")
                    : Image.file(model.hailStorm)
            ),
            SizedBox(
              height: 20,
            ),
            RawMaterialButton(
              onPressed: () async {
                File file =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  model.hailStorm = file;
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
                onPressed: () async {
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    model.hailStorm = file;
                    callback(this, slideOptions.NEXT_ENABLED);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
