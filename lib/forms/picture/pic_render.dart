import 'dart:io';

import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:image_picker/image_picker.dart';

import 'pic.dart';

class PictureRenderer extends FormElementRenderer<Picture> {
  final _picker = ImagePicker();

  void changeValue(
    Picture element,
    FormElementEventDispatcherFunction dispatcher,
    String value,
  ) {
    dispatcher(
      ChangeValueEvent(
        value: value,
        elementId: element.id,
        propertyName: Picture.pathPropName,
      ),
    );
  }

  Widget pickerPicWidget({BuildContext context, Function(String) onPicked}) {
    return Container(
      height: 132,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          String path = await _showDialog(context);
          if (path != null) {
            onPicked(path);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.crop_original_rounded,
              size: 32,
              color:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
            SizedBox(height: 8),
            Text(
              "SUBIR FOTO",
              style: Theme.of(context).textTheme.button.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget render(
      Picture element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder<String>(
      initialData: element.path,
      stream: element.pathChanged,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabelWidget(element.label),
            if (snapshot.data == null)
              pickerPicWidget(
                context: context,
                onPicked: (value) {
                  changeValue(element, dispatcher, value);
                },
              )
            else
              showPicWidget(
                context: context,
                img: File(snapshot.data),
                onRemove: () {
                  changeValue(element, dispatcher, null);
                },
              ),
            SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget showPicWidget({BuildContext context, File img, Function onRemove}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            height: 264,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(
              img,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(8),
              child: RawMaterialButton(
                onPressed: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                constraints: BoxConstraints.tight(Size(36, 36)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _showDialog(BuildContext context) async {
    ImageSource selected = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_camera_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Tomar una con la cámara'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.collections_rounded,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    const Text('Elegir una de la galería'),
                  ],
                ),
              ),
            ],
          );
        });
    if (selected == null) {
      return null;
    }

    XFile file = await _picker.pickImage(source: selected);
    if (file == null) {
      return null;
    }
    return file.path;
  }
}
