import 'package:deeplinks/page1_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class Page1Location extends AppLocation {
  static const String route = '/page1';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('page1'),
        title: 'Page 1',
        child: Page1Page(title: 'Page 1',),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}