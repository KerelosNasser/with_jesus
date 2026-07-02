import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'With Jesus'**
  String get appTitle;

  /// No description provided for @detoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Detox'**
  String get detoxTitle;

  /// No description provided for @detoxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a mindful break from your phone'**
  String get detoxSubtitle;

  /// No description provided for @detoxStartSession.
  ///
  /// In en, this message translates to:
  /// **'Begin Detox'**
  String get detoxStartSession;

  /// No description provided for @detoxEndSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get detoxEndSession;

  /// No description provided for @detoxActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Detox Session Active'**
  String get detoxActiveSession;

  /// No description provided for @detoxTimeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get detoxTimeRemaining;

  /// No description provided for @detoxDurationQuarter.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get detoxDurationQuarter;

  /// No description provided for @detoxDurationHalf.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get detoxDurationHalf;

  /// No description provided for @detoxDurationFull.
  ///
  /// In en, this message translates to:
  /// **'60 min'**
  String get detoxDurationFull;

  /// No description provided for @detoxReflectionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Before you begin, reflect on this:'**
  String get detoxReflectionPrompt;

  /// No description provided for @detoxReflectionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip Reflection'**
  String get detoxReflectionSkip;

  /// No description provided for @detoxReflectionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get detoxReflectionContinue;

  /// No description provided for @detoxReflectionAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your reflection (optional)'**
  String get detoxReflectionAnswer;

  /// No description provided for @detoxReflectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Reflections'**
  String get detoxReflectionsTitle;

  /// No description provided for @detoxReflectionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reflections yet'**
  String get detoxReflectionsEmpty;

  /// No description provided for @detoxReflectionsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your detox reflections will appear here'**
  String get detoxReflectionsEmptySubtitle;

  /// No description provided for @detoxReflectionDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this reflection?'**
  String get detoxReflectionDeleteConfirm;

  /// No description provided for @detoxLauncherDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default launcher'**
  String get detoxLauncherDefault;

  /// No description provided for @detoxLauncherActive.
  ///
  /// In en, this message translates to:
  /// **'Currently your default launcher'**
  String get detoxLauncherActive;

  /// No description provided for @detoxAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Always-on Detox'**
  String get detoxAlwaysOn;

  /// No description provided for @detoxAlwaysOnDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable phone detox as a persistent feature'**
  String get detoxAlwaysOnDesc;

  /// No description provided for @detoxSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get detoxSessionComplete;

  /// No description provided for @detoxSessionCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Well done. You took a mindful break.'**
  String get detoxSessionCompleteMessage;

  /// No description provided for @detoxBreathe.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get detoxBreathe;

  /// No description provided for @detoxPromptWhyNow.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to reduce phone time today?'**
  String get detoxPromptWhyNow;

  /// No description provided for @detoxPromptWhatInstead.
  ///
  /// In en, this message translates to:
  /// **'What would you rather do with this time?'**
  String get detoxPromptWhatInstead;

  /// No description provided for @detoxPromptOneThingForGod.
  ///
  /// In en, this message translates to:
  /// **'What is one thing you can offer to God today?'**
  String get detoxPromptOneThingForGod;

  /// No description provided for @detoxPromptJustBreathe.
  ///
  /// In en, this message translates to:
  /// **'Can you just breathe for a moment?'**
  String get detoxPromptJustBreathe;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @hymnsTab.
  ///
  /// In en, this message translates to:
  /// **'Hymns'**
  String get hymnsTab;

  /// No description provided for @journalTab.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTab;

  /// No description provided for @focusTab.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTab;

  /// No description provided for @calmTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calmTitle;

  /// No description provided for @calmBreathe.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get calmBreathe;

  /// No description provided for @calmPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get calmPrayer;

  /// No description provided for @calmAmbience.
  ///
  /// In en, this message translates to:
  /// **'Ambience'**
  String get calmAmbience;

  /// No description provided for @calmBreathing478.
  ///
  /// In en, this message translates to:
  /// **'4-7-8 Relaxing'**
  String get calmBreathing478;

  /// No description provided for @calmBreathingBox.
  ///
  /// In en, this message translates to:
  /// **'Box Breathing'**
  String get calmBreathingBox;

  /// No description provided for @calmBreathingCoherent.
  ///
  /// In en, this message translates to:
  /// **'Coherent (5-5)'**
  String get calmBreathingCoherent;

  /// No description provided for @calmBreathingDefault.
  ///
  /// In en, this message translates to:
  /// **'Gentle (4-6)'**
  String get calmBreathingDefault;

  /// No description provided for @calmPhaseInhale.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get calmPhaseInhale;

  /// No description provided for @calmPhaseHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get calmPhaseHold;

  /// No description provided for @calmPhaseExhale.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get calmPhaseExhale;

  /// No description provided for @calmPhaseHoldAfterExhale.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get calmPhaseHoldAfterExhale;

  /// No description provided for @calmPrayerTimer.
  ///
  /// In en, this message translates to:
  /// **'Prayer Timer'**
  String get calmPrayerTimer;

  /// No description provided for @calmPrayerChime.
  ///
  /// In en, this message translates to:
  /// **'Chime at end'**
  String get calmPrayerChime;

  /// No description provided for @calmPrayerClosingText.
  ///
  /// In en, this message translates to:
  /// **'Closing words'**
  String get calmPrayerClosingText;

  /// No description provided for @calmPrayerStart.
  ///
  /// In en, this message translates to:
  /// **'Begin'**
  String get calmPrayerStart;

  /// No description provided for @calmPrayerEnd.
  ///
  /// In en, this message translates to:
  /// **'End prayer'**
  String get calmPrayerEnd;

  /// No description provided for @calmPrayerComplete.
  ///
  /// In en, this message translates to:
  /// **'Amen'**
  String get calmPrayerComplete;

  /// No description provided for @calmAmbienceRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get calmAmbienceRain;

  /// No description provided for @calmAmbienceChurchBells.
  ///
  /// In en, this message translates to:
  /// **'Church Bells'**
  String get calmAmbienceChurchBells;

  /// No description provided for @calmAmbienceWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get calmAmbienceWind;

  /// No description provided for @calmAmbienceChantEcho.
  ///
  /// In en, this message translates to:
  /// **'Chant Echo'**
  String get calmAmbienceChantEcho;

  /// No description provided for @calmAmbienceVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get calmAmbienceVolume;

  /// No description provided for @calmSelectPattern.
  ///
  /// In en, this message translates to:
  /// **'Choose a pattern'**
  String get calmSelectPattern;

  /// No description provided for @calmSelectDuration.
  ///
  /// In en, this message translates to:
  /// **'Choose duration'**
  String get calmSelectDuration;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
