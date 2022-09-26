import 'dart:math' as math;

import 'package:flutter/material.dart';

class CenterTrueFloatFabLocation extends StandardFabLocation
    with FabCenterOffsetX {
  const CenterTrueFloatFabLocation();

  /// From FabFloatOffsetY mixin
  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomContentHeight = scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    final double safeMargin = math.max(
      kFloatingActionButtonMargin,
      scaffoldGeometry.minViewPadding.bottom -
          bottomContentHeight +
          kFloatingActionButtonMargin,
    );

    double fabY = contentBottom - fabHeight - safeMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);

    /// Agregar margen cuando el bottomSheet está abierto
    if (bottomSheetHeight > 0.0)
      fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight - kFloatingActionButtonMargin);

    // Deja de moverlo hasta la mitad de la pantalla
    fabY = math.max(fabY, scaffoldGeometry.scaffoldSize.height / 2);

    return fabY + adjustment;
  }

  @override
  String toString() => 'FloatingActionButtonLocation.centerFloat';
}
