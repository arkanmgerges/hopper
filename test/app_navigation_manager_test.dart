import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hopper/hopper.dart';
import 'package:mocktail/mocktail.dart';

class MockAbstractAppRouter extends Mock implements AbstractAppRouter {}

void main() {
  group('AppNavigationManager', () {
    test('test number of pages to be 1', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      expect(navManager.pages().length, 1);
    });
    test('test after push a page, number of pages to be 2', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      navManager.pushPath('/app_settings');
      expect(navManager.pages().length, 2);
    });
    test('pop a page from 2 pages and expect 1 to remain', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      navManager.pushPath('/app_settings');
      navManager.popPage(null);
      expect(navManager.pages().length, 1);
    });
    test('pop a page from 2 pages and expect the last page has the path "/"', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      navManager.pushPath('/app_settings');
      navManager.popPage(null);
      expect(navManager.pages()[0].key, const Key('/'));
    });
    test('push the same path multiple times should get only avoid duplication', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      navManager.pushPath('/app_settings');
      navManager.pushPath('/app_settings');
      navManager.pushPath('/app_settings');
      navManager.pushPath('/app_settings');
      // the "/" and "/app_settings" should be the only two pages
      expect(navManager.pages().length, 2);
    });
    test('pop all pages should leave the "/" path only', () {
      var navManager = AppNavigationManager(MockAbstractAppRouter());
      navManager.pushPath('/');
      navManager.pushPath('/app_settings');
      navManager.popPage(null);
      navManager.popPage(null);
      navManager.popPage(null);
      expect(navManager.pages().length, 1);
      expect(navManager.pages()[0].key, const Key('/'));
    });
  });
}

class AppNavigationManager extends AbstractAppNavigationManager {
  final AbstractAppRouter routerDelegate;

  AppNavigationManager(this.routerDelegate) : super(routerDelegate);
  @override
  List<AppNavigationGuard> guards = [
    AppNavigationGuard(
      guardExcludePattern:
      r"(/project_manager_login|/technician_login|/app_settings|/device_assignment)$",
      guardPattern: r"/*",
      guard: (path) {
        return null;
      },
    ),
  ];

  @override
  List<AppLocation> get locations => [
    HomeLocation(),
    SettingsLocation(),
  ];
}

// Locations
class HomeLocation extends AppLocation {
  static const String route = '/';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('/'),
        title: 'Home',
        child: Text('Home Page'),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}

class SettingsLocation extends AppLocation {
  static const String route = '/app_settings';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<AppPage> buildPages(String path, Map<String, dynamic>? params) {
    return [
      const AppPage(
        key: ValueKey('app_settings'),
        title: 'Settings',
        child: Scaffold(
          body: Text("Settings Page"),
        ),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}
