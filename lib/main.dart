import 'package:flutter/material.dart';
import 'package:get_my_apt/data/models/apartment.dart';
import 'package:get_my_apt/screens/first_page.dart';
import 'package:get_my_apt/services/evaluation_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 앱 실행 시 기본으로 제공되는 샘플 아파트 데이터
/// 사용자가 앱을 처음 실행할 때 이 데이터가 Hive 데이터베이스에 저장됩니다.
final _sampleApartment = Apartment(
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
  checklist: [
    '전체',
    '실내',
    '친환',
    '주방',
    '현관',
    '거실',
    '침실',
    '화장실',
    '발코니',
    '보안',
    '주차',
    '교통',
    '편의시설',
    '학군',
  ],
  ratings: {'좋음': 0.4, '보통': 0.5, '나쁨': 0.1},
  ratingCounts: {'좋음': 11, '보통': 12, '나쁨': 2},
  evaluationAnswers: {},
);

/// 앱의 시작점입니다.
/// 여기서 필요한 초기화 작업을 수행합니다:
/// 1. Flutter 바인딩 초기화
/// 2. Hive 데이터베이스 초기화
/// 3. Apartment 모델 어댑터 등록
/// 4. 평가 서비스 초기화
void main() async {
  // Flutter 엔진과 위젯 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 데이터베이스를 초기화합니다.
  await Hive.initFlutter();

  // Apartment 클래스를 Hive에서 사용할 수 있도록 어댑터를 등록합니다.
  Hive.registerAdapter(ApartmentAdapter());

  // 평가 관련 서비스를 초기화합니다.
  await EvaluationService.initialize();

  // 샘플 데이터를 Hive에 저장합니다 (앱 최초 실행 시에만)
  final box = await Hive.openBox<Apartment>('apartments');
  if (box.isEmpty) {
    await box.put(_sampleApartment.storageKey, _sampleApartment);
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
