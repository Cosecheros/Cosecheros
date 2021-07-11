import 'package:flutter/foundation.dart';

class Constants {
  static const String collection = kReleaseMode ? "prod_v2" : "dev";
  static const String formsSource = kReleaseMode ? "prod_forms_v3" : "dev_forms";
  static const Duration formsFetchInterval =
      kReleaseMode ? Duration(hours: 1) : Duration(seconds: 5);
  static const Duration formsFetchTimeout = Duration(seconds: 10);
  static const String localForm = "deriva.1";
}
