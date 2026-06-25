import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/core/core.dart';

void main() {
  group('AppFailure', () {
    test('LocalFailure holds messageKey', () {
      const f = LocalFailure('errors.io');
      expect(f.messageKey, 'errors.io');
      expect(f.toString(), 'AppFailure(errors.io)');
    });

    test('PlatformFailure holds messageKey', () {
      const f = PlatformFailure('errors.platform');
      expect(f.messageKey, 'errors.platform');
    });

    test('PermissionFailure holds messageKey', () {
      const f = PermissionFailure('errors.permission.audio');
      expect(f.messageKey, 'errors.permission.audio');
    });

    test('NotFoundFailure holds messageKey', () {
      const f = NotFoundFailure('errors.not_found.hymn');
      expect(f.messageKey, 'errors.not_found.hymn');
    });

    test('UnexpectedFailure has default messageKey', () {
      const f = UnexpectedFailure();
      expect(f.messageKey, 'errors.unexpected');
    });

    test('UnexpectedFailure accepts custom messageKey', () {
      const f = UnexpectedFailure('errors.weird');
      expect(f.messageKey, 'errors.weird');
    });

    test('each subclass is a distinct AppFailure subtype', () {
      const failures = <AppFailure>[
        LocalFailure('a'),
        PlatformFailure('a'),
        PermissionFailure('a'),
        NotFoundFailure('a'),
        UnexpectedFailure('a'),
      ];

      expect(failures.map((f) => f.runtimeType.toString()).toList(), [
        'LocalFailure',
        'PlatformFailure',
        'PermissionFailure',
        'NotFoundFailure',
        'UnexpectedFailure',
      ]);
    });
  });
}
