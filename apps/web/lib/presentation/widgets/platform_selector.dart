import 'package:flutter/material.dart';
import 'package:multi_poster_web/l10n/app_localizations.dart';

class PlatformSelector extends StatelessWidget {
  final bool sendToTelegram;
  final bool sendToTwitter;
  final ValueChanged<bool> onTelegramChanged;
  final ValueChanged<bool> onTwitterChanged;

  const PlatformSelector({
    super.key,
    required this.sendToTelegram,
    required this.sendToTwitter,
    required this.onTelegramChanged,
    required this.onTwitterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.platformSelectorTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.platformTelegram),
                  value: sendToTelegram,
                  onChanged: (value) => onTelegramChanged(value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.platformTwitter),
                  value: sendToTwitter,
                  onChanged: (value) => onTwitterChanged(value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
          if (!sendToTelegram && !sendToTwitter)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.platformWarning,
                style: TextStyle(fontSize: 12, color: Colors.red.shade600),
              ),
            ),
        ],
      ),
    );
  }
}
