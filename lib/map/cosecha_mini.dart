import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cosecheros/shared/extensions.dart';

import 'model.dart';

class CosechaMini extends StatelessWidget {
  final Cosecha model;

  const CosechaMini(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        child: Text(
          timeago.format(model.timestamp).capitalize(),
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
        ));
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
