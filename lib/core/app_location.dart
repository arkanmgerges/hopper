part of hopper;

abstract class AppLocation {
  List<Pattern> get pathPatterns;
  List<AppPage> buildPages(String path, Map<String, dynamic>? params);

  String getRoute();
}