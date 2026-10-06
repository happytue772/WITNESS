import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/program_image.dart';
import '../../data/models/reservation.dart';
import '../../data/repositories/local_repository.dart';
import 'invitation_page.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() =>
      _MyReservationsPageState();
}

class _MyReservationsPageState
    extends State<MyReservationsPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, _) {
            final upcoming = <Reservation>[];
            final past = <Reservation>[];

            for (final reservation
                in repository.reservations.reversed) {
              final progress =
                  repository.progressForReservation(
                reservation.id,
              );

              if (progress.experienceCompleted) {
                past.add(reservation);
              } else {
                upcoming.add(reservation);
              }
            }

            final visibleReservations =
                _selectedTab == 0 ? upcoming : past;

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
                      '내 예약',
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
                  child: _ReservationTabs(
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
                  child: visibleReservations.isEmpty
                      ? _ReservationEmptyState(
                          isUpcoming:
                              _selectedTab == 0,
                        )
                      : ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            32,
                          ),
                          itemCount:
                              visibleReservations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 14),
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return _ReservationCard(
                              reservation:
                                  visibleReservations[index],
                              isPast:
                                  _selectedTab == 1,
                            );
                          },
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

class _ReservationTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _ReservationTabs({
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
            child: _ReservationTabButton(
              label: '예정된 예약',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _ReservationTabButton(
              label: '지난 예약',
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReservationTabButton({
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

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final bool isPast;

  const _ReservationCard({
    required this.reservation,
    required this.isPast,
  });

  Future<void> _confirmDeleteReservation(
    BuildContext context,
  ) async {
    final repository = LocalRepository.instance;
    final program = repository.programById(
      reservation.programId,
    );

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('예약을 삭제할까요?'),
          content: Text(
            '${program.title} 예약을 삭제합니다.\n\n'
            '이 예약의 탐색 진행 상태와 연결된 후기 기록도 함께 삭제됩니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.burgundy,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true ||
        !context.mounted) {
      return;
    }

    try {
      final deleted =
          await repository.deleteReservation(
        reservation.id,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            deleted
                ? '예약이 삭제되었습니다.'
                : '삭제할 예약을 찾지 못했습니다.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '예약을 삭제하지 못했습니다: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    final program = repository.programById(
      reservation.programId,
    );

    final session = repository.sessionById(
      reservation.sessionId,
    );

    final progress =
        repository.progressForReservation(
      reservation.id,
    );

    final String status;

    if (progress.experienceCompleted) {
      status = '체험 완료';
    } else if (progress.explorationCompleted) {
      status = '탐색 완료 · 체험 대기';
    } else if (reservation.checkedIn) {
      status = '체크인 완료 · 탐색 중';
    } else {
      status = '예약 완료 · 체크인 전';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.burgundy.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              10,
              12,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 76,
                  height: 86,
                  child: ProgramImage(
                    programId: program.id,
                    senseType: program.senseType,
                    height: 86,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 14),
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
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppColors.darkBrown,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: '예약 삭제',
                            visualDensity:
                                VisualDensity.compact,
                            onPressed: () {
                              _confirmDeleteReservation(
                                context,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color:
                                  AppColors.burgundy,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${session.label} · '
                        '${reservation.guestCount}명',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            isPast
                                ? Icons.check_circle
                                : Icons.schedule,
                            size: 16,
                            color:
                                AppColors.burgundy,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppColors.burgundy,
                              ),
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
          const Divider(height: 1),
          InkWell(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Icon(
                    isPast
                        ? Icons.receipt_long_outlined
                        : Icons
                            .confirmation_number_outlined,
                    size: 19,
                    color: AppColors.burgundy,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      isPast
                          ? '예약 정보 다시 보기'
                          : '디지털 초대장 보기',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.burgundy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationEmptyState
    extends StatelessWidget {
  final bool isUpcoming;

  const _ReservationEmptyState({
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming
                  ? Icons
                      .confirmation_number_outlined
                  : Icons.history,
              size: 56,
              color: AppColors.burgundy,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming
                  ? '예정된 예약이 없습니다.'
                  : '지난 예약이 없습니다.',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? '홈에서 웰니스 프로그램을 예약해보세요.'
                  : '체험을 완료하면 이곳에 지난 예약이 표시됩니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
