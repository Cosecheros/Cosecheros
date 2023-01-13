import 'dart:io';

import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ButtonCsv extends StatelessWidget {
  const ButtonCsv({Key key, this.lastMarkers}) : super(key: key);

  final List<dynamic> lastMarkers;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.download_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        saveCsv(context);
      },
    );
  }

  void saveCsv(context) async {
    if (await Permission.storage.request().isGranted) {
      final data = lastMarkers.map((e) => _getData(e));
      List<String> header = data
          .expand((e) => e.keys)
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      List<List<dynamic>> rows = [];
      rows.add(header);
      for (Map<String, dynamic> row in data) {
        rows.add(header.map((e) => row[e] ?? '').toList());
      }

      var savedDir = Directory('/storage/emulated/0/Download');
      if (!(await savedDir.exists())) {
        savedDir = await getExternalStorageDirectory();
      }
      String csv = const ListToCsvConverter().convert(rows);
      print(csv);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String now = formatter.format(DateTime.now());
      File f = File("${savedDir.path}/cosechas-$now.txt");
      f.writeAsString(csv);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('¡Guardado en Descargas!'),
        action: SnackBarAction(
          label: 'Abrir',
          onPressed: () {
            OpenFile.open(f.path);
          },
        ),
      ));
    }
  }

  Map<String, dynamic> _getData(dynamic model) {
    if (model is Cosecha) {
      return model.toJson();
    }
    if (model is Tweet) {
      return model.toJson();
    }
    return null;
  }
}
