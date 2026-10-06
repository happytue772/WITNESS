import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/program.dart';
import '../reservation/reservation_page.dart';

class ProgramDetailPage extends StatelessWidget {
  final Program program;

  const ProgramDetailPage({
    super.key,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          program.title,
          style: const TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
              color: AppColors.burgundy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.roomLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.softYellow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),

            _ProgramVisual(program: program),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('핵심 연출'),
                  const SizedBox(height: 8),
                  Text(
                    program.keyDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle('회복 포인트'),
                  const SizedBox(height: 8),
                  Text(
                    program.recoveryPoint,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Divider(color: AppColors.burgundy),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(
                        label: '장소',
                        value: program.location,
                      ),
                      _InfoItem(
                        label: '소요',
                        value: '${program.durationMinutes}분',
                      ),
                      _InfoItem(
                        label: '정원',
                        value: '${program.capacity}명',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservationPage(
                              program: program,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramVisual extends StatelessWidget {
  final Program program;

  const _ProgramVisual({
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (program.senseType == '시각') {
      icon = Icons.visibility_outlined;
    } else if (program.senseType == '촉각') {
      icon = Icons.pan_tool_alt_outlined;
    } else {
      icon = Icons.air;
    }

    return Container(
      width: double.infinity,
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
            icon,
            size: 64,
            color: AppColors.burgundy,
          ),
          const SizedBox(height: 12),
          Text(
            '${program.senseType} 웰니스 프로그램',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.burgundy,
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}