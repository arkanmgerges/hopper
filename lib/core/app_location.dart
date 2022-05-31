part of hopper;

abstract class AppLocation {
  List<Pattern> get pathPatterns;
  List<AppPage> buildPages();
}