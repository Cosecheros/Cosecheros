import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/new_harvest/hail_data.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hail_intro.dart';
import 'hail_storm_data.dart';
import 'hail_storm_intro.dart';
import 'map_data.dart';
import 'rain_data.dart';
import 'size_data.dart';
import 'summary.dart';

class NewHarvest extends StatefulWidget {
  @override
  NewHarvestState createState() => NewHarvestState();
}

class NewHarvestState extends State<NewHarvest>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Widget> slides = [];
  List<bool> nextEnabled = [];

  HarvestModel model = HarvestModel();

  @override
  void initState() {
    super.initState();

    // 0
    nextEnabled.add(true);
    slides.add(HailStormIntro());

    nextEnabled.add(false);
    slides.add(HailStormData(1, this.setNext));

    nextEnabled.add(true);
    slides.add(HailIntro());

    nextEnabled.add(false);
    slides.add(HailData(3, this.setNext));

    nextEnabled.add(false);
    slides.add(MapData(4, this.setNext));

    nextEnabled.add(true);
    slides.add(RainData());

    nextEnabled.add(true);
    slides.add(SizeData());

    nextEnabled.add(true);
    slides.add(Summary());

    _controller = TabController(vsync: this, length: slides.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Scaffold(
          body: DefaultTabController(
            length: slides.length,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  children: slides,
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SlideControls(
                  controller: _controller,
                  nextEnabled: nextEnabled,
                  typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
                  onDonePress: this.onDonePress,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
        ));
  }

  void onDonePress() {
    Firestore.instance
        .collection('cosechas')
        .document()
        .setData(model.toMap())
        .then((_) {
      Navigator.pop(context);
    });
  }

  void setNext(index, value) {
    setState(() {
      nextEnabled[index] = value;
    });
  }
}
