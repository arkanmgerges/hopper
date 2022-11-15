import 'package:deeplinks/page3_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class Page3Location extends AppLocation {
  static const String route = '/page3';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('page3'),
        title: 'Page 3',
        child: Page3Page(title: 'Page 3',),
      ),
    ];
  }
}