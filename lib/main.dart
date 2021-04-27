import 'package:cosecheros/cosechar/test_form.dart';
import 'package:cosecheros/map.dart';
import 'package:cosecheros/new_harvest/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'alerts/alerts_bottom.dart';
import 'cosechar/granizo.dart';

void main() {
  Intl.defaultLocale = 'es';
  timeago.setDefaultLocale('es');
  initializeDateFormatting('es', null).then((_) => runApp(MyApp()));
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
            onBackground: Color(0xFF103940)),
        primaryColor: primary,
        accentColor: secondary,
        backgroundColor: background,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
          padding: const EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
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
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          modalBackgroundColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF103940),
          ),
        ),
      ),
      home: MainPage(),
    );
  }
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
          FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('error de firebase');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return MapRecent();
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
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
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //   showMaterialModalBottomSheet(
        //     expand: true,
        //     context: context,
        //     builder: (context) => Container(
        //       color: Colors.green,
        //     ),
        //   );
        // },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: AlertsBottom(),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLogo(BuildContext context) => Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            'Cosecheros',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = Color(0xFFF7F7F7),
            ),
          ),
          // Solid text as fill.
          Text(
            'Cosecheros',
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      );

  Future<void> _onNuevaCosecha(BuildContext context) async {
    switch (await showDialog<Cosecha>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('¿Qué vas a cosechar?'),
            children: <Widget>[
              // Wrap(
              //   alignment: WrapAlignment.center,
              //   spacing: 8.0,
              //   runSpacing: 8.0,
              //   children: [
              //     Container(
              //       width: 100,
              //       height: 100,
              //       color: Colors.cyan,
              //     ),
              //     Container(
              //       width: 100,
              //       height: 100,
              //       color: Colors.cyan,
              //     ),
              //   ],
              // ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Cosecha.test);
                },
                child: const Text('Test Form'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Cosecha.granizo);
                },
                child: const Text('Granizada'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Cosecha.helada);
                },
                child: const Text('Helada'),
              ),
            ],
          );
        })) {
      case Cosecha.test:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomExpressionForm()),
        );
        break;
      case Cosecha.granizo:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GranizoForm()),
        );
        break;
      case Cosecha.helada:
        // ...
        break;
      default:
        // dialog dismissed
        break;
    }
  }
}
