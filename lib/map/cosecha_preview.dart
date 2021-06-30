import 'package:cosecheros/map/cosecha_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'model.dart';

class CosechaPreview extends StatelessWidget {
  final Cosecha model;
  const CosechaPreview(this.model);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return CosechaDetail(this.model);
          },
        );
      },
      child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // TODO: Un icono
              Icon(Icons.keyboard_arrow_up_rounded),
              SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.alias + " " + timeago.format(model.timestamp),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Cosechado por " + model.username,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.black87),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
