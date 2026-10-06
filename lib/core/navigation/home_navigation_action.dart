import 'package:flutter/material.dart';

import '../../features/navigation/main_navigation_page.dart';
import '../theme/app_colors.dart';

class HomeNavigationBottomBar extends StatelessWidget {
  final String? warningTitle;
  final String? warningMessage;
  final bool darkStyle;

  const HomeNavigationBottomBar({
    super.key,
    this.warningTitle,
    this.warningMessage,
    this.darkStyle = false,
  });

  Future<void> _goHome(BuildContext context) async {
    final message = warningMessage;

    if (message != null) {
      final shouldLeave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              warningTitle ?? '홈으로 이동할까요?',
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('계속 진행'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.burgundy,
                ),
                child: const Text('홈으로 이동'),
              ),
            ],
          );
        },
      );

      if (shouldLeave != true || !context.mounted) {
        return;
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavigationPage(
          initialIndex: 0,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = darkStyle
        ? const Color(0xFF241C17)
        : AppColors.background;

    final borderColor = darkStyle
        ? AppColors.softYellow
        : AppColors.burgundy;

    final foregroundColor = darkStyle
        ? AppColors.softYellow
        : AppColors.burgundy;

    return SafeArea(
      top: false,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          12,
        ),
        child: Center(
          child: SizedBox(
            width: 190,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                _goHome(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: BorderSide(
                  color: borderColor,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(
                Icons.home_outlined,
                size: 21,
              ),
              label: const Text(
                '홈으로',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
