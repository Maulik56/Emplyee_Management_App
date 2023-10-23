import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(
    String routeName, {
    bool clearStack = false,
    Object? arguments,
  }) {
    final navigator = navigatorKey.currentState;

    var future;

    if (clearStack) {
      future = navigator!.pushNamedAndRemoveUntil(
        routeName,
        (check) => false,
        arguments: arguments,
      );
    } else {
      future = navigator!.pushNamed(routeName, arguments: arguments);
    }

    return future;
  }

  void replaceWith(String route, {Object? arguments}) {
    navigateTo(route, clearStack: true, arguments: arguments);
  }

  void pop<T extends Object>([T? result]) {
    return navigatorKey.currentState!.pop<T?>(result);
  }

  Future<void> popAndPush(String routeName, {Object? arguments}) async {
    await navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  void popUntil<T extends Object>(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  Future<void> popUntilAndReset(String routeName, {Object? arguments}) async {
    popUntil(routeName);
    await navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }
}
