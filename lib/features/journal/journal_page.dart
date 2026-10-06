import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';
import 'visit_card_page.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, _) {
            final entries =
                repository.journalEntries;

            if (entries.isEmpty) {
              return const _EmptyJournal();
            }

            return ListView(
              padding:
              const EdgeInsets.all(20),
              children: [
                const Text(
                  '기록',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '발견하고 경험한 순간을 다시 만나보세요.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                ...entries.reversed.map(
                      (entry) {
                    final program =
                    repository.programById(
                      entry.programId,
                    );

                    final hasPhoto =
                        entry.photoPath !=
                            null &&
                            File(
                              entry
                                  .photoPath!,
                            ).existsSync();

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VisitCardPage(
                                    journalEntryId:
                                    entry.id,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.all(
                            18,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            AppColors.white,
                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                            border: Border.all(
                              color: AppColors
                                  .burgundy
                                  .withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (hasPhoto)
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    14,
                                  ),
                                  child:
                                  Image.file(
                                    File(
                                      entry
                                          .photoPath!,
                                    ),
                                    width: 72,
                                    height: 72,
                                    fit:
                                    BoxFit.cover,
                                  ),
                                )
                              else
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration:
                                  BoxDecoration(
                                    color: AppColors
                                        .softYellow,
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      14,
                                    ),
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .spa_outlined,
                                    color:
                                    AppColors
                                        .burgundy,
                                  ),
                                ),

                              const SizedBox(
                                width: 16,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      program.title,
                                      style:
                                      const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: AppColors
                                            .darkBrown,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      '${program.senseType} · '
                                          '${program.location}',
                                      style:
                                      const TextStyle(
                                        fontSize: 12,
                                        color:
                                        Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      entry
                                          .oneLineReview,
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                        color: AppColors
                                            .darkBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                color:
                                AppColors.burgundy,
                              ),
                            ],
                          ),
                        ),
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

class _EmptyJournal
    extends StatelessWidget {
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