
import 'dart:convert';

import 'package:cosecheros/cosechar/local.dart';
import 'package:cosecheros/cosechar/online.dart';
import 'package:cosecheros/map/map.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:cosecheros/widgets/grid_icon_button.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          _onNuevaCosecha(context);
        },
        label: Text(
          'Cosechar',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      extendBody: true,
      body: Stack(
        children: [
          HomeMap(),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: getLogo(context),
              ),
            ),
          )
        ],
      ),
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

  Widget getLogo(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          'Cosecheros',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Color(0xFFF5F5F5),
          ),
        ),
        // Solid text as fill.
        Text(
          'Cosecheros',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Future<void> _onNuevaCosecha(BuildContext context) async {
    var forms = RemoteConfig.instance.getString(Constants.formsSource);
    print(forms);

    Iterable list = json.decode(forms);

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
                  children: [
                    ...list.map(
                      (e) => GridIconButton(
                        title: e['label'],
                        background: e['color'],
                        onPressed: () => Navigator.pop(context, e['url']),
                      ),
                    ),
                    if (kDebugMode)
                      GridIconButton(
                        title: "Local",
                        background: Colors.black87,
                        onPressed: () => Navigator.pop(context, "local"),
                      ),
                    //   title: "Sequía",
                    //   background: Color(0xFFF9787A),
                    //   title: "Helada",
                    //   background: Color(0xFF58D5E8),
                    //   title: "Daños por granizo",
                    //   background: Colors.green[300],
                    //   title: "Lluvias",
                    //   background: Color(0xFF80A5EE),
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
