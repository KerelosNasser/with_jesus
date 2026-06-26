import 'dart:math';

class BibleRandomizerService {
  final Random _random;

  BibleRandomizerService({Random? random}) : _random = random ?? Random();

  ({String book, int chapter}) randomForCategory(String category) {
    final books = _booksByCategory[category];
    if (books == null || books.isEmpty) {
      throw ArgumentError('Unknown category: $category');
    }

    final entry = books[_random.nextInt(books.length)];
    final book = entry.book;
    final chapter = _random.nextInt(entry.chapters) + 1;

    return (book: book, chapter: chapter);
  }
}

final _booksByCategory = <String, List<({String book, int chapters})>>{
  'العهد القديم': [
    (book: 'التكوين', chapters: 50),
    (book: 'الخروج', chapters: 40),
    (book: 'اللاويين', chapters: 27),
    (book: 'العدد', chapters: 36),
    (book: 'التثنية', chapters: 34),
    (book: 'يشوع', chapters: 24),
    (book: 'القضاة', chapters: 21),
    (book: 'راعوث', chapters: 4),
    (book: 'صموئيل الأول', chapters: 31),
    (book: 'صموئيل الثاني', chapters: 24),
    (book: 'الملوك الأول', chapters: 22),
    (book: 'الملوك الثاني', chapters: 25),
    (book: 'أخبار الأيام الأول', chapters: 29),
    (book: 'أخبار الأيام الثاني', chapters: 36),
    (book: 'عزرا', chapters: 10),
    (book: 'نحميا', chapters: 13),
    (book: 'أستير', chapters: 10),
    (book: 'أيوب', chapters: 42),
    (book: 'الأمثال', chapters: 31),
    (book: 'الجامعة', chapters: 12),
    (book: 'نشيد الأنشاد', chapters: 8),
  ],
  'العهد الجديد': [
    (book: 'متى', chapters: 28),
    (book: 'مرقس', chapters: 16),
    (book: 'لوقا', chapters: 24),
    (book: 'يوحنا', chapters: 21),
    (book: 'أعمال الرسل', chapters: 28),
    (book: 'رومية', chapters: 16),
    (book: 'كورنثوس الأولى', chapters: 16),
    (book: 'كورنثوس الثانية', chapters: 13),
    (book: 'غلاطية', chapters: 6),
    (book: 'أفسس', chapters: 6),
    (book: 'فيلبي', chapters: 4),
    (book: 'كولوسي', chapters: 4),
    (book: 'تسالونيكي الأولى', chapters: 5),
    (book: 'تسالونيكي الثانية', chapters: 3),
    (book: 'تيموثاوس الأولى', chapters: 6),
    (book: 'تيموثاوس الثانية', chapters: 4),
    (book: 'تيطس', chapters: 3),
    (book: 'فليمون', chapters: 1),
    (book: 'عبرانيين', chapters: 13),
    (book: 'يعقوب', chapters: 5),
    (book: 'بطرس الأولى', chapters: 5),
    (book: 'بطرس الثانية', chapters: 3),
    (book: 'يوحنا الأولى', chapters: 5),
    (book: 'يوحنا الثانية', chapters: 1),
    (book: 'يوحنا الثالثة', chapters: 1),
    (book: 'يهوذا', chapters: 1),
    (book: 'الرؤيا', chapters: 22),
  ],
  'مزامير داود': [
    (book: 'المزامير', chapters: 150),
  ],
  'الأنبياء': [
    (book: 'إشعياء', chapters: 66),
    (book: 'إرميا', chapters: 52),
    (book: 'مراثي إرميا', chapters: 5),
    (book: 'حزقيال', chapters: 48),
    (book: 'دانيال', chapters: 12),
    (book: 'هوشع', chapters: 14),
    (book: 'يويئيل', chapters: 3),
    (book: 'عاموس', chapters: 9),
    (book: 'عوبديا', chapters: 1),
    (book: 'يونان', chapters: 4),
    (book: 'ميخا', chapters: 7),
    (book: 'ناحوم', chapters: 3),
    (book: 'حبقوق', chapters: 3),
    (book: 'صفنيا', chapters: 3),
    (book: 'حجي', chapters: 2),
    (book: 'زكريا', chapters: 14),
    (book: 'ملاخي', chapters: 4),
  ],
};
