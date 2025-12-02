import 'product.dart';

class ScrapeResult {
  final Product product;
  final String generatedPhrase;
  final String generatedEmoji;

  ScrapeResult({
    required this.product,
    required this.generatedPhrase,
    required this.generatedEmoji,
  });

  factory ScrapeResult.fromJson(Map<String, dynamic> json) {
    return ScrapeResult(
      product: Product.fromJson(json['data'] ?? {}),
      generatedPhrase: json['generatedPhrase'] ?? '',
      generatedEmoji: json['generatedEmoji'] ?? '🔥',
    );
  }
}
