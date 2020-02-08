import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/backend/harvest.dart';
import 'package:cosecheros/new_harvest/hail_data.dart';
import 'package:cosecheros/shared/slide_controls.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  final Firestore firestore = Firestore.instance;
  final StorageReference storageReference = FirebaseStorage().ref();
  StorageUploadTask uploadTask;
  bool uploading = false;
  bool done = false;
  String taskTitle = "";

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
                  physics: NeverScrollableScrollPhysics(),
                ),
                SlideControls(
                  controller: _controller,
                  options: options,
                  typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
                  onDonePress: this.onDonePress,
                ),
                uploading
                    ? Container(
                        decoration: BoxDecoration(color: Colors.black45),
                        child: Center(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  taskTitle,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                uploadTask != null && !done
                                    ? loadingBar()
                                    : Container(),
                                done ? doneButton(context) : Container()
                              ]),
                        ))
                    : Container()
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ));
  }

  void onDonePress() async {
    setState(() {
      taskTitle = "Cargando...";
      uploading = true;
    });

    DocumentReference ref =
        await firestore.collection('cosechas').add(model.toMap());
    String id = ref.documentID;

    uploadTask = storageReference
        .child("cosechas/$id-${basename(model.hailStorm.path)}")
        .putFile(model.hailStorm);

    setState(() {
      taskTitle = "Subiendo fotos...";
    });

    StorageTaskSnapshot stormSnapshot = await uploadTask.onComplete;
    String stormPath = stormSnapshot.ref.path;

    uploadTask = storageReference
        .child("cosechas/$id-${basename(model.hail.path)}")
        .putFile(model.hail);

    // Trigger update
    setState(() {
      taskTitle = "Subiendo fotos...";
    });

    StorageTaskSnapshot hailSnapshot = await uploadTask.onComplete;
    String hailPath = hailSnapshot.ref.path;

    setState(() {
      taskTitle = "Verificando...";
    });

    String stormThumbUrl = await storageReference
        .child("cosechas/thumbs/${basenameWithoutExtension(stormPath)}_500x500.${extension(stormPath)}")
      .getDownloadURL();

    String hailThumbUrl = await storageReference
        .child("cosechas/thumbs/${basenameWithoutExtension(hailPath)}_500x500.${extension(hailPath)}")
        .getDownloadURL();

    await ref.updateData({
      'granizada': stormPath,
      'granizada_thumb':stormThumbUrl,

      'granizo': hailPath,
      'granizo_thumb': hailThumbUrl,
    });

    setState(() {
      taskTitle = "Granizo cosechado";
      done = true;
    });
  }

  Widget loadingBar() => StreamBuilder<StorageTaskEvent>(
      stream: uploadTask.events,
      builder: (context, asyncSnapshot) {
        double percent;
        if (asyncSnapshot.hasData) {
          final StorageTaskSnapshot snapshot = asyncSnapshot.data.snapshot;
          percent = snapshot.bytesTransferred / snapshot.totalByteCount;
        }
        print(percent);
        return SizedBox(
          height: 60.0,
          width: 60.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            value: percent,
          ),
        );
      });

  Widget doneButton(context) => Container(
        margin: EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.done,
            color: Colors.white,
            size: 40.0,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.green,
          padding: const EdgeInsets.all(15.0),
        ),
      );

  void setOptions(slide, value) {
    setState(() {
      options[slides.indexOf(slide)] = value;
    });
  }
}
