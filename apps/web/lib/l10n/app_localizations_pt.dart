// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Multi-Poster';

  @override
  String get productModeLabel => '📦 Postar Produto';

  @override
  String get simpleModeLabel => '💬 Mensagem Simples';

  @override
  String get platformSelectorTitle => 'Onde postar?';

  @override
  String get platformTelegram => '📱 Telegram';

  @override
  String get platformTwitter => '🐦 X (Twitter)';

  @override
  String get platformWarning => '⚠️ Selecione pelo menos uma plataforma';

  @override
  String get productLinkLabel => 'Link do Produto';

  @override
  String get productLinkHint => 'https://www.mercadolivre.com.br/produto...';

  @override
  String get supportedStoresDescription => 'Suporta: Mercado Livre, Amazon e Shopee';

  @override
  String get analyzeProductButton => '🔍 Analisar Produto';

  @override
  String get analyzingProductButton => '🔍 Analisando produto...';

  @override
  String get productFoundTitle => '✅ Produto encontrado!';

  @override
  String productTitleWithValue(Object title) {
    return 'Título: $title';
  }

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get phraseLabel => 'Frase chamativa (pode editar)';

  @override
  String get priceLabel => 'Preço (pode editar se estiver diferente)';

  @override
  String priceEditedWarning(Object price) {
    return '⚠️ Preço editado (original: $price)';
  }

  @override
  String get couponFieldLabel => 'Tem cupom? (deixe em branco se não tiver)';

  @override
  String get couponFieldHint => 'Ex: LIBERACUPOM';

  @override
  String get postResultLabel => 'Resultado:';

  @override
  String get postBothButton => '📤 Postar nas 2 redes';

  @override
  String get postTelegramButton => '📤 Postar no Telegram';

  @override
  String get postTwitterButton => '📤 Postar no X';

  @override
  String get postPostingButton => '📤 Postando...';

  @override
  String get messageFieldLabel => 'Mensagem';

  @override
  String get messageFieldHint => 'Digite sua mensagem aqui...';

  @override
  String get sendBothButton => '📤 Enviar nas 2 redes';

  @override
  String get sendTelegramButton => '📤 Enviar no Telegram';

  @override
  String get sendTwitterButton => '📤 Enviar no X';

  @override
  String get sendPostingButton => '📤 Enviando...';

  @override
  String get validationProductUrlRequired => 'Por favor, digite a URL do produto!';

  @override
  String get validationScrapeFirst => 'Por favor, faça a análise do produto antes de postar!';

  @override
  String get validationSelectPlatform => 'Selecione pelo menos uma plataforma para enviar!';

  @override
  String get validationMessageRequired => 'Por favor, digite uma mensagem!';

  @override
  String get genericError => 'Algo deu errado. Tente novamente.';
}
