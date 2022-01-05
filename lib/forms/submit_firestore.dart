import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/forms/form_manager.dart';
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/forms/serializers.dart';
import 'package:cosecheros/login/current_user.dart';
import 'package:cosecheros/models/response_item.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum Mode { Uploading, Indeterminate, Done, Fail }

class SubmitFirestore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Reference rootRef = FirebaseStorage.instance.ref();

  Stream<SubmitProgress> submit(CustomFormManager manager) async* {
    final String id = DateTime.now().toIso8601String();
    final elements = manager.getVisibleFormElementIterator().toList().reversed;

    print("submit: Iniciando");
    yield SubmitProgress("Cargando", Mode.Uploading);

    Iterable<Picture> pictures = elements.whereType();
    print("submit: pics: " + pictures.toString());

    // Subir a Storage las fotos
    for (var element in pictures) {
      if (element.path == null) {
        continue;
      }

      yield SubmitProgress("Subiendo foto", Mode.Indeterminate);

      UploadTask uploadTask = rootRef
          .child("dev/$id-${element.id}.jpg")
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
            element.url = url;
            break;
          } else {
            yield SubmitProgress("Error", Mode.Fail);
          }
        }
      } catch (e) {
        print("submit: ERROR: " + e.toString());
      }
    }

    yield SubmitProgress("Verificando", Mode.Indeterminate);

    var responses = elements
        .map((e) => _toResponse(e))
        .where((element) => element != null)
        .toList();

    var out = {
      'form_id': manager.form.id,
      // Sabemos que es un model.Form
      // así que estamos casi seguros de que tiene ese property
      'form_alias': manager.form.getProperty("name").value,
      'timestamp': FieldValue.serverTimestamp(),
      'username': CurrentUser.instance.data.isAnonymous
          ? null
          : CurrentUser.instance.data.name,
      'payload': responses.map((e) => e.toJson()).toList(),
    };

    DocumentReference ref = firestore.collection(Constants.collection).doc(id);

    print(out);
    await ref.set(out);

    yield SubmitProgress("Cosechado", Mode.Done);
  }

  ResponseItem _toResponse(FormElement element) {
    print("_toResponse: " + element.toString());
    Serializer builder = serializers[element.runtimeType];

    if (builder is NopeSerializer) {
      return null;
    }

    if (builder != null) {
      return builder.serialize(element);
    }

    print("ERROR: No hay serializer implementado: $element");
    return null;
  }
}

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
