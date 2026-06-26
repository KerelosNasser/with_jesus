/// A detox reflection prompt: its ARB message key.
///
/// Pure Dart — no Flutter/plugin imports. The localized string itself lives in
/// the ARB files and is looked up via [AppLocalizations] in the UI layer.
class DetoxPrompt {
  const DetoxPrompt(this.key);

  /// ARB key (e.g. `detox.prompt.whyNow`) used to fetch the localized prompt.
  final String key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DetoxPrompt && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'DetoxPrompt($key)';
}
