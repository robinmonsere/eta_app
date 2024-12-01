import 'package:eta_app/src/core/routing/router.dart';
import 'package:eta_app/src/ui/theme/eta_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const EtaApp());
}

class EtaApp extends StatelessWidget {
  const EtaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'eta',
      theme: etaTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
