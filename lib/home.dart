import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/cosechar/local.dart';
import 'package:cosecheros/cosechar/online.dart';
import 'package:cosecheros/map/map.dart';
import 'package:cosecheros/models/form_spec.dart';
import 'package:cosecheros/widgets/grid_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _asyncCosecharButton(context),
      extendBody: true,
      body: HomeMap(),
      // bottomNavigationBar: GestureDetector(
      //   onTap: () {
      //     showMaterialModalBottomSheet(
      //       expand: true,
      //       context: context,
      //       builder: (context) => Container(
      //         color: Colors.green,
      //       ),
      //     );
      //   },
      //   child: Container(
      //     width: double.infinity,
      //     padding: EdgeInsets.all(16),
      //     child: AlertsBottom(),
      //     decoration: BoxDecoration(
      //       color: Theme.of(context).backgroundColor,
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(10),
      //         topRight: Radius.circular(10),
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.4),
      //           blurRadius: 16,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Query getFormSpecs() {
    var query = FirebaseFirestore.instance.collection("forms");
    return query;
  }

  Widget _asyncCosecharButton(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: getFormSpecs().get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<FormSpec> forms;
          print("getFormSpecs: $snapshot");

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState != ConnectionState.waiting) {
            forms = snapshot.data.docs
                .map((doc) => FormSpec.fromMap(doc.data()))
                .where((e) => e.getUrl() != null)
                .toList();
          }
          print("Home: CosecharButton: forms len: ${forms?.length}");

          return FloatingActionButton.extended(
            heroTag: null,
            onPressed: forms == null
                ? null
                : () {
                    _onCosechar(context, forms);
                  },
            label: Text(
              'Cosechar',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          );
        });
  }

  _onCosechar(BuildContext context, List<FormSpec> forms) async {
    var selected = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Text(
                    '¿Qué vas a cosechar?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  scrollDirection: Axis.vertical,
                  children: [
                    ...forms.map(
                      (e) => GridIconButton(
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
                    if (kDebugMode)
                      GridIconButton(
                        title: "Local",
                        background: Colors.black87,
                        onPressed: () => Navigator.pop(context, "local"),
                      ),
                  ],
                ),
              ],
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
