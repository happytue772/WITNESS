import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/program.dart';
import '../../data/repositories/local_repository.dart';
import '../program/program_detail_page.dart';
import '../program/program_list_page.dart';

class RecoveryResultPage extends StatelessWidget {
  final String senseType;

  const RecoveryResultPage({
    super.key,
    required this.senseType,
  });

  Program _findRecommendedProgram() {
    return LocalRepository.programs.firstWhere(
          (program) => program.senseType == senseType,
    );
  }

  String _getResultDescription() {
    switch (senseType) {
      case '시각':
        return '천천히 바라보고 한 지점에 집중하는 시간이 지금의 회복에 어울립니다.';
      case '촉각':
        return '몸과 자연의 접촉에 집중하는 시간이 지금의 회복에 어울립니다.';
      case '후각':
        return '향과 공기의 변화를 느끼며 긴장을 이완하는 시간이 지금의 회복에 어울립니다.';
      default:
        return '';
    }
  }

  IconData _getResultIcon() {
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

  @override
  Widget build(BuildContext context) {
    final recommendedProgram = _findRecommendedProgram();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          '테스트 결과',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          HomeNavigationAction(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.softYellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getResultIcon(),
                size: 52,
                color: AppColors.burgundy,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '당신의 회복 유형은',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '$senseType형 입니다.',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              _getResultDescription(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                '추천 프로그램',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ),

            const SizedBox(height: 14),

            _RecommendedProgramCard(
              program: recommendedProgram,
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramDetailPage(
                        program: recommendedProgram,
                      ),
                    ),
                  );
                },
                child: const Text(
                  '추천 프로그램 자세히 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProgramListPage(),
                  ),
                );
              },
              child: const Text(
                '다른 프로그램도 둘러보기',
                style: TextStyle(
                  color: AppColors.burgundy,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '추천 결과와 관계없이 다른 프로그램도 자유롭게 선택할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedProgramCard extends StatelessWidget {
  final Program program;

  const _RecommendedProgramCard({
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.burgundy.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            program.roomLabel,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.burgundy,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            program.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '${program.location} · '
                '${program.durationMinutes}분 · '
                '${program.capacity}명',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}