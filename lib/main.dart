import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/home/button_cosechar.dart';
import 'package:cosecheros/home/home_map.dart';
import 'package:cosecheros/login/intro.dart';
import 'package:cosecheros/login/setup_user.dart';
import 'package:cosecheros/utils/CenterTrueFloatFabLocation.dart';
import 'package:cosecheros/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'es';
  timeago.setDefaultLocale('es');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Constants.buildVersion = int.tryParse(packageInfo.buildNumber);
  // await initializeDateFormatting('es', null);
  runApp(MyApp());
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final Color background = Color(0xFFEDF4F5);
final Color black = Color(0xFF103940);
final Color primary = Color(0xFF5C92FF);
final Color red = Color(0xFFFC6063);
final Color secondary = Color(0xFF32559B);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosecheros',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
            primary: primary,
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
          backgroundColor: primary,
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
          backgroundColor: background,
          clipBehavior: Clip.hardEdge,
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          modalBackgroundColor: background,
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
          secondary: secondary,
          background: background,
          onBackground: black,
          error: red,
        ),
      ),
      // home: FutureBuilder<FirebaseApp>(
      //   future: setupFirebase(),
      //   builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
      //     print("onSetupFirebase: $snapshot");
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Ocurrió un error! ${snapshot.error}'));
      //     }
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return onFirebaseUp();
      //     }
      //     return Container(color: background);
      //   },
      // ),
      home: Container(
        color: background,
        child: StreamBuilder(
          stream: start(),
          builder: (BuildContext context, AsyncSnapshot<UserStatus> shot) {
            print("Main: ${shot.connectionState}, ${shot.data}");
            Widget show;
            if (shot.hasError) {
              show = Text(shot.error.toString());
            }
            if (shot.connectionState == ConnectionState.active) {
              switch (shot.data) {
                case UserStatus.unlogged:
                  show = Intro();
                  break;
                case UserStatus.without_type:
                  show = BeforeStart();
                  break;
                case UserStatus.ready:
                  // El hotreload parece tener un bug
                  // Re inicializando el GlobalKey acá no tira exception
                  scaffoldKey = GlobalKey<ScaffoldState>();
                  show = Scaffold(
                    key: scaffoldKey,
                    body: HomeMap(),
                    floatingActionButton: const ButtonCosechar(),
                    floatingActionButtonLocation: CenterTrueFloatFabLocation(),
                  );
                  break;
              }
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: show ?? Container(color: background),
            );
          },
        ),
      ),
    );
  }

  Stream<UserStatus> start() async* {
    await setupFirebase();
    yield* CurrentUser.instance.updates();
  }

  Future<FirebaseApp> setupFirebase() async {
    var app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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

    // Crashlytics no está soportado en web
    if (!kIsWeb) {
      // Pasar todos los crashes no atrapados de Flutter a Crashlitycs
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Deshabilitar los reportes de crashes si estamos en desarrollo
      if (kDebugMode) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      }
    }

    // Offline persistence
    if (!kIsWeb) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: 1 << 20,
      );
    }

    return app;
  }
}
