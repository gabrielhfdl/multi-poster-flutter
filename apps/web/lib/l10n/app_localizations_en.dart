// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Multi-Poster';

  @override
  String get productModeLabel => '📦 Post Product';

  @override
  String get simpleModeLabel => '💬 Simple Message';

  @override
  String get platformSelectorTitle => 'Where to post?';

  @override
  String get platformTelegram => '📱 Telegram';

  @override
  String get platformTwitter => '🐦 X (Twitter)';

  @override
  String get platformWarning => '⚠️ Select at least one platform';

  @override
  String get productLinkLabel => 'Product link';

  @override
  String get productLinkHint => 'https://www.mercadolivre.com.br/product...';

  @override
  String get supportedStoresDescription =>
      'Supports: Mercado Livre, Amazon, and Shopee';

  @override
  String get analyzeProductButton => '🔍 Analyze Product';

  @override
  String get analyzingProductButton => '🔍 Analyzing product...';

  @override
  String get productFoundTitle => '✅ Product found!';

  @override
  String productTitleWithValue(Object title) {
    return 'Title: $title';
  }

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get phraseLabel => 'Catchy phrase (editable)';

  @override
  String get priceLabel => 'Price (edit if different)';

  @override
  String priceEditedWarning(Object price) {
    return '⚠️ Edited price (original: $price)';
  }

  @override
  String get couponFieldLabel => 'Have a coupon? (leave blank if not)';

  @override
  String get couponFieldHint => 'Ex: FREESHIP';

  @override
  String get postResultLabel => 'Result:';

  @override
  String get postBothButton => '📤 Post to both networks';

  @override
  String get postTelegramButton => '📤 Post to Telegram';

  @override
  String get postTwitterButton => '📤 Post to X';

  @override
  String get postPostingButton => '📤 Posting...';

  @override
  String get messageFieldLabel => 'Message';

  @override
  String get messageFieldHint => 'Type your message here...';

  @override
  String get sendBothButton => '📤 Send to both networks';

  @override
  String get sendTelegramButton => '📤 Send to Telegram';

  @override
  String get sendTwitterButton => '📤 Send to X';

  @override
  String get sendPostingButton => '📤 Sending...';

  @override
  String get validationProductUrlRequired => 'Please enter the product URL!';

  @override
  String get validationScrapeFirst =>
      'Please analyze the product before posting!';

  @override
  String get validationSelectPlatform =>
      'Select at least one platform to send!';

  @override
  String get validationMessageRequired => 'Please type a message!';

  @override
  String get genericError => 'Something went wrong. Try again.';
}
