class BibleApp {
  final String id;
  final String label;
  final String packageId;
  final String? iconAsset;

  const BibleApp({
    required this.id,
    required this.label,
    required this.packageId,
    this.iconAsset,
  });
}

const kSupportedBibleApps = [
  BibleApp(id: 'coptic_reader', label: 'Coptic Reader', packageId: 'com.app.copticreader'),
];
