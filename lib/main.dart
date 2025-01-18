import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_my_apt/data/models/apartment.dart';
import 'package:get_my_apt/screens/first_page.dart';
import 'package:get_my_apt/services/evaluation_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 앱의 시작점입니다.
void main() async {
  // Flutter 엔진과 위젯 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 데이터베이스를 초기화합니다.
  await Hive.initFlutter();

  // Apartment 클래스를 Hive에서 사용할 수 있도록 어댑터를 등록합니다.
  Hive.registerAdapter(ApartmentAdapter());

  // 평가 관련 서비스를 초기화합니다.
  await EvaluationService.initialize();

  // evaluation_list.json에서 카테고리 키 값들을 읽어옵니다
  final String jsonString =
      await rootBundle.loadString('assets/evaluation_list.json');
  final json = jsonDecode(jsonString);
  final categories = (json['categories'] as Map<String, dynamic>).keys.toList();

  // 샘플 아파트 데이터에 카테고리 키 값들을 설정합니다
  final sampleApartment = Apartment(
    key: 'sample_apartment',
    name: '[예시] 재건축 일동 우성아파트',
    address: '서울 송파구 잠실동 101-1',
    price: '7억',
    maintenanceFee: '350,000원',
    size: '42평(141m²)',
    rooms: '4개, 화장실 2개',
    floor: '현재 11층/전체 12층 중 2층',
    rating: 4.0,
    description: '즉시 입주 가능함...',
    images: List.generate(6, (index) => 'image_$index.jpg'),
    checklist: categories, // JSON에서 읽어온 카테고리 키 값들로 설정
    ratings: {'좋음': 0.4, '보통': 0.5, '나쁨': 0.1},
    ratingCounts: {'좋음': 11, '보통': 12, '나쁨': 2},
    evaluationAnswers: EvaluationService.createEmptyAnswers(),
  );

  // 샘플 데이터를 Hive에 저장합니다 (앱 최초 실행 시에만)
  final box = await Hive.openBox<Apartment>('apartments');
  if (box.isEmpty) {
    await box.put(sampleApartment.key, sampleApartment);
  }

  // MyApp 위젯으로 앱을 시작합니다.
  runApp(const MyApp());
}

/// 앱의 루트 위젯입니다.
/// 앱의 테마와 홈 화면을 설정합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirstPage(), // 첫 화면으로 FirstPage를 설정
    );
  }
}
