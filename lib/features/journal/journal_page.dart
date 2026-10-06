import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/local_repository.dart';
import 'visit_card_page.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, _) {
            final entries = repository.journalEntries;

            if (entries.isEmpty) {
              return const _EmptyJournal();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                32,
              ),
              children: [
                const Text(
                  '기록',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '발견하고 경험한 순간을 다시 만나보세요.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 22),
                _JournalSummary(
                  count: entries.length,
                ),
                const SizedBox(height: 24),
                ...entries.reversed.map(
                  (entry) {
                    return _JournalCard(
                      entry: entry,
                      dateLabel: _formatDate(
                        entry.createdAt,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JournalSummary extends StatelessWidget {
  final int count;

  const _JournalSummary({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories_outlined,
              color: AppColors.burgundy,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  '나의 회복 기록',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '지금까지 $count개의 체험을 기록했습니다.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final String dateLabel;

  const _JournalCard({
    required this.entry,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;
    final program =
        repository.programById(entry.programId);

    final hasPhoto = entry.photoPath != null &&
        File(entry.photoPath!).existsSync();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VisitCardPage(
                  journalEntryId: entry.id,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.burgundy.withValues(
                  alpha: 0.13,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                if (hasPhoto)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),
                    child: Image.file(
                      File(entry.photoPath!),
                      width: 86,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 86,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.softYellow,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.spa_outlined,
                          color: AppColors.burgundy,
                        ),
                        SizedBox(height: 6),
                        Text(
                          '사진 없음',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.burgundy,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              program.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppColors.darkBrown,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.burgundy,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${program.senseType} · '
                        '${program.location}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        '“${entry.oneLineReview}”',
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.4,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 60,
              color: AppColors.burgundy,
            ),
            SizedBox(height: 18),
            Text(
              '아직 기록이 없습니다.',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '프로그램 체험을 완료하면\n'
              '여기에 기록을 남길 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
