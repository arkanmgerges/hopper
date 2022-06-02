import 'package:counter/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class AppRouter extends AbstractAppRouter {
  final GlobalKey<NavigatorState> navigatorKey;
  static const String initialRoute = '/';

  AppRouter()
      : navigatorKey = GlobalKey<NavigatorState>(),
        super((AbstractAppRouter appRouter) => AppNavigationManager(appRouter));
}

class AppNavigationManager extends AbstractAppNavigationManager {
  final AbstractAppRouter routerDelegate;

  AppNavigationManager(this.routerDelegate) : super(routerDelegate);

  @override
  List<AppLocation> get locations => [
    HomeLocation(),
  ];
}

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
}