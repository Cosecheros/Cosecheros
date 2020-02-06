import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/new_harvest/hail_data.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hail_storm_data.dart';
import 'hail_storm_intro.dart';
import 'map_data.dart';
import 'rain_data.dart';
import 'summary.dart';

class NewHarvest extends StatefulWidget {
  @override
  NewHarvestState createState() => NewHarvestState();
}

class NewHarvestState extends State<NewHarvest>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Widget> slides = [];
  List<slideOptions> options = [];

  HarvestModel model = HarvestModel();

  @override
  void initState() {
    super.initState();

    // 0
    options.add(slideOptions.NEXT_ENABLED);
    slides.add(HailStormIntro());

    // 1
    options.add(slideOptions.NEXT_DISABLED);
    slides.add(HailStormData(this.setOptions));

    options.add(slideOptions.CAN_OMIT);
    slides.add(HailData(this.setOptions));

    options.add(slideOptions.NEXT_DISABLED);
    slides.add(MapData(this.setOptions));

    options.add(slideOptions.NEXT_ENABLED);
    slides.add(RainData());

//    options.add(slideOptions.NEXT_ENABLED);
//    slides.add(SizeData());

    options.add(slideOptions.NEXT_ENABLED);
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
//                  physics: NeverScrollableScrollPhysics(),
                ),
                SlideControls(
                  controller: _controller,
                  options: options,
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

  void setOptions(slide, value) {
    setState(() {
      options[slides.indexOf(slide)] = value;
    });
  }
}
