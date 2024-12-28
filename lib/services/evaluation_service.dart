import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 평가 관련 기능을 처리하는 서비스 클래스입니다.
class EvaluationService {
  static Map<String, Map<String, List<String>>>? _cachedCategories;

  /// 앱 시작시 한 번만 실행되는 초기화
  static Future<void> initialize() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/evaluation_list.json');
      final json = jsonDecode(jsonString);
      _cachedCategories = Map<String, Map<String, List<String>>>.from(
        json['categories'].map((key, value) => MapEntry(
              key,
              Map<String, List<String>>.from(
                value.map((k, v) => MapEntry(
                      k,
                      List<String>.from(v),
                    )),
              ),
            )),
      );
    } catch (e) {
      debugPrint('평가 초기화 중 오류 발생: $e');
      _cachedCategories = {
        '실내': {
          '집의 전반적인 채광량은 어떤가요?': ['나빠요', '보통이에요', '좋아요'],
        }
      };
    }
  }

  /// 빈 답변 맵 생성
  static Map<String, String> createEmptyAnswers() {
    if (_cachedCategories == null) {
      throw StateError('EvaluationService가 초기화되지 않았습니다.');
    }

    Map<String, String> answers = {};
    _cachedCategories!.forEach((category, questions) {
      questions.forEach((question, _) {
        answers[question] = '';
      });
    });
    return answers;
  }

  /// 모든 평가 질문 옵션을 가져옵니다.
  static Future<Map<String, List<String>>> getEvaluationOptions() async {
    if (_cachedCategories == null) {
      throw StateError('EvaluationService가 초기화되지 않았습니다.');
    }

    // 모든 카테고리의 질문들을 하나의 맵으로 병합
    Map<String, List<String>> allQuestions = {};
    _cachedCategories!.forEach((category, questions) {
      allQuestions.addAll(questions);
    });

    return allQuestions;
  }
}
