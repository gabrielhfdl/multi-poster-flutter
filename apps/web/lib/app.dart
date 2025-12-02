import 'package:flutter/material.dart';
import 'package:multi_poster_web/l10n/app_localizations.dart';

import 'presentation/widgets/platform_selector.dart';
import 'presentation/widgets/product_post_widget.dart';
import 'presentation/widgets/simple_post_widget.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedMode = 0;
  bool _sendToTelegram = true;
  bool _sendToTwitter = true;

  void _resetState() {
    setState(() {
      _sendToTelegram = true;
      _sendToTwitter = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ModeButton(
                          label: l10n.productModeLabel,
                          isSelected: _selectedMode == 0,
                          onTap: () {
                            setState(() {
                              _selectedMode = 0;
                            });
                            _resetState();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModeButton(
                          label: l10n.simpleModeLabel,
                          isSelected: _selectedMode == 1,
                          onTap: () {
                            setState(() {
                              _selectedMode = 1;
                            });
                            _resetState();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PlatformSelector(
                    sendToTelegram: _sendToTelegram,
                    sendToTwitter: _sendToTwitter,
                    onTelegramChanged: (value) {
                      setState(() {
                        _sendToTelegram = value;
                      });
                    },
                    onTwitterChanged: (value) {
                      setState(() {
                        _sendToTwitter = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_selectedMode == 0)
                    ProductPostWidget(
                      sendToTelegram: _sendToTelegram,
                      sendToTwitter: _sendToTwitter,
                    )
                  else
                    SimplePostWidget(
                      sendToTelegram: _sendToTelegram,
                      sendToTwitter: _sendToTwitter,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
