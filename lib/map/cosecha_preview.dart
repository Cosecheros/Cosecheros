import 'package:cosecheros/map/cosecha_detail.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class CosechaPreview extends StatelessWidget {
  final Cosecha model;
  const CosechaPreview(this.model);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
          ),
          builder: (BuildContext builder) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return CosechaDetail(this.model, scrollController);
              },
            );
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
