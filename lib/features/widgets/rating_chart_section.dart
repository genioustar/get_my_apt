import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 평가 차트와 평가 항목들을 표시하는 위젯
class RatingChartSection extends StatefulWidget {
  final Apartment apartment;

  const RatingChartSection({
    super.key,
    required this.apartment,
  });

  @override
  State<RatingChartSection> createState() => _RatingChartSectionState();
}

class _RatingChartSectionState extends State<RatingChartSection> {
  // 각 질문에 대한 선택된 답변을 저장하는 Map
  final Map<String, String> selectedAnswers = {};

  // 전체 평가 결과를 계산하는 메서드
  Map<String, int> _calculateOverallRatings() {
    Map<String, int> ratings = {'좋음': 0, '보통': 0, '나쁨': 0};

    selectedAnswers.forEach((_, answer) {
      if (answer == '좋아요' || answer == '없어요') {
        ratings['좋음'] = ratings['좋음']! + 1;
      } else if (answer == '보통이에요' || answer == '조금 있어요') {
        ratings['보통'] = ratings['보통']! + 1;
      } else if (answer == '나빠요' || answer == '많이 있어요') {
        ratings['나쁨'] = ratings['나쁨']! + 1;
      }
    });

    return ratings;
  }

  @override
  Widget build(BuildContext context) {
    final ratings = _calculateOverallRatings();
    final total = ratings.values.fold<int>(0, (sum, count) => sum + count);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전체 평가',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRatingBar(
            '좋음',
            total > 0 ? ratings['좋음']! / total : 0,
            Colors.blue,
            ratings['좋음'].toString(),
          ),
          _buildRatingBar(
            '보통',
            total > 0 ? ratings['보통']! / total : 0,
            Colors.green,
            ratings['보통'].toString(),
          ),
          _buildRatingBar(
            '나쁨',
            total > 0 ? ratings['나쁨']! / total : 0,
            Colors.red,
            ratings['나쁨'].toString(),
          ),
          const SizedBox(height: 24),
          _buildEvaluationQuestions(),
        ],
      ),
    );
  }

  /// 평가 바를 표시하는 위젯
  Widget _buildRatingBar(
      String label, double ratio, Color color, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label)),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(count),
        ],
      ),
    );
  }

  /// 평가 질문들을 표시하는 위젯
  Widget _buildEvaluationQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEvaluationQuestion(
          '집의 전반적인 채광량은 어떤가요?',
          ['나빠요', '보통이에요', '좋아요'],
        ),
        const SizedBox(height: 16),
        _buildEvaluationQuestion(
          '벽과 천정에 물이 새거나 곰팡이가 있나요?',
          ['많이 있어요', '조금 있어요', '없어요'],
        ),
        const SizedBox(height: 16),
        _buildEvaluationQuestion(
          '집의 방음 상태는 어떤가요?',
          ['나빠요', '보통이에요', '좋아요'],
        ),
      ],
    );
  }

  /// 개별 평가 질문을 표시하는 위젯
  Widget _buildEvaluationQuestion(String question, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            final bool isSelected = selectedAnswers[question] == option;
            Color? backgroundColor;
            Color textColor = isSelected ? Colors.white : Colors.black;

            // 선택된 경우의 배경색 설정
            if (isSelected) {
              if (option == '좋아요' || option == '없어요') {
                backgroundColor = Colors.blue;
              } else if (option == '보통이에요' || option == '조금 있어요') {
                backgroundColor = Colors.green;
              } else if (option == '나빠요' || option == '많이 있어요') {
                backgroundColor = Colors.red;
              }
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedAnswers[question] = option;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: isSelected ? Colors.transparent : Colors.grey),
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor,
                  ),
                  child: Text(option),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
