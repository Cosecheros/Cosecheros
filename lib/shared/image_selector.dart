import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  final Function(File file) onPicked;

  ImageSelector({this.onPicked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () async {
            File file = await ImagePicker.pickImage(source: ImageSource.camera);
            if (file != null) {
              onPicked(file);
            }
          },
          child: Icon(
            Icons.photo_camera,
            color: Colors.white,
            size: 40.0,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Theme.of(context).accentColor,
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
                onPicked(file);
              }
            }),
      ],
    );
  }
}
