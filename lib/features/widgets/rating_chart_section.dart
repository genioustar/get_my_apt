import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/models/apartment.dart';
import '../../services/evaluation_service.dart';

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
  Map<String, String> selectedAnswers = {};
  Map<String, List<String>> evaluationOptions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('현재 평가 답변: ${widget.apartment.evaluationAnswers}');
    selectedAnswers = widget.apartment.evaluationAnswers;
    _initializeEvaluation();
  }

  Future<void> _initializeEvaluation() async {
    try {
      if (selectedAnswers.isEmpty) {
        // 빈 맵인 경우에만 초기화
        selectedAnswers = EvaluationService.createEmptyAnswers();
      }

      evaluationOptions = await EvaluationService.getEvaluationOptions();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: evaluationOptions.entries.map((entry) {
        return Column(
          children: [
            _buildEvaluationQuestion(
              entry.key,
              entry.value,
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
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
              } else {
                backgroundColor = Colors.grey;
              }
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedAnswers[question] = option;
                      // 상태 업데이트 후 Hive에 저장
                      _updateApartmentEvaluation();
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

  /// Hive에 평가 결과 저장
  Future<void> _updateApartmentEvaluation() async {
    try {
      final updatedApartment = Apartment(
        name: widget.apartment.name,
        address: widget.apartment.address,
        price: widget.apartment.price,
        maintenanceFee: widget.apartment.maintenanceFee,
        size: widget.apartment.size,
        rooms: widget.apartment.rooms,
        floor: widget.apartment.floor,
        rating: widget.apartment.rating,
        description: widget.apartment.description,
        images: widget.apartment.images,
        checklist: widget.apartment.checklist,
        ratings: widget.apartment.ratings,
        ratingCounts: widget.apartment.ratingCounts,
        evaluationAnswers: selectedAnswers,
      );

      final box = await Hive.openBox<Apartment>('apartments');
      await box.put(widget.apartment.key, updatedApartment);
    } catch (e) {
      debugPrint('평가 저장 중 오류 발생: $e');
    }
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

  /// 전체 평가 결과를 계산하는 메서드
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
}
