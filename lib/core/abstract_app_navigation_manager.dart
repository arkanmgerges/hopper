part of hopper;


abstract class AbstractAppNavigationManager extends ChangeNotifier {
  final AbstractAppRouter routerDelegate;

  AbstractAppNavigationManager(this.routerDelegate) {
    //todo logging
    developer.log("pages: ${pages.toString()}", name: 'AbstractAppNavigationManager::constructor');
    addInitialPath();
    addListener(routerDelegate.notifyListeners);
  }


  /// Pushes a new route and replace all the previous routes.
  Future<dynamic> pushReplacementPath(String path, [Map<String, dynamic>? params]) async {
    Completer completer = Completer();
    appRouteDataList = [];
    _addPath(path, completer, params);
    notifyListeners();
    return completer.future;
  }

  /// Pushes a new route
  Future<dynamic> pushPath(String path, [Map<String, dynamic>? params]) {
    Completer completer = Completer();
    _addPath(path, completer, params);
    notifyListeners();
    return completer.future;
  }

  /// Add a path to the list of paths, and notify listeners when the path is added. Also when the path is popped (see [popPage]).
  /// The [Completer] is used to notify the caller when the path is popped.
  /// The params are passed to the [AppPage] that is created.
  void _addPath(String path, Completer? completer, Map<String, dynamic>? params) {
    if (appRouteDataList.isNotEmpty && appRouteDataList[appRouteDataList.length - 1].path.contains(path)) {
      completer?.complete(null);
      return;
    }
    AppLocation? result;
    for (AppLocation location in locations) {
      for (var pathPattern in location.pathPatterns) {
        if (pathPattern == path) {
          result = location;
          break;
        }
        if (result != null) {
          break;
        }
      }
    }
    if (result == null) {
      return;
    }

    var pages = result.buildPages(path, params);
    if (pages.length > 1) {
      // It's not allowed to use completer for more than one page
      completer?.complete(null);
      appRouteDataList.add(AppRouteData(path: path, pages: pages, params: params));
    } else {
      appRouteDataList.add(AppRouteData(path: path, pages: pages, completer: completer, params: params));
    }
  }

  /// Pop the last page from the stack and return the result if exists
    void popPage(dynamic result) {
    //todo logging
    developer.log("pages: ${pages.toString()}", name: 'AppNavigationManager::popPage');

    int length = appRouteDataList.length;
    if (length > 0) {
        if (appRouteDataList[length - 1].pages.length > 1) {
          appRouteDataList[length - 1].pages.removeLast();
        } else {
          if (appRouteDataList[length - 1].completer != null) {
            appRouteDataList[length - 1].completer!.complete(result);
          }
          appRouteDataList.removeLast();
        }
    }

    notifyListeners();
  }

  List<AppRouteData> appRouteDataList = [];

  /// Return the pages by building them from the appRouteDataList
  /// This function also verify the guards and if some patterns apply then it will get the pages by calling the guard() function
  List<AppPage> pages() {
    //todo logging
    developer.log("pages: ${pages.toString()}", name: 'AbstractAppNavigationManager::pages');

    // Get last app route data in order to check its path with the guard
    AppRouteData? lastAppRouteData = appRouteDataList.isNotEmpty ? appRouteDataList.last : null;
    if (lastAppRouteData == null) {
      return [];
    } else {
      String path = lastAppRouteData.path;
      for (AppNavigationGuard guard in guards) {
        if (guard.shouldGuard(path)) {
          AppLocation? location = guard.guard();
          if (location != null) {
            return location.buildPages(path, lastAppRouteData.params);
          } else {
            break;
          }
        }
      }
    }

    return appRouteDataList.fold<List<AppPage>>([], (List<AppPage> list, AppRouteData routeData) {
      return list..addAll(routeData.pages);
    });
  }

  void addInitialPath() {
    if (appRouteDataList.isEmpty){
    _addPath("/", null, null);
    }
  }

  /// It contains all the instances of type AppNavigationGuard
  List<AppNavigationGuard> guards = [];

  /// It contains all the locations of the app
  List<AppLocation> get locations => [];
}

