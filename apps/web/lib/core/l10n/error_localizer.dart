import 'package:multi_poster_web/l10n/app_localizations.dart';

import '../errors/validation_exception.dart';

String mapValidationError(
  AppLocalizations l10n,
  ValidationException error,
) {
  switch (error.code) {
    case ValidationErrorCodes.productUrlRequired:
      return l10n.validationProductUrlRequired;
    case ValidationErrorCodes.scrapeFirst:
      return l10n.validationScrapeFirst;
    case ValidationErrorCodes.selectPlatform:
      return l10n.validationSelectPlatform;
    case ValidationErrorCodes.messageRequired:
      return l10n.validationMessageRequired;
    default:
      return l10n.genericError;
  }
}
