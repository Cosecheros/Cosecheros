import 'package:cosecheros/map.dart';
import 'package:cosecheros/help.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF01A0C7),
        accentColor: Color(0xFFFF00C7),
        buttonTheme: ButtonThemeData(
          minWidth: double.infinity,
          buttonColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
        ),
        scaffoldBackgroundColor: Color(0xFF01A0C7),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: new EdgeInsets.only(top: 60.0, left: 50, right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage('assets/Granizo2.jpg')),
            SizedBox(height: 40),
            Padding(
              padding: new EdgeInsets.symmetric(vertical: 28.0, horizontal: 40),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Cosechar", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapRoute()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text("¿Que es CGC?", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Help()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text("Ciencia Ciudadana", style: TextStyle(fontSize: 20)),
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text("Aprende a cosechar", style: TextStyle(fontSize: 20)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}