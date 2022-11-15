import 'package:deeplinks/router/classes.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = AppRouter();
  final routeInformationParser = AppRouteInformationParser();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
    );
  }
}


