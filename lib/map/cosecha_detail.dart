import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class CosechaDetail extends StatelessWidget {
  final Cosecha model;
  CosechaDetail(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // TODO completar con granizada
          // y después vamos viendo de ir haciendo los otros forms
          Text(
            "${model.alias} cosechada por ${model.username}",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text(
            "${model.timestamp}",
            style: Theme.of(context)
                .textTheme
                .bodyText1,
          ),
          SizedBox(height: 16),
          Text(
            "Fotos",
            style: Theme.of(context)
                .textTheme
                .subtitle1,
          ),
          mayShowImage(model.raw["granizada_pic"]),
          ...model.raw.entries
              .map((entry) => Text("${entry.key}: ${entry.value}"))
        ],
      ),
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

  Widget mayShowImage(String url) {
    return url != null
        ? CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              ),
            ),
            imageUrl: url,
            fit: BoxFit.cover,
            height: 100,
          )
        : Container();
  }
}
