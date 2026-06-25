/// Sealed type representing the outcome of an operation that can succeed or fail.
///
/// Used at all layer boundaries so the UI renders explicit empty/error states
/// instead of relying on uncaught exceptions.
sealed class Result<T> {
  const Result();

  /// Convenience constructors.
  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppFailure failure) = Failure<T>;

  /// Returns the success value, or throws [StateError] if this is a [Failure].
  T get requireData {
    final self = this;
    if (self is Success<T>) return self.data;
    throw StateError('Cannot get data from Failure: ${(this as Failure<T>).failure}');
  }
}

/// Successful result carrying [data].
final class Success<T> extends Result<T> {
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
  const Failure(this.failure);

  /// The failure describing what went wrong.
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

/// Maps the success value with [fn] if this is a [Success], otherwise
/// propagates the [Failure] unchanged.
extension ResultMap<T> on Result<T> {
  /// Transforms the success data using [fn]. Failure passes through.
  Result<R> map<R>(R Function(T data) fn) {
    final self = this;
    return switch (self) {
      Success<T>(:final data) => Result.success(fn(data)),
      Failure<T>(:final failure) => Result<R>.failure(failure),
    };
  }

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure].
  bool get isFailure => this is Failure<T>;
}
