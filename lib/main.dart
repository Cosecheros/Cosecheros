import 'package:cosecheros/home.dart';
import 'package:cosecheros/login/current_user.dart';
import 'package:cosecheros/login/intro.dart';
import 'package:cosecheros/login/setup_user.dart';
import 'package:cosecheros/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es';
  timeago.setDefaultLocale('es');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Constants.buildVersion = int.tryParse(packageInfo.buildNumber);
  // await initializeDateFormatting('es', null);
  runApp(MyApp());
}

final Color background = Color(0xFFEDF4F5);
final Color black = Color(0xFF103940);
final Color primary = Color(0xFF5C92FF);
final Color red = Color(0xFFFC6063);
final Color secondary = Color(0xFF32559B);

enum Cosecha { test, granizo, helada }

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
        splashColor: secondary.withOpacity(0.05),
        highlightColor: secondary.withOpacity(0.05),
        primaryColor: primary,
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
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: primary,
          primaryVariant: secondary,
          secondary: red,
          background: background,
          onBackground: black,
        ).copyWith(secondary: secondary),
      ),
      home: FutureBuilder<FirebaseApp>(
        future: setupFirebase(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          print("onSetupFirebase: $snapshot");
          if (snapshot.hasError) {
            return Center(child: Text('Ocurrió un error!'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return onFirebaseUp();
          }
          return Container(color: background);
        },
      ),
    );
  }

  Widget onFirebaseUp() {
    return StreamBuilder(
      stream: CurrentUser.instance.updates(),
      builder: (BuildContext context, AsyncSnapshot<UserStatus> shot) {
        print("CurrentUser update: $shot");
        if (shot.connectionState == ConnectionState.active) {
          switch (shot.data) {
            case UserStatus.unlogged:
              return Intro();
              break;
            case UserStatus.without_type:
              return BeforeStart();
              break;
            case UserStatus.ready:
              return MainPage();
              break;
            default:
              return MainPage();
              break;
          }
        }
        print('Main >>> Cargando~');
        return Container(color: background);
      },
    );
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

    // Pasar todos los crashes no atrapados de Flutter a Crashlitycs
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Deshabilitar los reportes de crashes si estamos en desarrollo
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    return app;
  }
}
