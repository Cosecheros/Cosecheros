import 'dart:io';

import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HailData extends StatelessWidget {
  final int index;
  final Function callback;

  HailData(this.index, this.callback);

  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Foto de un granizo",
      backgroundColor: Color(0xfff5a623),
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
                    model.hail = file;
                    callback(index, true);
                  }
                }),
            RaisedButton(
                child: Text("Cámara"),
                onPressed: () async {
                  File file =
                  await ImagePicker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    model.hail = file;
                    callback(index, true);
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Center(
                child: model.hail == null
                    ? Text(
                        "Imagen no seleccionada.",
                        style: TextStyle(color: Colors.white),
                      )
                    : Image.file(model.hail)),
            SizedBox(
              height: 20,
            ),
            model.hail == null
                ? RaisedButton(
                    child: Text("Poner alarma"),
                    onPressed: () async {
                      // TODO configurar alarma
                    })
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
