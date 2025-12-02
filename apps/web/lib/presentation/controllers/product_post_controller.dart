import 'package:flutter/material.dart';
import '../../core/errors/validation_exception.dart';
import '../../domain/entities/post_result.dart';
import '../../domain/entities/scrape_result.dart';
import '../../domain/usecases/post_everywhere_usecase.dart';
import '../../domain/usecases/scrape_product_usecase.dart';

class ProductPostController extends ChangeNotifier {
  final ScrapeProductUseCase scrapeProductUseCase;
  final PostEverywhereUseCase postEverywhereUseCase;

  final TextEditingController urlController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phraseController = TextEditingController();
  final TextEditingController emojiController = TextEditingController();

  bool _scraping = false;
  bool _posting = false;
  bool _showCouponInput = false;
  ScrapeResult? _scrapeResult;
  PostResult? _postResult;
  String? _originalPrice;
  String? _generatedPhrase;
  String? _generatedEmoji;

  ProductPostController({
    required this.scrapeProductUseCase,
    required this.postEverywhereUseCase,
  }) {
    urlController.addListener(() => notifyListeners());
  }

  bool get scraping => _scraping;
  bool get posting => _posting;
  bool get showCouponInput => _showCouponInput;
  ScrapeResult? get scrapeResult => _scrapeResult;
  PostResult? get postResult => _postResult;
  String? get originalPrice => _originalPrice;
  String? get generatedPhrase => _generatedPhrase;
  String? get generatedEmoji => _generatedEmoji;

  bool get canScrape => !_scraping && urlController.text.trim().isNotEmpty;
  bool get canPost => !_posting && _scrapeResult != null;

  Future<void> scrapeProduct() async {
    if (urlController.text.trim().isEmpty) {
      throw const ValidationException(ValidationErrorCodes.productUrlRequired);
    }

    _scraping = true;
    _scrapeResult = null;
    _showCouponInput = false;
    _postResult = null;
    notifyListeners();

    try {
      final result = await scrapeProductUseCase(urlController.text.trim());
      _scrapeResult = result;
      _originalPrice = result.product.price;
      priceController.text = _originalPrice ?? '';
      _generatedPhrase = result.generatedPhrase;
      _generatedEmoji = result.generatedEmoji;
      phraseController.text = _generatedPhrase ?? '';
      emojiController.text = _generatedEmoji ?? '🔥';
      _showCouponInput = true;
    } finally {
      _scraping = false;
      notifyListeners();
    }
  }

  Future<void> postProduct({
    required bool sendToTelegram,
    required bool sendToTwitter,
  }) async {
    if (_scrapeResult == null) {
      throw const ValidationException(ValidationErrorCodes.scrapeFirst);
    }

    if (!sendToTelegram && !sendToTwitter) {
      throw const ValidationException(ValidationErrorCodes.selectPlatform);
    }

    _posting = true;
    _postResult = null;
    notifyListeners();

    try {
      final finalPrice = priceController.text.trim().isNotEmpty
          ? priceController.text.trim()
          : _originalPrice;

      final result = await postEverywhereUseCase(
        productUrl: urlController.text.trim(),
        coupon: couponController.text.trim().isNotEmpty
            ? couponController.text.trim()
            : null,
        price: finalPrice,
        customPhrase: phraseController.text.trim().isNotEmpty
            ? phraseController.text.trim()
            : null,
        customEmoji: emojiController.text.trim().isNotEmpty
            ? emojiController.text.trim()
            : null,
        sendToTelegram: sendToTelegram,
        sendToTwitter: sendToTwitter,
      );

      _postResult = result;
    } on ValidationException {
      rethrow;
    } catch (e) {
      _postResult = PostResult(
        twitter: {'ok': false, 'error': e.toString()},
        telegram: {'ok': false, 'error': e.toString()},
      );
    } finally {
      _posting = false;
      notifyListeners();
    }
  }

  void clearData() {
    urlController.clear();
    couponController.clear();
    priceController.clear();
    phraseController.clear();
    emojiController.clear();
    _scrapeResult = null;
    _showCouponInput = false;
    _postResult = null;
    _originalPrice = null;
    _generatedPhrase = null;
    _generatedEmoji = null;
    notifyListeners();
  }

  @override
  void dispose() {
    urlController.dispose();
    couponController.dispose();
    priceController.dispose();
    phraseController.dispose();
    emojiController.dispose();
    super.dispose();
  }
}
