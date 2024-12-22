import 'package:flutter/material.dart';

import '../../data/models/apartment.dart';

/// 평가 차트와 평가 항목들을 표시하는 위젯
class RatingChartSection extends StatelessWidget {
  final Apartment apartment;

  const RatingChartSection({
    super.key,
    required this.apartment,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildRatingBar('좋음', 0.4, Colors.blue, '11'),
          _buildRatingBar('보통', 0.5, Colors.green, '12'),
          _buildRatingBar('나쁨', 0.1, Colors.red, '2'),
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
          ['없어요', '조금 있어요', '많이 있어요'],
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
          children: options
              .map((option) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Text(option),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
