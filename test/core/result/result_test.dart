import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/core/core.dart';

void main() {
  group('Result', () {
    test('success holds data and reports isSuccess', () {
      const result = Result<int>.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.requireData, 42);
    });

    test('failure holds AppFailure and reports isFailure', () {
      const result = Result<int>.failure(LocalFailure('errors.io'));

      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<LocalFailure>());
      expect(result.failure.messageKey, 'errors.io');
    });

    test('requireData throws StateError on Failure', () {
      const result = Result<int>.failure(NotFoundFailure('errors.missing'));

      expect(() => result.requireData, throwsStateError);
    });

    test('map transforms success data', () {
      const result = Result<int>.success(5);

      final mapped = result.map((n) => n * 2);

      expect(mapped.isSuccess, isTrue);
      expect(mapped.requireData, 10);
    });

    test('map propagates failure unchanged', () {
      const failure = NotFoundFailure('errors.missing');
      const result = Result<int>.failure(failure);

      final mapped = result.map((n) => n * 2);

      expect(mapped.isFailure, isTrue);
      expect((mapped as Failure<int>).failure, failure);
    });

    test('map changes the success type parameter', () {
      const result = Result<int>.success(7);

      final mapped = result.map((n) => 'value-$n');

      expect(mapped, isA<Success<String>>());
      expect((mapped as Success<String>).data, 'value-7');
    });

    test('equality works for success', () {
      expect(const Result<int>.success(1), const Result<int>.success(1));
      expect(const Result<int>.success(1), isNot(const Result<int>.success(2)));
    });

    test('equality works for failure', () {
      const f = LocalFailure('errors.io');
      expect(const Result<int>.failure(f), const Result<int>.failure(f));
    });
  });
}
