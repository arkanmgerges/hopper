import 'package:deeplinks/page1_page.dart';
import 'package:deeplinks/page2_page.dart';
import 'package:deeplinks/page3_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class DeeplinkLocation extends AppLocation {
  static const String route = '/deeplink';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('page 1'),
        title: 'Page 1',
        child: Page1Page(title: 'Page 1',),
      ),
      const AppPage(
        key: ValueKey('page 2'),
        title: 'Page 2',
        child: Page2Page(title: 'Page 2',),
      ),
      const AppPage(
        key: ValueKey('page 3'),
        title: 'Page 3',
        child: Page3Page(title: 'Page 3',),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}