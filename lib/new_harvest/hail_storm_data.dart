import 'dart:io';

import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HailStormData extends StatelessWidget {
  final int index;
  final Function callback;

  HailStormData(this.index, this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de la granizada",
      backgroundColor: Color(0xff203152),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
                child: Text("Galería"),
                onPressed: () async {
                  File file =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    model.hailStorm = file;
                    callback(index, true);
                  }
                }),
            RaisedButton(
                child: Text("Cámara"),
                onPressed: () async {
                  model.hailStorm =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                }),
            SizedBox(
              height: 20,
            ),
            Center(
                child: model.hailStorm == null
                    ? Text(
                        "Imagen no seleccionada.",
                        style: TextStyle(color: Colors.white),
                      )
                    : Image.file(model.hailStorm)),
          ],
        ),
      ),
    );
  }
}
