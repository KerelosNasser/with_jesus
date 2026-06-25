/// Typed failure that crosses layer boundaries.
///
/// The UI pattern-matches on [AppFailure] subclasses to render the appropriate
/// calm error state. Never carries stack traces or PII.
sealed class AppFailure {
  const AppFailure();

  /// Human-readable message key for localization (not the raw message).
  abstract final String messageKey;

  @override
  String toString() => 'AppFailure($messageKey)';
}

/// Something went wrong on the local device (file I/O, encryption, etc.).
final class LocalFailure extends AppFailure {
  const LocalFailure(this.messageKey);

  @override
  final String messageKey;
}

/// A platform channel returned an error or unexpected type.
final class PlatformFailure extends AppFailure {
  const PlatformFailure(this.messageKey);

  @override
  final String messageKey;
}

/// A required permission was denied by the user.
final class PermissionFailure extends AppFailure {
  const PermissionFailure(this.messageKey);

  @override
  final String messageKey;
}

/// Data was not found (empty DB, missing file, etc.).
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure(this.messageKey);

  @override
  final String messageKey;
}

/// The app is in an unexpected state (should not happen — indicates a bug).
final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure([this.messageKey = 'errors.unexpected']);

  @override
  final String messageKey;
}
