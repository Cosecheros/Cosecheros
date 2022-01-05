import 'package:flutter/foundation.dart';

class Constants {
  static const String collection = kReleaseMode ? "prod_v2" : "dev";

  static const Duration minimumFetchInterval =
      kReleaseMode ? Duration(hours: 1) : Duration(seconds: 5);
  static const Duration fetchTimeout = Duration(seconds: 10);

  static const String localForm = "inundacion.ciudadano.1";
  static int buildVersion;
}
