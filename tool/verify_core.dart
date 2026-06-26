// Temporary standalone verification of core domain logic.
// Runs via `dart run tool/verify_core.dart` to bypass the Flutter test native
// build (objective_c MSVC) limitation on this Windows host. The canonical
// tests live in test/core/ and run under `flutter test` in CI (Ubuntu runner).
// To be deleted once the host test runner works or after M1 sign-off.
import 'package:with_jesus/core/errors/app_failure.dart';
import 'package:with_jesus/core/result/result.dart';

void main() {
  const s = Result<int>.success(42);
  assert(s.isSuccess);
  assert(!s.isFailure);
  assert(s.requireData == 42);
  print('PASS: success holds data');

  const f = Result<int>.failure(LocalFailure('errors.io'));
  assert(f.isFailure);
  assert(!f.isSuccess);
  const fAsFailure = f as Failure<int>;
  assert(fAsFailure.failure is LocalFailure);
  assert(fAsFailure.failure.messageKey == 'errors.io');
  print('PASS: failure holds AppFailure');

  try {
    const Result<int>.failure(NotFoundFailure('x')).requireData;
    assert(false, 'should throw');
  } on StateError {
    print('PASS: requireData throws StateError');
  }

  final m1 = const Result<int>.success(5).map((n) => n * 2);
  assert(m1.isSuccess && m1.requireData == 10);
  print('PASS: map transforms success');

  const nf = NotFoundFailure('m');
  final m2 = const Result<int>.failure(nf).map((n) => n * 2);
  assert(m2.isFailure);
  assert((m2 as Failure<int>).failure == nf);
  print('PASS: map propagates failure');

  final m3 = const Result<int>.success(7).map((n) => 'v$n');
  assert(m3 is Success<String> && (m3).data == 'v7');
  print('PASS: map changes type param');

  assert(const Result<int>.success(1) == const Result<int>.success(1));
  assert(const Result<int>.success(1) != const Result<int>.success(2));
  print('PASS: equality');

  assert(const LocalFailure('a').messageKey == 'a');
  assert(const PlatformFailure('a').messageKey == 'a');
  assert(const PermissionFailure('a').messageKey == 'a');
  assert(const NotFoundFailure('a').messageKey == 'a');
  assert(const UnexpectedFailure().messageKey == 'errors.unexpected');
  print('PASS: AppFailure subclasses');

  print('\nALL CORE DOMAIN ASSERTIONS PASSED');
}
