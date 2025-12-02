import '../../core/errors/validation_exception.dart';
import '../entities/scrape_result.dart';
import '../repositories/i_product_repository.dart';

class ScrapeProductUseCase {
  final IProductRepository repository;

  ScrapeProductUseCase(this.repository);

  Future<ScrapeResult> call(String url) async {
    if (url.trim().isEmpty) {
      throw const ValidationException(ValidationErrorCodes.productUrlRequired);
    }
    return repository.scrapeProduct(url.trim());
  }
}
