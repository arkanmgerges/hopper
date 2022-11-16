import 'package:deeplinks/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class HomeLocation extends AppLocation {
  static const String route = '/';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('home'),
        title: 'Home',
        child: HomePage(title: 'Home Page',),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}