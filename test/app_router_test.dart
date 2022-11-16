import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
        key: ValueKey('home'),
        title: 'Home',
        child: HomePage(),
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
          body: SettingsPage(),
        ),
      ),
    ];
  }

  @override
  String getRoute() {
    return route;
  }
}

// Tests
Widget createWidgetUnderTest() {
  final routerDelegate = AppRouter();
  final routeInformationParser = AppRouteInformationParser();

  return MaterialApp.router(
    title: 'Flutter Demo',
    routerDelegate: routerDelegate,
    routeInformationParser: routeInformationParser,
  );
}

void main() {
  testWidgets("Find Hello World! in the home page",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Hello World!'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}

// Pages
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Hello World!"),
        // add button
        ElevatedButton(
          child: const Text("Go to page"),
          onPressed: () {
            context.hopNamed('/app_settings');
          },
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Settings"),
        // add button
        ElevatedButton(
          child: const Text("Return"),
          onPressed: () {
            context.hopBack();
          },
        ),
      ],
    );
  }
}
