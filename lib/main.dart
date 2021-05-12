import 'dart:convert';

import 'package:cosecheros/map/map.dart';
import 'package:cosecheros/shared/grid_icon_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'alerts/alerts_bottom.dart';
import 'cosechar/local.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'cosechar/online.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es';
  timeago.setDefaultLocale('es');
  await initializeDateFormatting('es', null);
  runApp(MyApp());
}

enum Cosecha { test, granizo, helada }

final Color primary = Color(0xFF5C92FF);
final Color secondary = Color(0xFF32559B);
final Color background = Color(0xFFEDF4F5);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cosecheros',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: primary,
              primaryVariant: secondary,
              onBackground: Color(0xFF103940),
            ),
            primaryColor: primary,
            accentColor: secondary,
            backgroundColor: background,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            scaffoldBackgroundColor: background,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: secondary,
                elevation: 4,
                shadowColor: secondary.withOpacity(.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.black),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: secondary,
            ),
            cardTheme: CardTheme(
              elevation: 1,
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.transparent,
              modalBackgroundColor: Colors.transparent,
            ),
            textTheme: GoogleFonts.interTextTheme(),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            )),
        home: FutureBuilder<FirebaseApp>(
          future: setupFirebase(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocurrió un error!'));
            }
            if (snapshot.hasData) {
              return MainPage();
            }
            return Container(
              color: background,
            );
          },
        ));
  }
}

Future<FirebaseApp> setupFirebase() async {
  var app = await Firebase.initializeApp();
  final RemoteConfig remoteConfig = RemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    'welcome': 'default welcome',
    'hello': 'default hello',
  });
  remoteConfig.fetchAndActivate();
  RemoteConfigValue(null, ValueSource.valueStatic);
  return app;
}

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
    var forms = RemoteConfig.instance.getString('dev_forms');
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
                    GridIconButton(
                      title: "Local",
                      background: Colors.black87,
                      onPressed: () => Navigator.pop(context, "local"),
                    ),
                    // GridIconButton(
                    //   title: "Sequía",
                    //   background: Color(0xFFF9787A),
                    //   onPressed: () => Navigator.pop(context, Cosecha.granizo),
                    // ),
                    // GridIconButton(
                    //   title: "Helada",
                    //   background: Color(0xFF58D5E8),
                    //   onPressed: () => Navigator.pop(context, Cosecha.granizo),
                    // ),
                    // GridIconButton(
                    //   title: "Daños por granizo",
                    //   background: Colors.green[300],
                    //   onPressed: () => Navigator.pop(context, Cosecha.helada),
                    // ),
                    // GridIconButton(
                    //   title: "Lluvias",
                    //   background: Color(0xFF80A5EE),
                    //   onPressed: () => Navigator.pop(context, Cosecha.helada),
                    // ),
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
