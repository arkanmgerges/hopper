<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->


<p align="center">
<img  width="220" src="https://raw.githubusercontent.com/arkanmgerges/hopper/master/resources/hopper.svg">
</p>

## A package for using Flutter Navigator 2.0.

## Features

* It supports deep links
* It supports passing parameters to other pages associated with the path
* It supports async calls like `await hopNamed('/setting_page')`
* It supports guards

## Why did I write this package?
I had an app which I developed for a client which It used Flutter Navigator 1.0, and I needed a new package a new use case to navigate to deep links which version 1.0 does not support. Then I decided to try some package out there on pub.dev [beamer](https://pub.dev/packages/beamer) which is a good package but unfortunately it did not support `await beamNamed(...etc)`, so I opened a thread [on github.com](https://github.com/slovnicki/beamer/issues/525), and the author mentioned that this will be added (as for today is 06.feb.2022 when I'm mentioning it here in this readme, and maybe in the future as you are reading this, it's already added).

So I decided to create this package and to migrate my app to it, and also I was in a hurry to write this package in order to finish my tasks related to the job (mobile app for the client).

**This package until version 1.0.0 was written in 2 days**

## Getting started

### Simple app with one home page
1. Add the package into your pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter

  hopper: ^1.1.0

```
2. Create your `main.dart` file and add the following code:
```dart
import 'package:counter/router/classes.dart';
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
```

3. Create a folder (not necessary) named `router` inside the `lib` folder and create a file named `classes.dart` (you can choose any name, but then you need to import it) and add the following code:
```dart
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
```

4. Add a home page (this ia a counter app page)
```dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

5. Run the app

## Guards
The package also supports guards

```dart
class AppNavigationManager extends AbstractAppNavigationManager {
  final AbstractAppRouter routerDelegate;

  AppNavigationManager(this.routerDelegate) : super(routerDelegate);

  @override
  List<AppNavigationGuard> guards = [
    AppNavigationGuard(
      guardExcludePattern: r"(/project_manager_login|/technician_login|/app_settings|/device_assignment)$",
      guardPattern: r"/*",
      guard: (path) {
        final appCubit = AppDi().appCubit();
        if (appCubit.state.appToken.isEmpty &&
            appCubit.state.authToken.isEmpty) {
          return ProjectManagerLoginLocation();
        } else if (appCubit.state.appToken.isNotEmpty &&
            appCubit.state.authToken.isEmpty) {
          return TechnicianLoginLocation();
        } else if (appCubit.state.appToken.isEmpty &&
            appCubit.state.authToken.isNotEmpty) {
          return DeviceAssignmentLocation();
        } else {
          return null;
        }
      },
    ),
  ];

  @override
  List<AppLocation> get locations => [
    ProjectManagerLoginLocation(),
    DeviceAssignmentLocation(),
    TechnicianLoginLocation(),
    AppSettingsLocation(),
    HomeLocation(),
  ];
}

```



## Usage
The package uses extension with `BuildContext`, see the following examples:

#### You can navigate to a page by using:
    * context.hopNamed('/home');
    * context.hopReplacementNamed('/home');

### You can pass parameters associated with the path:
    * context.hopNamed('/home', {"id": 1, "name": "John"});

### Return from a page
    * context.hopBack();
    * context.hopBack(result); // return a result from a page

### Close a dialog window or drawer
    * Navigator.of(context).pop();

### You can wait for a result from a page:
    * int code = await context.hopNamed('/get_some_code');


## Additional information

Check the `exmple` folder for more examples.
You will find also `deeplinks` example that shows how to jump into the deep page and get back to previous page(s).

## Contribution
You can contribute to this package in order to make add new features, fix bugs, etc.

## Note
This package is not suitable for browser based applications (By contribution it can make it possible to use it in a browser based app).