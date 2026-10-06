import 'package:flutter/material.dart';

import '../assets/app_assets.dart';
import '../theme/app_colors.dart';

class ProgramImage extends StatelessWidget {
  final String programId;
  final String senseType;
  final double height;
  final BorderRadius borderRadius;
  final bool showLabel;

  const ProgramImage({
    super.key,
    required this.programId,
    required this.senseType,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.showLabel = false,
  });

  IconData get _fallbackIcon {
    switch (senseType) {
      case '시각':
        return Icons.visibility_outlined;
      case '촉각':
        return Icons.pan_tool_alt_outlined;
      case '후각':
        return Icons.air;
      default:
        return Icons.spa_outlined;
    }
  }

  Widget _fallback() {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightBlue,
            AppColors.softYellow,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _fallbackIcon,
            size: 52,
            color: AppColors.burgundy,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '이미지 추후 적용',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 8),
            Text(
              '$senseType 웰니스 프로그램',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath =
        AppAssets.programImageById(programId);

    if (imagePath == null) {
      return _fallback();
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _fallback();
        },
      ),
    );
  }
}
