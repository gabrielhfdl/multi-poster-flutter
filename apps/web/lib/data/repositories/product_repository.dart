import '../../domain/entities/scrape_result.dart';
import '../../domain/entities/post_result.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/api_datasource.dart';

class ProductRepository implements IProductRepository {
  final IApiDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<ScrapeResult> scrapeProduct(String url) async {
    final response = await dataSource.scrapeProduct(url);

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Erro ao fazer scraping');
    }

    return ScrapeResult.fromJson(response);
  }

  @override
  Future<PostResult> postEverywhere({
    String? text,
    String? productUrl,
    String? coupon,
    String? price,
    String? customPhrase,
    String? customEmoji,
    required bool sendToTelegram,
    required bool sendToTwitter,
  }) async {
    final body = <String, dynamic>{
      'platforms': {'telegram': sendToTelegram, 'twitter': sendToTwitter},
    };

    if (text != null) {
      body['text'] = text;
    }

    if (productUrl != null) {
      body['productUrl'] = productUrl;
      if (coupon != null) {
        body['coupon'] = coupon;
      }
      if (price != null) {
        body['price'] = price;
      }
      if (customPhrase != null) {
        body['customPhrase'] = customPhrase;
      }
      if (customEmoji != null) {
        body['customEmoji'] = customEmoji;
      }
    }

    final response = await dataSource.postEverywhere(body);
    return PostResult.fromJson(response);
  }
}
