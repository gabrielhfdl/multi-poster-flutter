import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_poster_web/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/errors/validation_exception.dart';
import '../../core/l10n/error_localizer.dart';
import '../controllers/product_post_controller.dart';

class ProductPostWidget extends StatelessWidget {
  final bool sendToTelegram;
  final bool sendToTwitter;

  const ProductPostWidget({
    super.key,
    required this.sendToTelegram,
    required this.sendToTwitter,
  });

  Future<void> _handleScrape(BuildContext context) async {
    try {
      await context.read<ProductPostController>().scrapeProduct();
    } on ValidationException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showError(context, mapValidationError(l10n, e));
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> _handlePost(BuildContext context) async {
    try {
      await context.read<ProductPostController>().postProduct(
            sendToTelegram: sendToTelegram,
            sendToTwitter: sendToTwitter,
          );
    } on ValidationException catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showError(context, mapValidationError(l10n, e));
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductPostController>();
    final product = controller.scrapeResult?.product;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.urlController,
          decoration: InputDecoration(
            labelText: l10n.productLinkLabel,
            hintText: l10n.productLinkHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabled: !controller.scraping && !controller.posting,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.supportedStoresDescription,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        if (!controller.showCouponInput)
          ElevatedButton.icon(
            onPressed:
                controller.canScrape ? () => _handleScrape(context) : null,
            icon: const Icon(Icons.search),
            label: Text(
              controller.scraping
                  ? l10n.analyzingProductButton
                  : l10n.analyzeProductButton,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (product != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.productFoundTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.productTitleWithValue(product.title),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: controller.emojiController,
                        decoration: InputDecoration(
                          labelText: l10n.emojiLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabled: !controller.posting,
                        ),
                        maxLength: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller.phraseController,
                        decoration: InputDecoration(
                          labelText: l10n.phraseLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabled: !controller.posting,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.priceController,
                  decoration: InputDecoration(
                    labelText: l10n.priceLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabled: !controller.posting,
                  ),
                ),
                if (controller.priceController.text !=
                        controller.originalPrice &&
                    controller.originalPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.priceEditedWarning(controller.originalPrice!),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ),
                if (product.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  Image.network(
                    product.imageUrl!,
                    height: 128,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
        if (controller.showCouponInput) ...[
          const SizedBox(height: 16),
          TextField(
            controller: controller.couponController,
            decoration: InputDecoration(
              labelText: l10n.couponFieldLabel,
              hintText: l10n.couponFieldHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabled: !controller.posting,
            ),
          ),
        ],
        if (controller.showCouponInput) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      controller.canPost && (sendToTelegram || sendToTwitter)
                          ? () => _handlePost(context)
                          : null,
                  icon: const Icon(Icons.send),
                  label: Text(_postButtonLabel(l10n, controller)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.posting ? null : controller.clearData,
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
        if (controller.postResult != null) ...[
          const SizedBox(height: 24),
          Text(
            l10n.postResultLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: SelectableText(
                JsonEncoder.withIndent('  ')
                    .convert(controller.postResult!.toJson()),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _postButtonLabel(
    AppLocalizations l10n,
    ProductPostController controller,
  ) {
    if (controller.posting) {
      return l10n.postPostingButton;
    }
    if (sendToTelegram && sendToTwitter) {
      return l10n.postBothButton;
    } else if (sendToTelegram) {
      return l10n.postTelegramButton;
    } else {
      return l10n.postTwitterButton;
    }
  }
}
