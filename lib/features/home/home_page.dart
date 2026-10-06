import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/program.dart';
import '../../data/repositories/local_repository.dart';
import '../program/program_detail_page.dart';
import '../recovery_test/recovery_test_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = LocalRepository.programs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeHeader(),

              const SizedBox(height: 14),

              const _HeroSection(),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Text(
                  '오늘, 어떤 여정을 만나볼까요?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _RecoveryTestCard(),
              ),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '추천 프로그램',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '시각 · 촉각 · 후각으로 나에게 맞는 회복을 만나보세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: programs.length,
                  separatorBuilder: (_, _) =>
                  const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final program = programs[index];

                    return _ProgramMiniCard(
                      program: program,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'THE FIRST WITNESS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),
          ),
          Icon(
            Icons.notifications_none,
            color: AppColors.burgundy,
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightBlue,
            AppColors.darkBrown,
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.forest_outlined,
              size: 40,
              color: AppColors.white,
            ),
            SizedBox(height: 10),
            Text(
              '정원 속 숨겨진 회복을\n직접 발견해보세요.',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryTestCard extends StatelessWidget {
  const _RecoveryTestCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나의 회복 유형 알아보기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '3가지 감각으로 찾는 나만의 회복',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecoveryTestPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.burgundy,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramMiniCard extends StatelessWidget {
  final Program program;

  const _ProgramMiniCard({
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProgramDetailPage(
              program: program,
            ),
          ),
        );
      },
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.burgundy.withValues(
              alpha: 0.20,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.06,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgramMiniVisual(
              senseType: program.senseType,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  12,
                  14,
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.senseType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.burgundy,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      program.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '${program.location} · '
                          '${program.durationMinutes}분',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
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

class _ProgramMiniVisual extends StatelessWidget {
  final String senseType;

  const _ProgramMiniVisual({
    required this.senseType,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (senseType == '시각') {
      icon = Icons.visibility_outlined;
    } else if (senseType == '촉각') {
      icon = Icons.pan_tool_alt_outlined;
    } else {
      icon = Icons.air;
    }

    return Container(
      height: 115,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(19),
        ),
      ),
      child: Icon(
        icon,
        size: 44,
        color: AppColors.burgundy,
      ),
    );
  }
}