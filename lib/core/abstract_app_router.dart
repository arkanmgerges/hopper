part of hopper;

abstract class AbstractAppRouter extends RouterDelegate<AppRouteData> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteData> {
  final GlobalKey<NavigatorState> navigatorKey;
  final AbstractAppNavigationManager Function(AbstractAppRouter) navigationManagerBuilder;
  static const String initialRoute = '/';

  AbstractAppRouter(this.navigationManagerBuilder) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => navigationManagerBuilder(this),
        builder: (context, child) {
          //todo logging
          developer.log("Building Navigator", name: 'Hopper::AbstractAppRouter::build');
          return Navigator(
            key: navigatorKey,
            pages: context.read<AbstractAppNavigationManager>().pages(),
            onPopPage: (route, result) {
              //todo logging
              developer.log("Navigator::onPopPage - route: $route", name: 'Hopper::AbstractAppRouter::build');
              developer.log("Navigator::onPopPage - result: $result", name: 'Hopper::AbstractAppRouter::build');
              if (!route.didPop(result)) {
                return false;
              }
              context.read<AbstractAppNavigationManager>().popPage(result);
              // notifyListeners();
              return true;
            },
          );
        });
  }

  @override
  Future<void> setNewRoutePath(AppRouteData configuration) async {
    //todo logging
    developer.log(configuration.toString(), name: 'Hopper::AbstractAppRouter::setNewRoutePath');
  }
}



extension AppNavigationManagerExt on BuildContext {
  Future<dynamic> hopNamed(String path) => Provider.of<AbstractAppNavigationManager>(this, listen: false).pushPath(path);
  Future<dynamic> hopReplacementNamed(String path) => Provider.of<AbstractAppNavigationManager>(this, listen: false).pushReplacementPath(path);
  void hopBack(result) => Provider.of<AbstractAppNavigationManager>(this, listen: false).popPage(result);
}






