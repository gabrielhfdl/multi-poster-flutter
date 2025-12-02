import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_poster_web/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/errors/validation_exception.dart';
import '../../core/l10n/error_localizer.dart';
import '../controllers/simple_post_controller.dart';

class SimplePostWidget extends StatelessWidget {
  final bool sendToTelegram;
  final bool sendToTwitter;

  const SimplePostWidget({
    super.key,
    required this.sendToTelegram,
    required this.sendToTwitter,
  });

  Future<void> _handlePost(BuildContext context) async {
    try {
      await context.read<SimplePostController>().postText(
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
    final controller = context.watch<SimplePostController>();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.textController,
          decoration: InputDecoration(
            labelText: l10n.messageFieldLabel,
            hintText: l10n.messageFieldHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabled: !controller.posting,
          ),
          maxLines: 6,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: controller.canPost && (sendToTelegram || sendToTwitter)
              ? () => _handlePost(context)
              : null,
          icon: const Icon(Icons.send),
          label: Text(_buttonLabel(l10n, controller)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
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
                const JsonEncoder.withIndent('  ')
                    .convert(controller.postResult!.toJson()),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _buttonLabel(
    AppLocalizations l10n,
    SimplePostController controller,
  ) {
    if (controller.posting) {
      return l10n.sendPostingButton;
    }
    if (sendToTelegram && sendToTwitter) {
      return l10n.sendBothButton;
    } else if (sendToTelegram) {
      return l10n.sendTelegramButton;
    } else {
      return l10n.sendTwitterButton;
    }
  }
}
