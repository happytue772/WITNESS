import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/local_repository.dart';
import 'visit_card_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() =>
      _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _selectedTab = 0;

  String _formatDate(DateTime date) {
    final month =
        date.month.toString().padLeft(2, '0');
    final day =
        date.day.toString().padLeft(2, '0');

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
            final entries =
                repository.journalEntries.reversed
                    .toList();

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    14,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '기록',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: _JournalTabs(
                    selectedIndex: _selectedTab,
                    onChanged: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: entries.isEmpty
                      ? const _EmptyJournal()
                      : _selectedTab == 0
                          ? _JourneyList(
                              entries: entries,
                              formatDate:
                                  _formatDate,
                            )
                          : _VisitCardList(
                              entries: entries,
                              formatDate:
                                  _formatDate,
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JournalTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _JournalTabs({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.softYellow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _JournalTabButton(
              label: '나의 여정',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _JournalTabButton(
              label: '방문 카드',
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _JournalTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.burgundy
          : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected
                  ? AppColors.white
                  : AppColors.darkBrown,
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyList extends StatelessWidget {
  final List<JournalEntry> entries;
  final String Function(DateTime) formatDate;

  const _JourneyList({
    required this.entries,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        32,
      ),
      itemCount: entries.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];

        return _JourneyCard(
          entry: entry,
          dateLabel: formatDate(
            entry.createdAt,
          ),
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final JournalEntry entry;
  final String dateLabel;

  const _JourneyCard({
    required this.entry,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;
    final program =
        repository.programById(entry.programId);

    final hasPhoto =
        entry.photoPath != null &&
        File(entry.photoPath!).existsSync();

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.burgundy.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _EntryThumbnail(
                entry: entry,
                hasPhoto: hasPhoto,
                size: 72,
              ),
              const SizedBox(width: 13),
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
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.darkBrown,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.burgundy,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      entry.oneLineReview,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.darkBrown,
                      ),
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

class _VisitCardList extends StatelessWidget {
  final List<JournalEntry> entries;
  final String Function(DateTime) formatDate;

  const _VisitCardList({
    required this.entries,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        32,
      ),
      itemCount: entries.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final entry = entries[index];

        return _VisitCardPreview(
          entry: entry,
          dateLabel: formatDate(
            entry.createdAt,
          ),
        );
      },
    );
  }
}

class _VisitCardPreview extends StatelessWidget {
  final JournalEntry entry;
  final String dateLabel;

  const _VisitCardPreview({
    required this.entry,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;
    final program =
        repository.programById(entry.programId);

    final hasPhoto =
        entry.photoPath != null &&
        File(entry.photoPath!).existsSync();

    return Material(
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.burgundy.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 94,
                height: 110,
                child: hasPhoto
                    ? Image.file(
                        File(entry.photoPath!),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppColors.burgundy,
                        child: const Icon(
                          Icons
                              .confirmation_number_outlined,
                          color: AppColors.softYellow,
                          size: 36,
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VISIT CARD',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing: 1,
                          color:
                              AppColors.burgundy,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        program.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              AppColors.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text(
                            '방문 카드 보기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.burgundy,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color:
                                AppColors.burgundy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryThumbnail extends StatelessWidget {
  final JournalEntry entry;
  final bool hasPhoto;
  final double size;

  const _EntryThumbnail({
    required this.entry,
    required this.hasPhoto,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (hasPhoto) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          File(entry.photoPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.softYellow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.spa_outlined,
        color: AppColors.burgundy,
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
          mainAxisAlignment:
              MainAxisAlignment.center,
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
              '나의 여정과 방문 카드를 확인할 수 있습니다.',
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
