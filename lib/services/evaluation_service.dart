import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../data/models/apartment.dart';
import '../data/models/evaluation_questions.dart';

/// 평가 관련 기능을 처리하는 서비스 클래스입니다.
class EvaluationService {
  static Map<String, List<String>>? _cachedQuestions;

  /// 앱 시작시 한 번만 실행되는 초기화
  static Future<void> initialize() async {
    try {
      final questions = await loadEvaluationQuestions();
      _cachedQuestions = questions.questions;
    } catch (e) {
      // 기본값 설정
      _cachedQuestions = {
        '집의 전반적인 채광량은 어떤가요?': ['나빠요', '보통이에요', '좋아요'],
      };
    }
  }

  /// 빈 답변 맵 생성
  static Map<String, String> createEmptyAnswers() {
    if (_cachedQuestions == null) {
      throw StateError('EvaluationService가 초기화되지 않았습니다.');
    }
    return Map.fromEntries(
      _cachedQuestions!.keys.map((q) => MapEntry(q, '')),
    );
  }

  /// JSON 파일에서 평가 질문 데이터를 로드합니다.
  static Future<EvaluationQuestions> loadEvaluationQuestions() async {
    // assets 폴더의 JSON 파일을 읽어옵니다.
    final String jsonString =
        await rootBundle.loadString('assets/evaluation_list.json');
    final json = jsonDecode(jsonString);
    return EvaluationQuestions.fromJson(json);
  }

  /// 아파트 객체에 초기 평가 질문을 설정합니다.
  static Future<void> initializeApartmentEvaluation(Apartment apartment) async {
    try {
      final evaluationQuestions = await loadEvaluationQuestions();
      // 각 질문에 대한 기본 답변을 빈 문자열로 초기화합니다.
      final initialAnswers = Map<String, String>.fromIterable(
        evaluationQuestions.questions.keys,
        value: (key) => '',
      );

      // 업데이트된 아파트 정보를 저장합니다.
      final updatedApartment = apartment.copyWith(
        evaluationAnswers: initialAnswers,
      );

      final box = Hive.box<Apartment>('apartments');
      await box.put(apartment.key, updatedApartment);
    } catch (e) {
      throw Exception('평가 초기화 중 오류가 발생했습니다: $e');
    }
  }

  /// 모든 평가 질문 옵션을 가져옵니다.
  static Future<Map<String, List<String>>> getEvaluationOptions() async {
    try {
      final evaluationQuestions = await loadEvaluationQuestions();
      return evaluationQuestions.questions;
    } catch (e) {
      throw Exception('평가 옵션을 가져오는 중 오류가 발생했습니다: $e');
    }
  }
}
