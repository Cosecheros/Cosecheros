import 'package:cosecheros/home.dart';
import 'package:cosecheros/intro.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es';
  timeago.setDefaultLocale('es');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Constants.buildVersion = int.tryParse(packageInfo.buildNumber);
  // await initializeDateFormatting('es', null);
  runApp(MyApp());
}

enum Cosecha { test, granizo, helada }

final Color primary = Color(0xFF5C92FF);
final Color secondary = Color(0xFF32559B);
final Color background = Color(0xFFEDF4F5);
final Color black = Color(0xFF103940);
final Color red = Color(0xFFFC6063);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cosecheros',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('es')],
        themeMode: ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: primary,
            primaryVariant: secondary,
            secondary: red,
            background: background,
            onBackground: black,
          ),
          splashColor: secondary.withOpacity(0.05),
          highlightColor: secondary.withOpacity(0.05),
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
            style: TextButton.styleFrom(
              primary: secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: secondary,
          ),
          cardTheme: CardTheme(
            elevation: 24,
            color: background,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            modalBackgroundColor: Colors.transparent,
          ),
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: black,
            displayColor: black,
          ),
          iconTheme: IconThemeData(
            color: primary,
            opacity: 1,
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
        ),
        home: FutureBuilder<FirebaseApp>(
          future: setupFirebase(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocurrió un error!'));
            }
            if (snapshot.hasData) {
              return onFirebaseUp();
            }
            return Container(color: background);
          },
        ));
  }

  Future<FirebaseApp> setupFirebase() async {
    var app = await Firebase.initializeApp();

    // En un momento se usó remote config
    // Para guardar los formularios
    // Se dejó de usar, pero aún así voy a dejar esto configurado
    // Por si hay ganas de usarlo para otra cosa más adelante
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Constants.fetchTimeout,
      minimumFetchInterval: Constants.minimumFetchInterval,
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      'param': '[]',
    });
    remoteConfig.fetchAndActivate();
    RemoteConfigValue(null, ValueSource.valueStatic);
    return app;
  }

  Widget onFirebaseUp() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> shot) {
        print(shot);
        if (shot.connectionState == ConnectionState.active) {
          if (shot.data == null) {
            print('Main >>> Usuario NO registrado!');
            return Intro();
          } else {
            print('Main >>> Usuario registado');
            return MainPage();
          }
        }
        print('Main >>> Cargando~');
        return Container(color: background);
      },
    );
  }
}
