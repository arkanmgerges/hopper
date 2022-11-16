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
    developer.log(">>>>>>>>>>>>>>> entered pushReplacementPath, path: $path, params: $params", name: 'AbstractAppNavigationManager::pushReplacementPath');
    Completer completer = Completer();
    appRouteDataList = [];
    _addPath(path, completer, params);
    notifyListeners();
    return completer.future;
  }

  /// Pushes a new route
  Future<dynamic> pushPath(String path, [Map<String, dynamic>? params]) {
    developer.log(">>>>>>>>>>>>>>> pushPath: $path", name: 'AbstractAppNavigationManager::pushPath');
    developer.log(">>>>>>>>>>>>>>> appRouteDataList before calling _addPath: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::pushPath');
    Completer completer = Completer();
    _addPath(path, completer, params);
    notifyListeners();
    return completer.future;
  }

  /// Add a path to the list of paths, and notify listeners when the path is added. Also when the path is popped (see [popPage]).
  /// The [Completer] is used to notify the caller when the path is popped.
  /// The params are passed to the [AppPage] that is created.
  void _addPath(String path, Completer? completer, Map<String, dynamic>? params) {
    developer.log(">>>>>>>>>>>>>>> entered _addPath: $path, params: $params", name: 'AbstractAppNavigationManager::_addPath');
    if (appRouteDataList.isNotEmpty && appRouteDataList[appRouteDataList.length - 1].path.contains(path)) {
      developer.log(">>>>>>>>>>>>>>> _addPath: entered condition (1)", name: 'AbstractAppNavigationManager::_addPath');
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
    developer.log(">>>>>>>>>>>>>>> result after for loop $result", name: 'AbstractAppNavigationManager::_addPath');
    var pages = result.buildPages(path, params);
    developer.log(">>>>>>>>>>>>>>> result.buildPages(path, params) --> $pages", name: 'AbstractAppNavigationManager::_addPath');
    if (pages.length > 1) {
      developer.log(">>>>>>>>>>>>>>> pages.length > 1", name: 'AbstractAppNavigationManager::_addPath');
      // It's not allowed to use completer for more than one page
      completer?.complete(null);
      developer.log(">>>>>>>>>>>>>>> before adding to appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::_addPath');
      appRouteDataList.add(AppRouteData(path: path, pages: pages, params: params));
      developer.log(">>>>>>>>>>>>>>> after adding to appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::_addPath');
    } else {
      developer.log(">>>>>>>>>>>>>>> pages.length <= 1", name: 'AbstractAppNavigationManager::_addPath');
      appRouteDataList.add(AppRouteData(path: path, pages: pages, completer: completer, params: params));
      developer.log(">>>>>>>>>>>>>>>pages.length <= 1, appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::_addPath');
    }
  }

  /// Pop the last page from the stack and return the result if exists
    void popPage(dynamic result) {
    //todo logging
    developer.log("pages: ${pages.toString()}", name: 'AppNavigationManager::popPage');
    developer.log(">>>>>>>>>>>>>>> appRouteDataList: ${appRouteDataList.toString()}", name: 'AppNavigationManager::popPage');
    int length = appRouteDataList.length;
    if (length > 0) {
        if (appRouteDataList[length - 1].pages.length > 1) {
          developer.log(">>>>>>>>>>>>>>> entered condition (1)", name: 'AppNavigationManager::popPage');
          appRouteDataList[length - 1].pages.removeLast();
          developer.log(">>>>>>>>>>>>>>> entered condition (1), appRouteDataList: ${appRouteDataList.toString()}", name: 'AppNavigationManager::popPage');
        } else {
          developer.log(">>>>>>>>>>>>>>> entered condition (2)", name: 'AppNavigationManager::popPage');
          if (appRouteDataList[length - 1].completer != null) {
            appRouteDataList[length - 1].completer!.complete(result);
          }
          appRouteDataList.removeLast();
          developer.log(">>>>>>>>>>>>>>> entered condition (2), appRouteDataList: ${appRouteDataList.toString()}", name: 'AppNavigationManager::popPage');
        }
    }

    // Add initial path if there are no pages
    if (appRouteDataList.isEmpty) {
      addInitialPath();
    }

    notifyListeners();
  }

  List<AppRouteData> appRouteDataList = [];

  /// Return the pages by building them from the appRouteDataList
  /// This function also verify the guards and if some patterns apply then it will get the pages by calling the guard() function
  List<AppPage> pages() {
    developer.log(">>>>>>>>>>>>>>> entered pages()", name: 'AbstractAppNavigationManager::pages');
    // Get last app route data in order to check its path with the guard
    AppRouteData? lastAppRouteData = appRouteDataList.isNotEmpty ? appRouteDataList.last : null;
    developer.log(">>>>>>>>>>>>>>> lastAppRouteData: $lastAppRouteData, appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::pages');
    List<AppPage> result = [];
    if (lastAppRouteData == null) {
      return [];
    } else {
      String path = lastAppRouteData.path;
      for (AppNavigationGuard guard in guards) {
        if (guard.shouldGuard(path)) {
          AppLocation? location = guard.guard(path);
          if (location != null) {
            result = location.buildPages(path, lastAppRouteData.params);
            developer.log(">>>>>>>>>>>>>>> location route: ${location.getRoute()} ", name: 'AbstractAppNavigationManager::pages');
            if (lastAppRouteData.path != location.getRoute()) {
              appRouteDataList.add(AppRouteData(path: location.getRoute(), pages: result, params: lastAppRouteData.params));
            }
            //todo logging
            developer.log("pages (from location): ${result.toString()}", name: 'AbstractAppNavigationManager::pages');
            return result;
          } else {
            break;
          }
        }
      }
    }

    result = appRouteDataList.fold<List<AppPage>>([], (List<AppPage> list, AppRouteData routeData) {
      return list..addAll(routeData.pages);
    });
    //todo logging
    developer.log("pages (from app route): ${result.toString()}", name: 'AbstractAppNavigationManager::pages');

    return result;
  }

  void addInitialPath() {
    developer.log(">>>>>>>>>>>>>> addInitialPath [before if(appRouteDataList...], appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::addInitialPath');
    if (appRouteDataList.isEmpty){
    developer.log(">>>>>>>>>>>>>> addInitialPath [after if(appRouteDataList...], appRouteDataList: ${appRouteDataList.toString()}", name: 'AbstractAppNavigationManager::addInitialPath');
    _addPath("/", null, null);
    }
  }

  /// It contains all the instances of type AppNavigationGuard
  List<AppNavigationGuard> guards = [];

  /// It contains all the locations of the app
  List<AppLocation> get locations => [];
}

