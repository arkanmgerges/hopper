part of hopper;

class AppNavigationGuard {
  final Pattern guardPattern;
  final Pattern? guardExcludePattern;
  final AppLocation? Function(String) guard;

  AppNavigationGuard({required this.guardPattern, required this.guard, this.guardExcludePattern});

  /// Returns true if the guard pattern matches the given path.
  bool shouldGuard(String path) {
    //todo logging
    developer.log("path: $path", name: 'AppNavigationGuard::shouldGuard');

    RegExp? reExclude, reGuard;
    if (guardExcludePattern is String && (guardExcludePattern as String).isNotEmpty) {
      reExclude = tryCastToRegExp(guardExcludePattern!);
    }
    if (guardPattern is String && (guardPattern as String).isNotEmpty) {
      reGuard = tryCastToRegExp(guardPattern);
    }

    if (reExclude == null || reGuard == null) {
      return false;
    }

    if (!reExclude.hasMatch(path)) {
      return reGuard.hasMatch(path);
    } else {
      return false;
    }
  }

  RegExp tryCastToRegExp(Pattern pattern) {
    try {
      if (pattern is String) {
        return RegExp(pattern);
      }
      return pattern as RegExp;
    } on TypeError catch (_) {
      throw FlutterError.fromParts([
        DiagnosticsNode.message('Path can either be:',
            level: DiagnosticLevel.summary),
        DiagnosticsNode.message('1. String'),
        DiagnosticsNode.message('2. RegExp instance')
      ]);
    }
  }
}