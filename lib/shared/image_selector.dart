import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  final Function(File file) onPicked;
  final _picker = ImagePicker();

  ImageSelector({this.onPicked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () async {
            PickedFile file = await _picker.getImage(source: ImageSource.camera);
            if (file != null) {
              onPicked(File(file.path));
            }
          },
          child: Icon(
            Icons.photo_camera,
            color: Theme.of(context).accentColor,
            size: 40.0,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
        ),
        SizedBox(
          height: 4,
        ),
        TextButton(
            child: Text("Subir desde la galería",
                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
            onPressed: () async {
              PickedFile file =
                  await _picker.getImage(source: ImageSource.gallery);
              if (file != null) {
                onPicked(File(file.path));
              }
            }),
      ],
    );
  }
}
