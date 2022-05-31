part of hopper;

class AppRouteData {
  final String path;
  final List<AppPage> pages;
  final Completer? completer;

  AppRouteData({required this.path, required this.pages, this.completer});
}
