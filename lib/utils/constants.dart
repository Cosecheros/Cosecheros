import 'package:flutter/foundation.dart';

class Constants {
  static const Duration minimumFetchInterval =
      kReleaseMode ? Duration(hours: 1) : Duration(seconds: 5);
  static const Duration fetchTimeout = Duration(seconds: 10);

  static const String localForm = "inundacion.ciudadano.1";
  static int buildVersion;

  static final String IDECOR_HOST = "gn-idecor.mapascordoba.gob.ar";
  static final String IDECOR_PATH = "/geoserver/wms";

  static final String CONAE_HOST = "geoservicios3.conae.gov.ar";
  static final String CONAE_PATH = "/geoserver/wms";
}
