import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/shared/slide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slide(
      title: "Que tamaño tiene",
      backgroundColor: Color(0xfff5a623),
      centerWidget: Consumer<HarvestModel>(
        builder: (context, model, child) => Column(
            children: HailSize.values
                .map((size) => RadioListTile<HailSize>(
              title: Text(size.toString()),
              value: size,
              groupValue: model.size,
              onChanged: (HailSize value) {
                model.size = value;
              },
            ))
                .toList()),
      ),
    );
  }
}
