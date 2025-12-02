import '../../core/errors/validation_exception.dart';
import '../entities/post_result.dart';
import '../repositories/i_product_repository.dart';

class PostEverywhereUseCase {
  final IProductRepository repository;

  PostEverywhereUseCase(this.repository);

  Future<PostResult> call({
    String? text,
    String? productUrl,
    String? coupon,
    String? price,
    String? customPhrase,
    String? customEmoji,
    required bool sendToTelegram,
    required bool sendToTwitter,
  }) async {
    if (!sendToTelegram && !sendToTwitter) {
      throw const ValidationException(ValidationErrorCodes.selectPlatform);
    }

    if (text != null && text.trim().isEmpty) {
      throw const ValidationException(ValidationErrorCodes.messageRequired);
    }

    if (productUrl != null && productUrl.trim().isEmpty) {
      throw const ValidationException(ValidationErrorCodes.productUrlRequired);
    }

    return repository.postEverywhere(
      text: text?.trim(),
      productUrl: productUrl?.trim(),
      coupon: coupon?.trim().isEmpty == true ? null : coupon?.trim(),
      price: price?.trim().isEmpty == true ? null : price?.trim(),
      customPhrase:
          customPhrase?.trim().isEmpty == true ? null : customPhrase?.trim(),
      customEmoji:
          customEmoji?.trim().isEmpty == true ? null : customEmoji?.trim(),
      sendToTelegram: sendToTelegram,
      sendToTwitter: sendToTwitter,
    );
  }
}
