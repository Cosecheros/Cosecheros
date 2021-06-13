import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'model.dart';

class CosechaSummary extends StatelessWidget {
  final Cosecha model;

  const CosechaSummary(this.model);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

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

  // Widget showHarvest(HarvestModel model) {
  //   return Column(
  //     children: <Widget>[
  //       Expanded(
  //         child: ListView(
  //           scrollDirection: Axis.horizontal,
  //           children: <Widget>[
  //             mayShowImage(model.stormThumb),
  //             SizedBox(width: 8),
  //             mayShowImage(model.hailThumb)
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 8),
  // Container(
  //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //   child: Text(
  //     DateFormat.yMMMMd().format(model.dateTime),
  //     style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
  //   ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.symmetric(horizontal: 10),
  //         child: Text(
  //           "Lluvia: ${rainToString(model.rain)}",
  //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.symmetric(horizontal: 10),
  //         child: Text(
  //           "Usuario: Anonimo",
  //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 14,
  //       )
  //     ],
  //   );
  // }

  // Widget mayShowImage(String url) {
  //   return url != null
  //       ? CachedNetworkImage(
  //           placeholder: (context, url) => Center(
  //             child: SizedBox(
  //               height: 30.0,
  //               width: 30.0,
  //               child: CircularProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(
  //                     Theme.of(context).accentColor),
  //               ),
  //             ),
  //           ),
  //           imageUrl: url,
  //           fit: BoxFit.cover,
  //           height: 100,
  //         )
  //       : Container();
  // }
}
