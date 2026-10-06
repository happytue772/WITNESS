import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/program_image.dart';
import '../../data/models/program.dart';
import '../../data/repositories/local_repository.dart';
import 'program_detail_page.dart';

class ProgramListPage extends StatelessWidget {
  const ProgramListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = LocalRepository.programs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          '프로그램',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: programs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          return _ProgramCard(
            program: programs[index],
          );
        },
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;

  const _ProgramCard({
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.burgundy.withValues(
                alpha: 0.18,
              ),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  18,
                ),
                color: AppColors.burgundy,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.roomLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.softYellow,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ProgramImage(
                programId: program.id,
                senseType: program.senseType,
                height: 170,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('핵심 연출'),
                    const SizedBox(height: 7),
                    Text(
                      program.keyDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionLabel('회복 포인트'),
                    const SizedBox(height: 7),
                    Text(
                      program.recoveryPoint,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoItem(
                            label: '장소',
                            value: program.location,
                          ),
                        ),
                        Expanded(
                          child: _InfoItem(
                            label: '소요',
                            value: '${program.durationMinutes}분',
                          ),
                        ),
                        Expanded(
                          child: _InfoItem(
                            label: '정원',
                            value: '${program.capacity}명',
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.burgundy,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
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
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}
