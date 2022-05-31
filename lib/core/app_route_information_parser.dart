part of hopper;

class AppRouteInformationParser extends RouteInformationParser<AppRouteData> {
  @override
  RouteInformation restoreRouteInformation(AppRouteData configuration) {
    //todo logging
    developer.log("configuration: ${configuration.toString()}", name: 'AppRouteInformationParser::restoreRouteInformation');

    return const RouteInformation(location: "/");
  }

  @override
  Future<AppRouteData> parseRouteInformation(RouteInformation routeInformation) async {
    //todo logging
    developer.log("routeInformation: ${routeInformation.toString()}", name: 'AppRouteInformationParser::parseRouteInformation');

    return AppRouteData(path: '/', pages: []);
  }
}