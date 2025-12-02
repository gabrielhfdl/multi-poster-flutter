import 'package:flutter/material.dart';
import 'package:multi_poster_web/core/di/dependency_injection.dart';
import 'package:multi_poster_web/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'presentation/controllers/product_post_controller.dart';
import 'presentation/controllers/simple_post_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductPostController>(
          create: (_) => DependencyInjection.createProductPostController(),
        ),
        ChangeNotifierProvider<SimplePostController>(
          create: (_) => DependencyInjection.createSimplePostController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AppScreen(),
    );
  }
}
