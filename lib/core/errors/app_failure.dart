/// Typed failure that crosses layer boundaries.
///
/// The UI pattern-matches on [AppFailure] subclasses to render the appropriate
/// calm error state. Never carries stack traces or PII.
sealed class AppFailure {
  const AppFailure();

  /// Localization key for the user-facing message (resolved via ARB).
  abstract final String messageKey;

  @override
  String toString() => 'AppFailure($messageKey)';
}

/// Something went wrong on the local device (file I/O, encryption, etc.).
final class LocalFailure extends AppFailure {
  /// Creates a local-device failure.
  const LocalFailure(this.messageKey);

  @override
  final String messageKey;
}

/// A platform channel returned an error or unexpected type.
final class PlatformFailure extends AppFailure {
  /// Creates a platform-channel failure.
  const PlatformFailure(this.messageKey);

  @override
  final String messageKey;
}

/// A required permission was denied by the user.
final class PermissionFailure extends AppFailure {
  /// Creates a permission-denied failure.
  const PermissionFailure(this.messageKey);

  @override
  final String messageKey;
}

/// Data was not found (empty DB, missing file, etc.).
final class NotFoundFailure extends AppFailure {
  /// Creates a not-found failure.
  const NotFoundFailure(this.messageKey);

  @override
  final String messageKey;
}

/// The app is in an unexpected state (should not happen — indicates a bug).
final class UnexpectedFailure extends AppFailure {
  /// Creates an unexpected failure, defaulting to a generic message key.
  const UnexpectedFailure([this.messageKey = 'errors.unexpected']);

  @override
  final String messageKey;
}
