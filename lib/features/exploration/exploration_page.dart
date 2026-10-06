import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/exploration_point.dart';
import '../../data/models/reservation.dart';
import '../../data/repositories/local_repository.dart';

import 'experience_page.dart';
import 'qr_gallery_test_page.dart';
import 'qr_scan_page.dart';

class ExplorationPage extends StatelessWidget {
  final String? reservationId;

  const ExplorationPage({
    super.key,
    this.reservationId,
  });

  // ==================================================
  // 현재 사용할 예약 찾기
  // ==================================================

  Reservation? _findReservation() {
    final repository = LocalRepository.instance;

    if (reservationId != null) {
      return repository.reservationById(
        reservationId!,
      );
    }

    return repository.latestCheckedInReservation;
  }

  @override
  Widget build(BuildContext context) {
    final repository = LocalRepository.instance;

    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final reservation = _findReservation();

        // ==============================================
        // 예약 없음
        // ==============================================

        if (reservation == null) {
          return const _NoReservationView();
        }

        // ==============================================
        // 체크인 전
        // ==============================================

        if (!reservation.checkedIn) {
          return const _NotCheckedInView();
        }

        // ==============================================
        // 데이터 조회
        // ==============================================

        final program = repository.programById(
          reservation.programId,
        );

        final progress =
        repository.progressForReservation(
          reservation.id,
        );

        final points =
            LocalRepository.demoExplorationPoints;

        final discoveredCount =
            progress.discoveredPointIds.length;

        final progressValue = points.isEmpty
            ? 0.0
            : discoveredCount / points.length;

        final nextPoint =
        repository.nextPointForReservation(
          reservation.id,
        );

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              '탐색',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // ======================================
                // 프로그램 정보
                // ======================================

                Text(
                  program.title,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${program.senseType} · '
                      '${program.location}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                // ======================================
                // 시크릿 맵
                // ======================================

                Container(
                  width: double.infinity,
                  height: 245,
                  decoration: BoxDecoration(
                    color: AppColors.softYellow,
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 72,
                        color: AppColors.burgundy,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '시크릿 맵',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Text(
                          '오브제와 단서를 따라 숨겨진 경험을 발견해보세요.',
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            height: 1.5,
                            color:
                            AppColors.darkBrown,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'GPS 실시간 위치 추적은 사용하지 않습니다.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppColors.background,
                        showDragHandle: true,
                        builder: (context) {
                          return SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                8,
                                24,
                                28,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '탐색 도움 · 복귀 안내',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const _HelpRow(
                                    icon: Icons.visibility_outlined,
                                    title: '현재 단서 다시 확인',
                                    description:
                                        '현재 활성화된 단서 카드와 오브제 정보를 확인한 뒤 주변을 천천히 살펴보세요.',
                                  ),
                                  const SizedBox(height: 14),
                                  const _HelpRow(
                                    icon: Icons.qr_code_scanner,
                                    title: 'QR 스캔',
                                    description:
                                        '현재 순서에 맞는 QR만 기록됩니다. 다음 단서는 이전 단서를 발견한 뒤 열립니다.',
                                  ),
                                  const SizedBox(height: 14),
                                  const _HelpRow(
                                    icon: Icons.keyboard_return,
                                    title: '탐색 잠시 중단',
                                    description:
                                        '언제든 이전 화면으로 돌아갈 수 있으며, 발견한 단서 진행 상태는 저장됩니다.',
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('탐색 도움 · 복귀 안내'),
                  ),
                ),

                const SizedBox(height: 28),

                // ======================================
                // 탐색 진행
                // ======================================

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '탐색 진행',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColors.darkBrown,
                        ),
                      ),
                    ),

                    Text(
                      '$discoveredCount / '
                          '${points.length}',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.burgundy,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  borderRadius:
                  BorderRadius.circular(20),
                  backgroundColor:
                  Colors.grey.shade200,
                  color: AppColors.burgundy,
                ),

                const SizedBox(height: 22),

                // ======================================
                // 단서 목록
                // ======================================

                ...points.map(
                      (point) {
                    final discovered =
                    progress.discoveredPointIds
                        .contains(
                      point.id,
                    );

                    final unlocked =
                        discovered ||
                            nextPoint?.id ==
                                point.id;

                    return _ExplorationPointCard(
                      point: point,
                      discovered: discovered,
                      unlocked: unlocked,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ======================================
                // 탐색 진행 중
                // ======================================

                if (!progress.explorationCompleted &&
                    nextPoint != null) ...[
                  // ====================================
                  // 실제 카메라 QR 스캔
                  // ====================================

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                QrScanPage(
                                  reservationId:
                                  reservation.id,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner,
                      ),
                      label: Text(
                        '${nextPoint.title} QR 스캔',
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ====================================
                  // DEBUG 전용 갤러리 QR 테스트
                  // ====================================

                  if (kDebugMode) ...[
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child:
                      OutlinedButton.icon(
                        onPressed: () async {
                          await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  QrGalleryTestPage(
                                    reservationId:
                                    reservation.id,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                        ),
                        label: const Text(
                          '개발용 QR 이미지 테스트',
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        '에뮬레이터 테스트 전용',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ],

                // ======================================
                // 모든 단서 발견 완료
                // ======================================

                if (progress.explorationCompleted) ...[
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.softYellow,
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color:
                          AppColors.burgundy,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            '모든 단서를 발견했습니다.\n'
                                '이제 프로그램 체험 단계로 이동할 수 있습니다.',
                            style: TextStyle(
                              height: 1.5,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              AppColors.darkBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ExperiencePage(
                                  reservationId:
                                  reservation.id,
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        '최종 장소 · 체험 안내',
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================================================
// 탐색 단서 카드
// ==================================================

class _ExplorationPointCard
    extends StatelessWidget {
  final ExplorationPoint point;
  final bool discovered;
  final bool unlocked;

  const _ExplorationPointCard({
    required this.point,
    required this.discovered,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.only(bottom: 12),
      padding:
      const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: discovered
              ? AppColors.burgundy
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: discovered
                ? AppColors.burgundy
                : unlocked
                ? AppColors.softYellow
                : Colors.grey.shade200,
            child: discovered
                ? const Icon(
              Icons.check,
              color: Colors.white,
            )
                : Text(
              '${point.order}',
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: unlocked
                    ? AppColors.burgundy
                    : Colors.grey,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              point.title,
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: unlocked
                    ? AppColors.darkBrown
                    : Colors.grey,
              ),
            ),
          ),

          Icon(
            discovered
                ? Icons.check_circle_outline
                : unlocked
                ? Icons.lock_open_outlined
                : Icons.lock_outline,
            color: discovered || unlocked
                ? AppColors.burgundy
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}

// ==================================================
// 체크인 예약 없음
// ==================================================

class _NoReservationView
    extends StatelessWidget {
  const _NoReservationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_outlined,
                  size: 64,
                  color:
                  AppColors.burgundy,
                ),

                const SizedBox(height: 18),

                Text(
                  '탐색을 시작할 수 있는\n'
                      '체크인 예약이 없습니다.',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '예약 후 체크인을 완료해주세요.',
                  style: TextStyle(
                    color: Colors.grey,
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

// ==================================================
// 예약은 있으나 체크인 전
// ==================================================

class _NotCheckedInView
    extends StatelessWidget {
  const _NotCheckedInView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(32),
            child: Text(
              '탐색을 시작하려면 먼저 체크인이 필요합니다.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.darkBrown,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _HelpRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.softYellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.burgundy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
