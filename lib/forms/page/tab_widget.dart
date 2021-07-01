import 'package:cosecheros/forms/events.dart';
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
  final controller = PageController(initialPage: 0);
  int currentPage = 0;
  bool userShowSummary = false;

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
    controller.addListener(() {
      setState(() {
        userShowSummary = userShowSummary || isLast();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: LinearProgressIndicator(
                value: currentPage / (widget.children.length - 1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: SafeArea(
              child: TextButton.icon(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded),
                label: Text(
                  "Descartar",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            child: SafeArea(
              child: Text(
                widget.header,
                style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).textTheme.headline6.color.withOpacity(0.7)
                ),
              ),
            ),
          ),
          if (userShowSummary && !isLast())
            Positioned(
              top: 4,
              right: 4,
              child: SafeArea(
                child: TextButton(
                  onPressed: () {
                    moveToPage(widget.children.length - 1);
                  },
                  child: Row(children: [
                    Text(
                      "Resumen",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ]),
                ),
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
              child: Text(
                isLast() ? "COSECHAR" : "SIGUIENTE",
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isFirst() => currentPage == 0;
  bool isLast() => currentPage == widget.children.length - 1;

  void moveToPage(int page) {
    print("moveToPage: $page");
    controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void movePage(int step) {
    print("movePage: $step");
    controller.animateToPage(
      currentPage + step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
