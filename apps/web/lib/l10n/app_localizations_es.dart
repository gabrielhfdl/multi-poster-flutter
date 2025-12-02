// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Multi-Poster';

  @override
  String get productModeLabel => '📦 Publicar producto';

  @override
  String get simpleModeLabel => '💬 Mensaje simple';

  @override
  String get platformSelectorTitle => '¿Dónde publicar?';

  @override
  String get platformTelegram => '📱 Telegram';

  @override
  String get platformTwitter => '🐦 X (Twitter)';

  @override
  String get platformWarning => '⚠️ Selecciona al menos una plataforma';

  @override
  String get productLinkLabel => 'Enlace del producto';

  @override
  String get productLinkHint => 'https://www.mercadolibre.com/producto...';

  @override
  String get supportedStoresDescription => 'Compatible con: Mercado Libre, Amazon y Shopee';

  @override
  String get analyzeProductButton => '🔍 Analizar producto';

  @override
  String get analyzingProductButton => '🔍 Analizando producto...';

  @override
  String get productFoundTitle => '✅ ¡Producto encontrado!';

  @override
  String productTitleWithValue(Object title) {
    return 'Título: $title';
  }

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get phraseLabel => 'Frase llamativa (editable)';

  @override
  String get priceLabel => 'Precio (edita si es diferente)';

  @override
  String priceEditedWarning(Object price) {
    return '⚠️ Precio editado (original: $price)';
  }

  @override
  String get couponFieldLabel => '¿Tiene cupón? (déjalo en blanco si no)';

  @override
  String get couponFieldHint => 'Ej: FREESHIP';

  @override
  String get postResultLabel => 'Resultado:';

  @override
  String get postBothButton => '📤 Publicar en las 2 redes';

  @override
  String get postTelegramButton => '📤 Publicar en Telegram';

  @override
  String get postTwitterButton => '📤 Publicar en X';

  @override
  String get postPostingButton => '📤 Publicando...';

  @override
  String get messageFieldLabel => 'Mensaje';

  @override
  String get messageFieldHint => 'Escribe tu mensaje aquí...';

  @override
  String get sendBothButton => '📤 Enviar a las 2 redes';

  @override
  String get sendTelegramButton => '📤 Enviar a Telegram';

  @override
  String get sendTwitterButton => '📤 Enviar a X';

  @override
  String get sendPostingButton => '📤 Enviando...';

  @override
  String get validationProductUrlRequired => '¡Ingresa la URL del producto!';

  @override
  String get validationScrapeFirst => '¡Analiza el producto antes de publicar!';

  @override
  String get validationSelectPlatform => '¡Selecciona al menos una plataforma para enviar!';

  @override
  String get validationMessageRequired => '¡Escribe un mensaje!';

  @override
  String get genericError => 'Algo salió mal. Inténtalo de nuevo.';
}
