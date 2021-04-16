// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'models/harvest.dart';
// import 'shared/harvest_card.dart';

// class Harvests extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     DateTime from = DateTime.now().subtract(Duration(hours: 72));

//     return Container(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: Firestore.instance
//             .collection('cosechas')
//             // .where("timestamp", isGreaterThan: from)
//             .orderBy("timestamp", descending: true)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(
//                 child: SizedBox(
//                   height: 60.0,
//                   width: 60.0,
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).accentColor),
//                   ),
//                 ),
//               );
//             default:
//               return ListView(
//                 padding: EdgeInsets.fromLTRB(8, 8, 8, 100),
//                 children: snapshot.data.documents
//                     .map((DocumentSnapshot doc) =>
//                         HarvestCard(HarvestModel.fromSnapshot(doc)))
//                     .toList(),
//               );
//           }
//         },
//       ),
//     );
//   }
// }
