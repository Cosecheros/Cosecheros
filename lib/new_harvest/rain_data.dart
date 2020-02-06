import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RainData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Cuando llovió",
      backgroundColor: Color(0xfff5a623),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
            children: Rain.values
                .map((rain) => RadioListTile<Rain>(
                      title: Text(
                        rainToString(rain),
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.white,
                      value: rain,
                      groupValue: model.rain,
                      onChanged: (Rain value) {
                        model.rain = value;
                      },
                    ))
                .toList()),
      ),
    );
  }
}
