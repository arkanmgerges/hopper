import 'package:flutter_test/flutter_test.dart';
import 'package:hopper/hopper.dart';

void main() {
  group('AppNavigationGuard', () {
    test('test shouldGuard method', () {
      final guard = AppNavigationGuard(
        guardExcludePattern: r"(/project_manager_login|/technician_login|/app_settings|/device_assignment)$",
        guardPattern: r"/*",
        guard: (path) {
          return null;
        },
      );
      expect(guard.shouldGuard('/project_manager_login'), isFalse);
      expect(guard.shouldGuard('/app_settings'), isFalse);
      expect(guard.shouldGuard('/home'), isTrue);
      expect(guard.shouldGuard('/'), isTrue);
    });
  });
}