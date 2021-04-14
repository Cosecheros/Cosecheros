import 'package:cosecheros/forms/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

class TabWidget extends StatefulWidget {
  final String header;
  final List<Widget> children;
  final FormElementEventDispatcherFunction dispatcher;

  TabWidget({this.header, this.children, this.dispatcher});

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with SingleTickerProviderStateMixin {
  TabController _controller;

  Future<bool> onBack() async {
    if (!isFirst()) {
      movePage(-1);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.children.length);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: DefaultTabController(
        length: widget.children.length,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                children: widget.children,
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            if (!isFirst())
              Positioned(
                top: 4,
                left: 16,
                child: SafeArea(
                  child: TextButton.icon(
                    onPressed: () {
                      movePage(-1);
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text("Volver"),
                  ),
                ),
              ),
            Positioned(
              top: 16,
              child: SafeArea(
                child: Text(
                  widget.header,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 16,
              child: SafeArea(
                child: Text("Parte ${_controller.index}"),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  isLast() ? widget.dispatcher(DoneEvent()) : movePage(1);
                },
                child: Text(isLast() ? "COSECHAR" : "SIGUIENTE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isFirst() => _controller.index == 0;
  bool isLast() => _controller.index + 1 == _controller.length;

  void movePage(int step) {
    if (!_controller.indexIsChanging) {
      setState(() {
        _controller.animateTo(_controller.index + step);
      });
    }
  }
}
