import 'package:flutter/material.dart';
// https://gist.github.com/schultek/cc2acd8014be255c2a639a98d47be4e0
class NestedWillPopScope extends StatefulWidget {
  const NestedWillPopScope({
    Key key,
    @required this.child,
    @required this.onWillPop,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  _NestedWillPopScopeState createState() => _NestedWillPopScopeState();

  static _NestedWillPopScopeState of(BuildContext context) {
    return context.findAncestorStateOfType<_NestedWillPopScopeState>();
  }
}

class _NestedWillPopScopeState extends State<NestedWillPopScope> {
  ModalRoute<dynamic> _route;

  _NestedWillPopScopeState _descendant;
  set descendant(state) {
    _descendant = state;
    updateRouteCallback();
  }

  Future<bool> onWillPop() async {
    bool willPop;
    if (_descendant != null) {
      willPop = await _descendant.onWillPop();
    }
    if (willPop == null || willPop) {
      willPop = await widget.onWillPop();
    }
    return willPop;
  }

  void updateRouteCallback() {
    _route?.removeScopedWillPopCallback(onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(onWillPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var parentGuard = NestedWillPopScope.of(context);
    if (parentGuard != null) {
      parentGuard.descendant = this;
    }
    updateRouteCallback();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}