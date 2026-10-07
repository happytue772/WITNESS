import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/program.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/services/auth_service.dart';
import 'preparation_page.dart';

class ReservationPage extends StatelessWidget {
  final Program program;
  final String? recommendedSenseType;

  const ReservationPage({
    super.key,
    required this.program,
    this.recommendedSenseType,
  });

  void _reserve(BuildContext context) {
    final reservation =
        LocalRepository.instance.createDemoReservation(
      program: program,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PreparationPage(
          reservationId: reservation.id,
        ),
      ),
    );
  }

  void _showScheduleNotice(
    BuildContext context,
  ) {
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  '운영 일정 안내',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '현재 앱은 DEMO 단계이므로 실제 운영 날짜와 회차 시간은 확정하지 않습니다. '
                  '운영 일정이 확정되면 예약 가능한 날짜와 회차를 이 화면에서 선택할 수 있도록 연결합니다.',
                  style: TextStyle(
                    height: 1.6,
                    color: AppColors.darkBrown,
                  ),
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
  }

  @override
  Widget build(BuildContext context) {
    final session = LocalRepository.instance
        .demoSessionForProgram(program.id);

    final auth = AuthService.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          '프로그램 예약',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ),
      bottomNavigationBar:
          const HomeNavigationBottomBar(
        warningTitle: '예약을 중단할까요?',
        warningMessage:
            '아직 예약이 확정되지 않았습니다. 홈으로 이동하면 예약을 다시 진행해야 합니다.',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              if (recommendedSenseType != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softYellow,
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppColors.burgundy,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          '회복 유형 테스트 결과 · '
                          '$recommendedSenseType형 추천',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.darkBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
              ],
              Text(
                program.title,
                style: const TextStyle(
                  fontSize: 30,
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
              const SizedBox(height: 22),
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
                        '프라이빗 1인 예약입니다.\n'
                        '예약 인원은 본인 1명으로 고정되며 동반인을 추가할 수 없습니다. '
                        '함께 참여하는 사람도 각자 본인 인증 후 별도로 예약해야 합니다.',
                        style: TextStyle(
                          height: 1.55,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const _SectionTitle('예약자'),
              const SizedBox(height: 12),
              _OutlinedInfoCard(
                icon: Icons.verified_user_outlined,
                title: '본인 인증 완료',
                subtitle: auth.maskedPhoneNumber.isEmpty
                    ? '인증된 사용자'
                    : auth.maskedPhoneNumber,
                trailing: '1인',
              ),
              const SizedBox(height: 28),
              const _SectionTitle('날짜'),
              const SizedBox(height: 12),
              InkWell(
                borderRadius:
                    BorderRadius.circular(18),
                onTap: () {
                  _showScheduleNotice(context);
                },
                child: const _OutlinedInfoCard(
                  icon:
                      Icons.calendar_month_outlined,
                  title: '시연용 일정',
                  subtitle: '실제 운영 날짜 미정',
                  trailing: 'DEMO',
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('회차'),
              const SizedBox(height: 12),
              _OutlinedInfoCard(
                icon: Icons.schedule_outlined,
                title: session.label,
                subtitle: '시연용 단일 회차',
                trailing: '선택됨',
              ),
              const SizedBox(height: 28),
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
                child: Column(
                  children: [
                    _InfoRow(
                      label: '장소',
                      value: program.location,
                    ),
                    _InfoRow(
                      label: '소요 시간',
                      value:
                          '${program.durationMinutes}분',
                    ),
                    const _InfoRow(
                      label: '예약 인원',
                      value: '본인 1명',
                    ),
                    _InfoRow(
                      label: '프로그램 정원',
                      value:
                          '${program.capacity}명',
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                '※ 프로그램 정원은 전체 운영 정원이며, 한 계정에서 여러 명을 함께 예약하는 기능은 제공하지 않습니다.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _reserve(context);
                  },
                  child: const Text(
                    '1인 예약 확정',
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBrown,
      ),
    );
  }
}

class _OutlinedInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  const _OutlinedInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.burgundy.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.burgundy,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.burgundy,
            ),
          ),
        ],
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
              width: 102,
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
