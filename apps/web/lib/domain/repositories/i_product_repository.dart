import '../entities/scrape_result.dart';
import '../entities/post_result.dart';

abstract class IProductRepository {
  Future<ScrapeResult> scrapeProduct(String url);
  Future<PostResult> postEverywhere({
    String? text,
    String? productUrl,
    String? coupon,
    String? price,
    String? customPhrase,
    String? customEmoji,
    required bool sendToTelegram,
    required bool sendToTwitter,
  });
}
