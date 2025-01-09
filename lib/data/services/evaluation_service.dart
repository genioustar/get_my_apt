import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/apartment.dart';
import '../models/evaluation_questions.dart';

class EvaluationService {
  /// JSON 파일에서 평가 질문 데이터를 로드합니다.
  static Future<EvaluationQuestions> loadEvaluationQuestions() async {
    final String jsonString =
        await rootBundle.loadString('assets/evaluation_list.json');
    final json = jsonDecode(jsonString);
    return EvaluationQuestions.fromJson(json);
  }

  /// 아파트 객체에 초기 평가 질문을 설정합니다.
  static Future<void> initializeApartmentEvaluation(Apartment apartment) async {
    final evaluationQuestions = await loadEvaluationQuestions();

    // 이미 평가 답변이 있는 경우 초기화하지 않음
    if (apartment.evaluationAnswers.isNotEmpty) return;

    final Map<String, String> initialAnswers = {};
    evaluationQuestions.questions.forEach((question, _) {
      initialAnswers[question] = ''; // 빈 문자열로 초기화
    });

    final updatedApartment = Apartment(
      key: apartment.key,
      name: apartment.name,
      address: apartment.address,
      price: apartment.price,
      maintenanceFee: apartment.maintenanceFee,
      size: apartment.size,
      rooms: apartment.rooms,
      floor: apartment.floor,
      rating: apartment.rating,
      description: apartment.description,
      images: apartment.images,
      checklist: apartment.checklist,
      ratings: apartment.ratings,
      ratingCounts: apartment.ratingCounts,
      evaluationAnswers: initialAnswers,
    );

    final box = Hive.box<Apartment>('apartments');
    await box.put(apartment.key, updatedApartment);
  }

  /// 모든 평가 질문 옵션을 가져옵니다.
  static Future<Map<String, List<String>>> getEvaluationOptions() async {
    final evaluationQuestions = await loadEvaluationQuestions();
    return evaluationQuestions.questions;
  }
}
