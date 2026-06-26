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
  BibleApp(id: 'catena', label: 'Catena Bible', packageId: 'com.catena'),
  BibleApp(id: 'coptic_reader', label: 'Coptic Reader', packageId: 'com.app.copticreader'),
  BibleApp(id: 'orsozoxi', label: 'أرثوذكسى + القطمارس', packageId: 'coptic.avabishoy.katamars'),
];
