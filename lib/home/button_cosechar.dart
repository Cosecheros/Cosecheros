import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/cosechar/local.dart';
import 'package:cosecheros/cosechar/online.dart';
import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/models/form_spec.dart';
import 'package:cosecheros/widgets/grid_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonCosechar extends StatelessWidget {
  const ButtonCosechar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<QuerySnapshot<FormSpec>>(
          future: Database.instance.forms().get(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Text(snap.error.toString());
            }

            List<FormSpec> forms;
            if (snap.connectionState == ConnectionState.done) {
              forms = snap.data.docs
                  .map((e) => e.data())
                  .where((e) => e.isValid())
                  .toList();
            }
            print("Home: ButtonCosechar: forms=${forms?.map((e) => e.label)}");

            return FloatingActionButton.extended(
              heroTag: null,
              onPressed:
                  forms == null ? null : () => _onCosechar(context, forms),
              label: Text(
                'Cosechar',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }),
    );
  }

  void _onCosechar(BuildContext context, List<FormSpec> forms) async {
    var selected = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Wrap(
                runSpacing: 12,
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    alignment: Alignment.center,
                    child: Text(
                      '¿Qué vas a cosechar?',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ...forms.map(
                    (e) => SizedBox.square(
                      dimension: 128,
                      child: GridIconButton(
                        title: e.label,
                        background: e.color,
                        icon: e.icon == null
                            ? null
                            : Image.network(
                                e.icon,
                                fit: BoxFit.contain,
                                // En caso de no existir, fallback a este icono
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.report_rounded, size: 48),
                              ),
                        onPressed: () => Navigator.pop(
                          context,
                          e.getUrl().href,
                        ),
                      ),
                    ),
                  ),
                  if (kDebugMode)
                    SizedBox.square(
                      dimension: 128,
                      child: GridIconButton(
                        title: "Local",
                        background: Colors.black87,
                        onPressed: () => Navigator.pop(context, "local"),
                      ),
                    ),
                ],
              ),
            ),
          );
        });

    if (selected == "local") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocalForm()),
      );
    } else if (selected != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnlineForm(selected)),
      );
    }
  }
}
