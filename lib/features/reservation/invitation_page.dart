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
          ),
          bottomNavigationBar:
              const HomeNavigationBottomBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              30,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: AppColors.burgundy,
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          26,
                          24,
                          24,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'THE FIRST WITNESS',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.bold,
                                color: AppColors.softYellow,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              program.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${program.senseType} · '
                              '${program.location}',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          22,
                          24,
                          22,
                          26,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _TicketInfo(
                                    icon:
                                        Icons.schedule_outlined,
                                    label: '회차',
                                    value: session.label,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TicketInfo(
                                    icon: Icons.people_outline,
                                    label: '인원',
                                    value:
                                        '${reservation.guestCount}명',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.softYellow,
                                borderRadius:
                                    BorderRadius.circular(22),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.qr_code_2,
                                    size: 78,
                                    color: AppColors.burgundy,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'DEMO 체크인 QR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    '실제 운영용 QR 데이터는 추후 연결',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  reservation.checkedIn
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 20,
                                  color: reservation.checkedIn
                                      ? Colors.green
                                      : AppColors.burgundy,
                                ),
                                const SizedBox(width: 8),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  '초대장은 호텔 키 카드 경험에서 착안한 DEMO 화면입니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
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
                    icon: Icon(
                      reservation.checkedIn
                          ? Icons.explore_outlined
                          : Icons.login,
                    ),
                    label: Text(
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

class _TicketInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TicketInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 23,
            color: AppColors.burgundy,
          ),
          const SizedBox(height: 8),
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
            textAlign: TextAlign.center,
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
