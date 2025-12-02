import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Poster'**
  String get appTitle;

  /// No description provided for @productModeLabel.
  ///
  /// In en, this message translates to:
  /// **'📦 Post Product'**
  String get productModeLabel;

  /// No description provided for @simpleModeLabel.
  ///
  /// In en, this message translates to:
  /// **'💬 Simple Message'**
  String get simpleModeLabel;

  /// No description provided for @platformSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to post?'**
  String get platformSelectorTitle;

  /// No description provided for @platformTelegram.
  ///
  /// In en, this message translates to:
  /// **'📱 Telegram'**
  String get platformTelegram;

  /// No description provided for @platformTwitter.
  ///
  /// In en, this message translates to:
  /// **'🐦 X (Twitter)'**
  String get platformTwitter;

  /// No description provided for @platformWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Select at least one platform'**
  String get platformWarning;

  /// No description provided for @productLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Product link'**
  String get productLinkLabel;

  /// No description provided for @productLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://www.mercadolivre.com.br/product...'**
  String get productLinkHint;

  /// No description provided for @supportedStoresDescription.
  ///
  /// In en, this message translates to:
  /// **'Supports: Mercado Livre, Amazon, and Shopee'**
  String get supportedStoresDescription;

  /// No description provided for @analyzeProductButton.
  ///
  /// In en, this message translates to:
  /// **'🔍 Analyze Product'**
  String get analyzeProductButton;

  /// No description provided for @analyzingProductButton.
  ///
  /// In en, this message translates to:
  /// **'🔍 Analyzing product...'**
  String get analyzingProductButton;

  /// No description provided for @productFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'✅ Product found!'**
  String get productFoundTitle;

  /// No description provided for @productTitleWithValue.
  ///
  /// In en, this message translates to:
  /// **'Title: {title}'**
  String productTitleWithValue(Object title);

  /// No description provided for @emojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emojiLabel;

  /// No description provided for @phraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Catchy phrase (editable)'**
  String get phraseLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (edit if different)'**
  String get priceLabel;

  /// No description provided for @priceEditedWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Edited price (original: {price})'**
  String priceEditedWarning(Object price);

  /// No description provided for @couponFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon? (leave blank if not)'**
  String get couponFieldLabel;

  /// No description provided for @couponFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: FREESHIP'**
  String get couponFieldHint;

  /// No description provided for @postResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result:'**
  String get postResultLabel;

  /// No description provided for @postBothButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Post to both networks'**
  String get postBothButton;

  /// No description provided for @postTelegramButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Post to Telegram'**
  String get postTelegramButton;

  /// No description provided for @postTwitterButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Post to X'**
  String get postTwitterButton;

  /// No description provided for @postPostingButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Posting...'**
  String get postPostingButton;

  /// No description provided for @messageFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageFieldLabel;

  /// No description provided for @messageFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get messageFieldHint;

  /// No description provided for @sendBothButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Send to both networks'**
  String get sendBothButton;

  /// No description provided for @sendTelegramButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Send to Telegram'**
  String get sendTelegramButton;

  /// No description provided for @sendTwitterButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Send to X'**
  String get sendTwitterButton;

  /// No description provided for @sendPostingButton.
  ///
  /// In en, this message translates to:
  /// **'📤 Sending...'**
  String get sendPostingButton;

  /// No description provided for @validationProductUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the product URL!'**
  String get validationProductUrlRequired;

  /// No description provided for @validationScrapeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please analyze the product before posting!'**
  String get validationScrapeFirst;

  /// No description provided for @validationSelectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select at least one platform to send!'**
  String get validationSelectPlatform;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please type a message!'**
  String get validationMessageRequired;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get genericError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
