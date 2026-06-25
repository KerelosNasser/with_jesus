/// Sealed type representing the outcome of an operation that can succeed or fail.
///
/// Used at all layer boundaries so the UI renders explicit empty/error states
/// instead of relying on uncaught exceptions. Example:
///
/// ```dart
/// Result<List<Hymn>> result = await repository.getHymns();
/// switch (result) {
///   case Success(:final data):
///     renderHymns(data);
///   case Failure(:final failure):
///     renderError(failure);
/// }
/// ```
library;

import '../errors/app_failure.dart';

/// Outcome of an operation: either [Success] with data or [Failure] with an
/// [AppFailure]. Pattern-match rather than throwing across layers.
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result] carrying [data].
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed [Result] carrying [failure].
  const factory Result.failure(AppFailure failure) = Failure<T>;

  /// Returns the success value, or throws [StateError] if this is a [Failure].
  ///
  /// Prefer pattern-matching; use this only when failure is logically impossible.
  T get requireData => switch (this) {
        Success<T>(:final data) => data,
        Failure<T>(:final failure) =>
          throw StateError('Cannot get data from a Failure: $failure'),
      };
}

/// Successful result carrying [data].
final class Success<T> extends Result<T> {
  /// Creates a success value.
  const Success(this.data);

  /// The success value.
  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Result.success($data)';
}

/// Failed result carrying an [AppFailure].
final class Failure<T> extends Result<T> {
  /// Creates a failure.
  const Failure(this.failure);

  /// Describes what went wrong.
  final AppFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Result.failure($failure)';
}

/// Pattern helpers on [Result].
extension ResultMap<T> on Result<T> {
  /// Transforms the success data using [fn]. Failure passes through unchanged.
  Result<R> map<R>(R Function(T data) fn) => switch (this) {
        Success<T>(:final data) => Result.success(fn(data)),
        Failure<T>(:final failure) => Result<R>.failure(failure),
      };

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure].
  bool get isFailure => this is Failure<T>;
}
