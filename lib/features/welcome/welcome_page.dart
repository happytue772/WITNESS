import 'package:flutter/material.dart';

import '../../core/assets/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../navigation/main_navigation_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  18,
                  22,
                  12,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppAssets.welcomeHero,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.softYellow,
                                  AppColors.lightBlue,
                                  AppColors.darkBrown,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.forest_outlined,
                                size: 92,
                                color: AppColors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.42),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  28,
                  18,
                  28,
                  28,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'THE FIRST\nWITNESS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.05,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.burgundy,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '아직 발견되지 않은 회복을\n가장 먼저 마주하다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MainNavigationPage(),
                            ),
                          );
                        },
                        child: const Text(
                          '나의 여정 시작하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
