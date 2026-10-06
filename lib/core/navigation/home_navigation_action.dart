import 'package:flutter/material.dart';

import '../../features/navigation/main_navigation_page.dart';
import '../theme/app_colors.dart';

class HomeNavigationAction extends StatelessWidget {
  final String? warningTitle;
  final String? warningMessage;

  const HomeNavigationAction({
    super.key,
    this.warningTitle,
    this.warningMessage,
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
    return IconButton(
      tooltip: '홈으로 이동',
      onPressed: () {
        _goHome(context);
      },
      icon: const Icon(
        Icons.home_outlined,
        color: AppColors.burgundy,
      ),
    );
  }
}
