import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:cosecheros/forms/map/map.dart' as mapModel;
import 'package:cosecheros/shared/extensions.dart';

enum Mode { Uploading, Indeterminate, Done }

class SubmitProgress {
  final String task;
  final Mode mode;
  final double progress;
  SubmitProgress(this.task, this.mode, {this.progress});

  @override
  String toString() {
    return "($task, $mode, $progress)";
  }
}

class SubmitFirestore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Reference rootRef = FirebaseStorage.instance.ref();

  bool isPic(e) => e['formElement'].runtimeType == Picture;

  Map<String, dynamic> _firestoreDoc(String id, List<FormElement> payload) {
    var filtered = payload.where(
      // No subir las fotos a Firestore
      (e) => e.runtimeType != Picture,
    );

    serialize(FormElement e) {
      if (e.runtimeType == mapModel.Map) {
        return geoPoinFromGeoPos((e as mapModel.Map).point);
      }
      print("serialize: get value prop: " + e.toString());
      return e.getProperty('value').value;
    }

    return Map.fromIterable(
      filtered,
      key: (e) => e.id,
      value: (e) => serialize(e),
    )
      ..removeWhere(
        // Quitar nulls o falses o textos vacios
        (key, value) => value == null || value == false || value.toString().isEmpty,
      )
      ..addAll(
        {
          "form": id,
          "timestamp": FieldValue.serverTimestamp(),
        },
      );
  }

  Stream<SubmitProgress> submit(
      String idForm, List<FormElement> payload) async* {
    print("submit: Iniciando");
    print(payload);
    yield SubmitProgress("Cargando", Mode.Uploading);

    // Subir documento inicial
    DocumentReference ref =
        firestore.collection('dev').doc(DateTime.now().toIso8601String());

    await ref.set(_firestoreDoc(idForm, payload));

    // Para actualizar los links de las imágenes
    Map<String, dynamic> updateDoc = {};

    Iterable<Picture> pictures = payload.whereType();
    print("submit: pics: " + pictures.toString());

    // Subir a Storage las fotos
    for (var element in pictures) {
      if (element.path == null) {
        continue;
      }

      yield SubmitProgress("Subiendo foto", Mode.Indeterminate);

      UploadTask uploadTask = rootRef
          .child("dev/${ref.id}-${element.id}.jpg")
          .putFile(File(element.path));

      try {
        await for (TaskSnapshot event in uploadTask.snapshotEvents) {
          print("submit: await for: " + event.toString());
          if (event.state == TaskState.running) {
            var percent = event.bytesTransferred / event.totalBytes;
            percent = percent > 0 ? percent : null;
            yield SubmitProgress(
              "Subiendo ${element.id.human()}",
              Mode.Uploading,
              progress: percent,
            );
          } else if (event.state == TaskState.success) {
            String url = await event.ref.getDownloadURL();
            print("submit: pic url: " + url);
            updateDoc[element.id] = url;
            break;
          }
        }
      } catch (e) {
        print("submit: ERROR: " + e.toString());
      }
    }

    yield SubmitProgress("Verificando", Mode.Indeterminate);

    // Actualizar documento con la url de las fotos
    print("submit: updateDoc: " + updateDoc.toString());
    await ref.update(updateDoc);

    yield SubmitProgress("Cosechado", Mode.Done);
  }
}
