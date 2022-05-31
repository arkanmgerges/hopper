part of hopper;

class AppRouteData {
  final String path;
  final List<AppPage> pages;
  final Completer? completer;
  final Map<String, dynamic>? params;

  AppRouteData({required this.path, required this.pages, this.completer, this.params});
}
