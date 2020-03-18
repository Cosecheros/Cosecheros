import 'package:cosecheros/about.dart';
import 'package:cosecheros/harvests.dart';
import 'package:cosecheros/map.dart';
import 'package:cosecheros/new_harvest/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'shared/fab_bottom_bar.dart';

void main() {
  Intl.defaultLocale = 'es';
  initializeDateFormatting('es', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosecheros',
      theme: ThemeData(
          primaryColor: Color(0xFF01A0C7),
          accentColor: Color(0xFF41D1D5),
          // accentColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.white,
            padding: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
          ),
          cardTheme: CardTheme(
            elevation: 1,
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            modalBackgroundColor: Colors.transparent,
          )),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        title: Image.asset(
          'assets/Granizo4.png',
          height: 56,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewHarvest()),
          );
        },
        tooltip: 'Nueva cosecha',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      extendBody: true,
      body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapRecent(),
            Harvests(),
            About(),
            Container(),
          ]),
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: CircularNotchedRectangle(),
        selectedColor: Theme.of(context).primaryColor,
        color: Colors.grey,
        centerItemText: "Cosechar",
        onTabSelected: _tabController.animateTo,
        items: [
          FABBottomAppBarItem(iconData: Icons.place, text: 'Mapa'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Perfil'),
          FABBottomAppBarItem(iconData: Icons.book, text: 'Proyecto'),
          FABBottomAppBarItem(iconData: Icons.notifications, text: 'Noticias'),
        ],
      ),
    );
  }
}