class ValidationErrorCodes {
  static const productUrlRequired = 'productUrlRequired';
  static const scrapeFirst = 'scrapeFirst';
  static const selectPlatform = 'selectPlatform';
  static const messageRequired = 'messageRequired';
}

class ValidationException implements Exception {
  final String code;
  const ValidationException(this.code);
}
