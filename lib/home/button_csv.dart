import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/utils/helpers.dart'
    if (dart.library.html) 'package:cosecheros/utils/web_helpers.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

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
    print("CSV: generating");
    final data = lastMarkers.map((e) => _getData(e));
    List<String> header =
        data.expand((e) => e.keys).where((e) => e.isNotEmpty).toSet().toList();

    List<List<dynamic>> rows = [];
    rows.add(header);
    for (Map<String, dynamic> row in data) {
      rows.add(header.map((e) => row[e] ?? '').toList());
    }
    print("CSV: generating: ${rows.length} rows");
    String csv = const ListToCsvConverter().convert(rows);
    print("CSV: done: $csv");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String now = formatter.format(DateTime.now());

    // Depende de la plataforma
    final path = await download(csv, "cosechas-$now.csv");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('¡Guardado en Descargas!'),
      action: path == null
          ? null
          : SnackBarAction(
              label: 'Abrir',
              onPressed: () {
                OpenFile.open(path);
              },
            ),
    ));
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
