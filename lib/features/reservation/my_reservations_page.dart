import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';
import 'invitation_page.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, _) {
            final reservations = repository.reservations;

            if (reservations.isEmpty) {
              return const _EmptyReservationView();
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  '내 예약',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '예약한 웰니스 프로그램을 확인해보세요.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                ...reservations.reversed.map(
                      (reservation) {
                    final program =
                    repository.programById(
                      reservation.programId,
                    );

                    final session =
                    repository.sessionById(
                      reservation.sessionId,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InvitationPage(
                                reservationId:
                                reservation.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.burgundy
                                  .withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                program.senseType,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  AppColors.burgundy,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                program.title,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  AppColors.darkBrown,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                '${program.location} · '
                                    '${session.label} · '
                                    '${reservation.guestCount}명',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                reservation.checkedIn
                                    ? '체크인 완료'
                                    : '예약 완료',
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  reservation.checkedIn
                                      ? Colors.green
                                      : AppColors
                                      .burgundy,
                                ),
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

class _EmptyReservationView extends StatelessWidget {
  const _EmptyReservationView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 56,
              color: AppColors.burgundy,
            ),
            SizedBox(height: 16),
            Text(
              '아직 예약이 없습니다.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '홈에서 웰니스 프로그램을 선택해보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}