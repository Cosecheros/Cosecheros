import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Harvests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime from = DateTime.now().subtract(Duration(hours: 72));

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('cosechas')
            // .where("timestamp", isGreaterThan: from)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor),
                  ),
                ),
              );
            default:
              return ListView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 64),
                children: snapshot.data.documents
                    .map((DocumentSnapshot document) => Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              document['granizada_thumb'] != null
                                  ? CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          height: 60.0,
                                          width: 60.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.green),
                                          ),
                                        ),
                                      ),
                                      imageUrl: document['granizada_thumb'],
                                      fit: BoxFit.cover,
                                      height: 200,
                                    )
                                  : Container(),
                              ListTile(
                                title: Text(DateFormat.yMMMMEEEEd()
                                    .format(document['date'].toDate())),
                                subtitle: Text(document['lluvia']),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              );
          }
        },
      ),
    );
  }
}
