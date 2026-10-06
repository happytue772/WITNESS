import 'package:flutter/material.dart';

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
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.softYellow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'DEMO 예약입니다.\n'
                    '실제 운영 날짜와 회차 시간은 아직 확정되지 않았습니다.',
                style: TextStyle(
                  height: 1.5,
                  color: AppColors.darkBrown,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              widget.program.title,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),

            const SizedBox(height: 24),

            _InfoRow(
              label: '감각',
              value: widget.program.senseType,
            ),
            _InfoRow(
              label: '장소',
              value: widget.program.location,
            ),
            _InfoRow(
              label: '회차',
              value: session.label,
            ),
            _InfoRow(
              label: '소요 시간',
              value: '${widget.program.durationMinutes}분',
            ),
            _InfoRow(
              label: '정원',
              value: '${widget.program.capacity}명',
            ),

            const SizedBox(height: 18),

            const Text(
              '예약 인원',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  onPressed: _decreaseGuest,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 70,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$_guestCount명',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _increaseGuest,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _reserve,
                child: const Text(
                  'DEMO 예약 확정',
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
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 90,
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}