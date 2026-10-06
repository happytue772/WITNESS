import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/program_image.dart';
import '../../data/repositories/local_repository.dart';
import '../journal/journal_write_page.dart';

class ExperiencePage extends StatelessWidget {
  final String reservationId;

  const ExperiencePage({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final reservation =
        repository.reservationById(
          reservationId,
        );

        final program =
        repository.programById(
          reservation.programId,
        );

        final progress =
        repository.progressForReservation(
          reservation.id,
        );

        if (!progress.explorationCompleted) {
          return Scaffold(
            backgroundColor:
            AppColors.background,
            appBar: AppBar(
              backgroundColor:
              AppColors.background,
              title: const Text(
                '체험',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
            bottomNavigationBar: const HomeNavigationBottomBar(),
            body: const Center(
              child: Text(
                '탐색을 먼저 완료해주세요.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor:
            AppColors.background,
            title: const Text(
              '체험',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
          ),
          bottomNavigationBar: HomeNavigationBottomBar(
            warningTitle: progress.experienceCompleted
                ? null
                : '체험을 중단할까요?',
            warningMessage: progress.experienceCompleted
                ? null
                : '아직 체험 완료 처리가 되지 않았습니다. 홈으로 이동하면 현재 체험 화면을 벗어나며, 나중에 탐색 화면을 통해 다시 체험 단계로 돌아와 완료해야 합니다.',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                ProgramImage(
                  programId: program.id,
                  senseType: program.senseType,
                  height: 230,
                  borderRadius: BorderRadius.circular(24),
                ),

                const SizedBox(height: 28),

                const Text(
                  '마지막 장소에 도착했습니다.',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${program.senseType} · '
                      '${program.location}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  '핵심 연출',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  program.keyDescription,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  '회복 포인트',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  program.recoveryPoint,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 36),

                if (!progress.experienceCompleted)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        repository
                            .completeExperience(
                          reservation.id,
                        );
                      },
                      child: const Text(
                        '체험 완료하기',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                if (progress.experienceCompleted)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(
                          20,
                        ),
                        decoration: BoxDecoration(
                          color:
                          AppColors.softYellow,
                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 46,
                              color:
                              AppColors.burgundy,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '프로그램 체험을 완료했습니다.',
                              textAlign:
                              TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.bold,
                                color: AppColors
                                    .darkBrown,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '사진과 한 줄 후기로 오늘의 경험을 기록해보세요.',
                              textAlign:
                              TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    JournalWritePage(
                                      reservationId:
                                      reservation.id,
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit_note,
                          ),
                          label: const Text(
                            '후기 기록하기',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}