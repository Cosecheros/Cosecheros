import 'package:cosecheros/forms/events.dart';
import 'package:cosecheros/shared/on_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

class TabWidget extends StatefulWidget {
  final String header;
  final List<Widget> children;
  final FormElementEventDispatcherFunction dispatcher;

  TabWidget({this.header, this.children, this.dispatcher});

  static TabWidgetState of(BuildContext context) {
    assert(context != null);
    final TabWidgetState result =
        context.findAncestorStateOfType<TabWidgetState>();
    if (result != null) return result;
    throw Exception("No se encontró un TabWidget padre.");
  }

  @override
  TabWidgetState createState() => TabWidgetState();
}

class TabWidgetState extends State<TabWidget> {
  // TabController _controller;
  final controller = PageController(initialPage: 0);
  int currentPage = 0;

  Future<bool> onBack() async {
    if (!isFirst()) {
      movePage(-1);
      return false;
    }
    return true;
  }

  // @override
  // void didUpdateWidget(covariant TabWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print("TabWidget: updating: lenght: ${widget.children.length}");
  //   var tab = TabController(vsync: this, length: widget.children.length);
  //   tab.index = _controller.index;
  //   _controller = tab;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TabController(vsync: this, length: widget.children.length);
  // }

  @override
  Widget build(BuildContext context) {
    return NestedWillPopScope(
      onWillPop: onBack,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              children: widget.children,
              controller: controller,
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
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
              child: Text("Parte $currentPage"),
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
    );
  }

  bool isFirst() => currentPage == 0;
  bool isLast() => currentPage + 1 == widget.children.length;

  void movePage(int step) {
    controller.animateToPage(
      currentPage + step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
