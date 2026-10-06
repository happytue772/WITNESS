import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/program.dart';
import '../../data/repositories/local_repository.dart';
import 'invitation_page.dart';

class ReservationPage extends StatefulWidget {
  final Program program;

  const ReservationPage({
    super.key,
    required this.program,
  });

  @override
  State<ReservationPage> createState() =>
      _ReservationPageState();
}

class _ReservationPageState
    extends State<ReservationPage> {
  int _guestCount = 1;

  void _increaseGuest() {
    if (_guestCount >= widget.program.capacity) {
      return;
    }

    setState(() {
      _guestCount++;
    });
  }

  void _decreaseGuest() {
    if (_guestCount <= 1) {
      return;
    }

    setState(() {
      _guestCount--;
    });
  }

  void _reserve() {
    final reservation =
        LocalRepository.instance.createDemoReservation(
      program: widget.program,
      guestCount: _guestCount,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => InvitationPage(
          reservationId: reservation.id,
        ),
      ),
    );
  }

  void _showScheduleNotice() {
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
                  '운영 일정이 확정되면 이 영역에서 날짜와 회차를 선택할 수 있도록 연결합니다.',
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
        .demoSessionForProgram(widget.program.id);

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
      bottomNavigationBar: const HomeNavigationBottomBar(
        warningTitle: '예약 작성을 중단할까요?',
        warningMessage:
            '아직 예약이 확정되지 않았습니다. 홈으로 이동하면 현재 선택한 인원 등의 설정이 저장되지 않아 예약을 다시 진행해야 할 수 있습니다.',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.program.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.program.senseType} · '
                '${widget.program.location}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.softYellow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.burgundy,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'DEMO 예약 화면입니다.\n'
                        '실제 운영 날짜와 회차 시간은 아직 확정되지 않았습니다.',
                        style: TextStyle(
                          height: 1.5,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const _SectionTitle('날짜 선택'),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _showScheduleNotice,
                child: Container(
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
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.burgundy,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '시연용 일정',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '실제 운영 날짜 미정',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.burgundy,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('회차 선택'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.burgundy,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.softYellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.schedule_outlined,
                        color: AppColors.burgundy,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '시연용 단일 회차',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.burgundy,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('예약 인원'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                    IconButton(
                      onPressed:
                          _guestCount > 1 ? _decreaseGuest : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Expanded(
                      child: Text(
                        '$_guestCount명',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          _guestCount < widget.program.capacity
                              ? _increaseGuest
                              : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.burgundy.withValues(
                      alpha: 0.12,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: '장소',
                      value: widget.program.location,
                    ),
                    _InfoRow(
                      label: '소요 시간',
                      value:
                          '${widget.program.durationMinutes}분',
                    ),
                    _InfoRow(
                      label: '정원',
                      value: '${widget.program.capacity}명',
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _reserve,
                  child: const Text(
                    'DEMO 예약하기',
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
              width: 92,
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
