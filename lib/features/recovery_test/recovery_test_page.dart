import 'package:flutter/material.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import 'recovery_result_page.dart';

class RecoveryTestPage extends StatefulWidget {
  const RecoveryTestPage({super.key});

  @override
  State<RecoveryTestPage> createState() => _RecoveryTestPageState();
}

class _RecoveryTestPageState extends State<RecoveryTestPage> {
  int _currentQuestionIndex = 0;

  final Map<String, int> _scores = {
    '시각': 0,
    '촉각': 0,
    '후각': 0,
  };

  final List<_RecoveryQuestion> _questions = const [
    _RecoveryQuestion(
      question: '지금 가장 편안하게 느껴지는 순간은 언제인가요?',
      options: [
        _RecoveryOption(
          text: '조용한 풍경을 천천히 바라볼 때',
          senseType: '시각',
        ),
        _RecoveryOption(
          text: '바람이나 지면의 감촉을 느낄 때',
          senseType: '촉각',
        ),
        _RecoveryOption(
          text: '좋아하는 향을 맡으며 쉬고 있을 때',
          senseType: '후각',
        ),
      ],
    ),
    _RecoveryQuestion(
      question: '복잡한 생각을 정리할 때 가장 끌리는 방식은?',
      options: [
        _RecoveryOption(
          text: '한 장면이나 한 지점에 시선을 집중한다',
          senseType: '시각',
        ),
        _RecoveryOption(
          text: '천천히 몸을 움직이며 감각에 집중한다',
          senseType: '촉각',
        ),
        _RecoveryOption(
          text: '향이나 공기의 변화를 느끼며 쉰다',
          senseType: '후각',
        ),
      ],
    ),
    _RecoveryQuestion(
      question: '지금 가장 깨우고 싶은 감각은 무엇인가요?',
      options: [
        _RecoveryOption(
          text: '바라보는 감각',
          senseType: '시각',
        ),
        _RecoveryOption(
          text: '몸으로 느끼는 감각',
          senseType: '촉각',
        ),
        _RecoveryOption(
          text: '향을 느끼는 감각',
          senseType: '후각',
        ),
      ],
    ),
  ];

  void _selectAnswer(String senseType) {
    _scores[senseType] = _scores[senseType]! + 1;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      return;
    }

    final result = _getResult();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RecoveryResultPage(
          senseType: result,
        ),
      ),
    );
  }

  String _getResult() {
    String result = '시각';
    int highestScore = -1;

    _scores.forEach((senseType, score) {
      if (score > highestScore) {
        highestScore = score;
        result = senseType;
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress =
        (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          '회복 유형 테스트',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: const [
          HomeNavigationAction(
            warningTitle: '테스트를 중단할까요?',
            warningMessage:
                '홈으로 이동하면 현재 회복 유형 테스트 진행이 종료되고 선택한 답변은 저장되지 않습니다. 다시 테스트해야 합니다.',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEMO TEST',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),

            const SizedBox(height: 14),

            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.softYellow,
              color: AppColors.burgundy,
            ),

            const SizedBox(height: 14),

            Text(
              '${_currentQuestionIndex + 1} / ${_questions.length}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              question.question,
              style: const TextStyle(
                fontSize: 25,
                height: 1.4,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 28),

            ...question.options.map(
                  (option) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _AnswerButton(
                  text: option.text,
                  onTap: () {
                    _selectAnswer(option.senseType);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.burgundy.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.burgundy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoveryQuestion {
  final String question;
  final List<_RecoveryOption> options;

  const _RecoveryQuestion({
    required this.question,
    required this.options,
  });
}

class _RecoveryOption {
  final String text;
  final String senseType;

  const _RecoveryOption({
    required this.text,
    required this.senseType,
  });
}