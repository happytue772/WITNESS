import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';
import 'invitation_page.dart';

class PreparationPage extends StatelessWidget {
  final String reservationId;

  const PreparationPage({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;
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
        automaticallyImplyLeading: false,
        title: const Text(
          '예약 완료',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ),
      bottomNavigationBar:
          const HomeNavigationBottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.check_circle,
                  size: 72,
                  color: AppColors.burgundy,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '예약이 확정되었습니다.',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  '참여 전에 필요한 안내를 확인해주세요.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.burgundy
                        .withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: '프로그램',
                      value: program.title,
                    ),
                    _InfoRow(
                      label: '회차',
                      value: session.label,
                    ),
                    const _InfoRow(
                      label: '예약 인원',
                      value: '본인 1명',
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '프로그램 준비물',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.softYellow,
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: program.preparationItems.isEmpty
                    ? Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons
                                    .inventory_2_outlined,
                                color:
                                    AppColors.burgundy,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '준비물 세부 항목 확정 전',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        AppColors.darkBrown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            program.preparationNotice,
                            style: const TextStyle(
                              height: 1.55,
                              color:
                                  AppColors.darkBrown,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          for (final item
                              in program
                                  .preparationItems)
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 19,
                                    color: AppColors
                                        .burgundy,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style:
                                          const TextStyle(
                                        height: 1.5,
                                        color: AppColors
                                            .darkBrown,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.burgundy
                        .withValues(alpha: 0.12),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppColors.burgundy,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '이 예약은 본인 1인 전용입니다. '
                        '동반인을 추가할 수 없으며, 함께 참여하는 사람도 '
                        '각자 본인 인증 후 별도로 예약해야 합니다.',
                        style: TextStyle(
                          height: 1.55,
                          color: AppColors.darkBrown,
                        ),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InvitationPage(
                          reservationId:
                              reservation.id,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    '디지털 초대장 확인',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 86,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 13),
          const Divider(height: 1),
          const SizedBox(height: 13),
        ],
      ],
    );
  }
}
