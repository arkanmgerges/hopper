import 'package:deeplinks/page2_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class Page2Location extends AppLocation {
  static const String route = '/page2';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('page2'),
        title: 'Page 2',
        child: Page2Page(title: 'Page 2',),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}