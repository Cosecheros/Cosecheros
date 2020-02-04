import 'dart:async';

import 'package:cosecheros/backend/harvest.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';

class NewHarvest extends StatefulWidget {
  @override
  NewHarvestState createState() => NewHarvestState();
}

class NewHarvestState extends State<NewHarvest>
    with SingleTickerProviderStateMixin {
  void onDonePress() {
    // TODO agregar a Firestore el harvestModel
  }

  Widget stepHailStorm() {
    return Consumer<HarvestModel>(
      builder: (context, model, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
              child: Text("Galería"),
              onPressed: () async {
                model.hailStorm =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
              }),
          RaisedButton(
              child: Text("Cámara"),
              onPressed: () async {
                model.hailStorm =
                    await ImagePicker.pickImage(source: ImageSource.camera);
              }),
          SizedBox(
            height: 20,
          ),
          Center(
              child: model.hailStorm == null
                  ? Text(
                "Imagen no seleccionada.",
                style: TextStyle(color: Colors.white),
              )
                  : Image.file(model.hailStorm)),
        ],
      ),
    );
  }

  Widget stepHail() {
    return Consumer<HarvestModel>(
      builder: (context, model, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
              child: Text("Galería"),
              onPressed: () async {
                model.hail =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
              }),
          RaisedButton(
              child: Text("Cámara"),
              onPressed: () async {
                model.hail =
                    await ImagePicker.pickImage(source: ImageSource.camera);
              }),
          SizedBox(
            height: 20,
          ),
          Center(
              child: model.hail == null
                  ? Text(
                      "Imagen no seleccionada.",
                      style: TextStyle(color: Colors.white),
                    )
                  : Image.file(model.hail)),
          SizedBox(
            height: 20,
          ),
          model.hail == null
              ? RaisedButton(
                  child: Text("Poner alarma"),
                  onPressed: () async {
                    // TODO configurar alarma
                  })
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }

  Widget rain() {
    return Consumer<HarvestModel>(
      builder: (context, model, child) => Column(
        children: Rain.values.map( (rain) => RadioListTile<Rain>(
          title: Text(rainToString(rain)),
          value: rain,
          groupValue: model.rain,
          onChanged: (Rain value) {
            model.rain = value;
          },
        )).toList()
      ),
    );
  }

  Widget size() {
    return Consumer<HarvestModel>(
      builder: (context, model, child) => Column(
          children: HailSize.values.map( (size) => RadioListTile<HailSize>(
            title: Text(size.toString()),
            value: size,
            groupValue: model.size,
            onChanged: (HailSize value) {
              model.size = value;
            },
          )).toList()
      ),
    );
  }

  Widget summary() {
    return Consumer<HarvestModel>(
      builder: (context, model, child) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Granizada"),
            model.hailStorm != null
            ? Image.file(model.hailStorm)
            : Text("Arreglar esto xD"),

            Text("Granizo"),
            model.hail != null
            ? Image.file(model.hail)
            : Text("alarma configurada"),
            Text("Fecha/Hora: ${model.dateTime}"),
            Text("GeoPoint: ${model.geoPoint.latitude}/${model.geoPoint.longitude}"),
            Text("Lluvia: ${model.rain}"),
            Text("Tamaño: ${model.size}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HarvestModel(),
        child: IntroSlider(
          isScrollable: false,
          isShowSkipBtn: false,
          isShowPrevBtn: true,
          slides: [
            Slide(
              title: "Medidas de seguridad",
              backgroundColor: Color(0xfff5a623),
            ),
            Slide(
              title: "Foto de la granizada",
              centerWidget: stepHailStorm(),
              backgroundColor: Color(0xff203152),
            ),
            Slide(
              title: "Un granizo",
              description: "Preparativos",
              backgroundColor: Color(0xff9932CC),
            ),
            Slide(
              title: "Foto de un granizo",
              centerWidget: stepHail(),
              backgroundColor: Color(0xfff5a623),
            ),
            Slide(
              title: "Mapa",
              centerWidget: Container(
                height: 300,
                child: MapSample(),
              ),
              backgroundColor: Color(0xfff5a623),
            ),
            Slide(
              title: "Cuando llovió",
              centerWidget: rain(),
            ),
            Slide(
              title: "Que tamaño tiene",
              centerWidget: size(),
            ),
            Slide(
              title: "Resumen",
              centerWidget: summary(),
              backgroundColor: Color(0xfff5a623),
            )
          ],
          onDonePress: this.onDonePress,
        ));
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = Set();


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,

      compassEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,

      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: (latLong) {
        var geoPoint = GeoPoint(latLong.latitude, latLong.longitude);
        Provider.of<HarvestModel>(context, listen: false).geoPoint = geoPoint;
        setState(() {
          _markers.clear();
          _markers.add(Marker(
              markerId: MarkerId('selected'),
              position: latLong));
        });
      },
    );
  }
}