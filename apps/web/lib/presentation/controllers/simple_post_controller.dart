import 'package:flutter/material.dart';
import '../../core/errors/validation_exception.dart';
import '../../domain/entities/post_result.dart';
import '../../domain/usecases/post_everywhere_usecase.dart';

class SimplePostController extends ChangeNotifier {
  final PostEverywhereUseCase postEverywhereUseCase;

  final TextEditingController textController = TextEditingController();

  bool _posting = false;
  PostResult? _postResult;

  SimplePostController({
    required this.postEverywhereUseCase,
  }) {
    textController.addListener(() => notifyListeners());
  }

  bool get posting => _posting;
  PostResult? get postResult => _postResult;

  bool get canPost => !_posting && textController.text.trim().isNotEmpty;

  Future<void> postText({
    required bool sendToTelegram,
    required bool sendToTwitter,
  }) async {
    if (textController.text.trim().isEmpty) {
      throw const ValidationException(ValidationErrorCodes.messageRequired);
    }

    if (!sendToTelegram && !sendToTwitter) {
      throw const ValidationException(ValidationErrorCodes.selectPlatform);
    }

    _posting = true;
    _postResult = null;
    notifyListeners();

    try {
      final result = await postEverywhereUseCase(
        text: textController.text.trim(),
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
    textController.clear();
    _postResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
