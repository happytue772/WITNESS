import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/main_navigation_page.dart';

class FirstWitnessApp extends StatelessWidget {
  const FirstWitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'THE FIRST WITNESS',
      theme: AppTheme.lightTheme,
      home: const MainNavigationPage(),
    );
  }
}