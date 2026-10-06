import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/reservation.dart';
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

            final currentReservations = <Reservation>[];
            final completedReservations = <Reservation>[];

            for (final reservation in reservations.reversed) {
              final progress =
                  repository.progressForReservation(reservation.id);

              if (progress.experienceCompleted) {
                completedReservations.add(reservation);
              } else {
                currentReservations.add(reservation);
              }
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
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
                  '예약부터 탐색과 체험 완료까지 한곳에서 확인해보세요.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 26),

                if (currentReservations.isNotEmpty) ...[
                  const _SectionHeader(
                    title: '진행 중인 예약',
                    icon: Icons.confirmation_number_outlined,
                  ),
                  const SizedBox(height: 12),
                  ...currentReservations.map(
                    (reservation) => _ReservationCard(
                      reservation: reservation,
                    ),
                  ),
                ],

                if (completedReservations.isNotEmpty) ...[
                  if (currentReservations.isNotEmpty)
                    const SizedBox(height: 20),
                  const _SectionHeader(
                    title: '지난 체험',
                    icon: Icons.history,
                  ),
                  const SizedBox(height: 12),
                  ...completedReservations.map(
                    (reservation) => _ReservationCard(
                      reservation: reservation,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.burgundy,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const _ReservationCard({
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    final program =
        repository.programById(reservation.programId);

    final session =
        repository.sessionById(reservation.sessionId);

    final progress =
        repository.progressForReservation(reservation.id);

    final String status;
    final IconData statusIcon;

    if (progress.experienceCompleted) {
      status = '체험 완료';
      statusIcon = Icons.check_circle;
    } else if (progress.explorationCompleted) {
      status = '탐색 완료 · 체험 대기';
      statusIcon = Icons.flag_outlined;
    } else if (reservation.checkedIn) {
      status = '체크인 완료 · 탐색 중';
      statusIcon = Icons.explore_outlined;
    } else {
      status = '예약 완료 · 체크인 전';
      statusIcon = Icons.schedule;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InvitationPage(
                  reservationId: reservation.id,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.burgundy.withValues(
                  alpha: 0.15,
                ),
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softYellow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        program.senseType,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.burgundy,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: AppColors.burgundy,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${program.location} · ${session.label} · '
                  '${reservation.guestCount}명',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 19,
                      color: AppColors.burgundy,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.burgundy,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
