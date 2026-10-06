import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';
import '../exploration/exploration_page.dart';

class InvitationPage extends StatelessWidget {
  final String reservationId;

  const InvitationPage({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final reservation =
        repository.reservationById(reservationId);

        final program =
        repository.programById(reservation.programId);

        final session =
        repository.sessionById(reservation.sessionId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text(
              '디지털 초대장',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    34,
                    24,
                    30,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.burgundy,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'THE FIRST WITNESS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.burgundy,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        program.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${program.senseType} · ${program.location}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        session.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.burgundy,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.softYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              size: 72,
                              color: AppColors.burgundy,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'DEMO QR 영역',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        '${reservation.guestCount}명 예약',
                        style: const TextStyle(
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        reservation.checkedIn
                            ? '체크인 완료'
                            : '체크인 전',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: reservation.checkedIn
                              ? Colors.green
                              : AppColors.burgundy,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!reservation.checkedIn) {
                        repository.checkIn(
                          reservation.id,
                        );
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExplorationPage(
                            reservationId: reservation.id,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      reservation.checkedIn
                          ? '탐색 계속하기'
                          : 'DEMO 체크인',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}