import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class HailStormIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Medidas de seguridad",
      description: "Mantengase en un lugar seguro mientras cae el granizo.",
      backgroundColor: Color(0xFF01A0C7),
      centerWidget: Container(
        padding: EdgeInsets.all(40),
        child: Image.asset("assets/Resguardo.jpg"),
      ),
    );
  }
}