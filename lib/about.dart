import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                child: Image(image: AssetImage('assets/Granizo2.jpg')),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "Es un programa que posibilita la geolocalización temporal de las granizadas y la recolección y caracterización cristalográfica de granizos, a lo largo del territorio provincial, con el fin de correlacionar estos datos con la información obtenida por instrumental remoto científico y las modelizaciones disponibles.",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AboutListWidget(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.isExpanded = false,
    this.header,
    this.expanded,
  });

  bool isExpanded;
  String header;
  Widget expanded;
}

class AboutListWidget extends StatefulWidget {
  AboutListWidget({Key key}) : super(key: key);

  @override
  _AboutListWidgetState createState() => _AboutListWidgetState();
}

class _AboutListWidgetState extends State<AboutListWidget> {
  List<Item> _data = [
    Item(
        header: "Qué cosechar",
        expanded: Column(
          children: <Widget>[
            Text(
                "Las fotos de granizadas en especial y, de ser posible, granizos para su posterior investigación en el laboratorio."),
            Padding(
              padding: EdgeInsets.all(4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image(image: AssetImage('assets/Granizada.jpg')),
                  ),
                  Expanded(
                    child: Image(image: AssetImage('assets/FotoGranizo2.jpg')),
                  ),
                ],
              ),
            )
          ],
        )),
    Item(
        header: "Quién es cosechero",
        expanded: Text(
            "Todos podemos ser cosecheros. Cosechando información sobre la granizada y resguardando algunos granizos especiales estamos haciendo ciencia , somos verdaderos CIUDADANOS CIENTIFICOS.")),
    Item(
        header: "Por qué cosechar",
        expanded: Text(
            "Parte de la Provincia de Córdoba está en una de las regiones de tormentas más severas del planeta. Las tormentas extremas son centro de estudio de investigadores de Argentina y de otros países del mundo, con el objetivo de comprender estas tormentas.")),
    Item(
        header: "Aprende a cosechar",
        expanded: FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            onPressed: _launchYoutube,
            child: Text(
              "Ver en Youtube",
            ))),

    Item(
        header: "Qué hacemos con las fotos",
        expanded: Text(
            "Las analizamos: a partir de las fotos podemos deducir la cantidad de granizo que cayó por unidadd de superfficie")),
    Item(
        header: 'Qué hacemos con los granizos cosechados',
        expanded: Text(
            'Nos contactamos con el cosechero, y de ser posible lo buscamos en su domicilio. Nombramos al granizo con el nombre del cosechero')),
    Item(
        header: 'Granizos en el lab',
        expanded: Text(
            'En el laboratorio, cortamos los granizos buscando su nucleo, una tarea muy dificil.')),
    //aca deberia ir una foto de ejemplo
    Item(
        header: 'Permisos de la aplicacion',
        expanded: Text(
            'Pedimos permiso para acceder al gps porque necesitamos la ubicacion de la tormenta. El permiso a la galeria y cámara es para poder subir la foto')),
    Item(
        header: 'Sobre la app',
        expanded: Text('Desarrollada en Dart.....')), //ver que poner
    Item(
        header: 'CONTACTO',
        expanded: Text(
            'aca iria mail de cosecheros. ver como hacer para que abra gmail con destinatario cosecheros')),
  ];

  static _launchYoutube() async {
    const url = 'https://www.youtube.com/watch?v=RGY37mrk5yQ';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.header),
            );
          },
          body: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: item.expanded,
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
