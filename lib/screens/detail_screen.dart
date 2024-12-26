import 'package:flutter/material.dart';
import 'package:get_my_apt/core/utils/logger.dart';
import 'package:get_my_apt/data/services/apartment_storage_service.dart';
import 'package:get_my_apt/features/widgets/apartment_info_section.dart';
import 'package:get_my_apt/features/widgets/checklist_section.dart';
import 'package:get_my_apt/features/widgets/rating_chart_section.dart';

import '../data/models/apartment.dart';

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
  checklist: {
    '전체': 251,
    '실내': 3,
    '친환': 0,
    '주방': 5,
    '현관': 2,
    '거실': 4,
    '침실': 3,
    '화장실': 2,
    '발코니': 1,
    '보안': 3,
    '주차': 2,
    '교통': 4,
    '편의시설': 3,
    '학군': 2,
  },
  ratings: {'좋음': 0.4, '보통': 0.5, '나쁨': 0.1},
  ratingCounts: {'좋음': 11, '보통': 12, '나쁨': 2},
  evaluationAnswers: {},
);

class ApartmentDetailScreen extends StatefulWidget {
  const ApartmentDetailScreen({super.key});

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen>
    with LoggerMixin {
  Apartment? _apartment;

  void _loadApartment() {
    try {
      final apartment =
          ApartmentStorageService.loadApartment('서울 송파구 잠실동 101-1');
      logger.i('로드된 아파트 데이터: ${apartment?.name ?? "없음"}');

      setState(() {
        _apartment = apartment ?? _sampleApartment;
      });
    } catch (e, stackTrace) {
      logger.e('아파트 데이터 로드 실패', error: e, stackTrace: stackTrace);
      setState(() {
        _apartment = _sampleApartment;
      });
    }
  }

  Future<void> _saveApartment() async {
    if (!mounted) return;

    try {
      await ApartmentStorageService.saveApartment(_sampleApartment);
      logger.i('아파트 정보 저장 완료: ${_sampleApartment.name}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아파트 정보가 저장되었습니다')),
      );
    } catch (e, stackTrace) {
      logger.e('아파트 저장 실패', error: e, stackTrace: stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    logger.d('DetailScreen initState 호출');
    _loadApartment();
  }

  @override
  void dispose() {
    logger.d('DetailScreen dispose 호출');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아파트 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveApartment,
          ),
        ],
      ),
      body: _apartment == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ApartmentInfoSection(apartment: _apartment!),
                    EvaluationSection(),
                    ImageGridSection(),
                    ChecklistSection(apartment: _apartment!),
                    RatingChartSection(apartment: _apartment!),
                  ],
                ),
              ),
            ),
    );
  }
}

class EvaluationSection extends StatelessWidget {
  const EvaluationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('평가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
                  4,
                  (index) => const Icon(Icons.star, color: Colors.blue),
                ) +
                [const Icon(Icons.star_border, color: Colors.blue)],
          ),
          const SizedBox(height: 8),
          const Text(
              '즉시 입주 가능함. 전반적으로 깔끔하고 잘 관리된 편. 아파트 내 조경과 신책로가 잘되어 있음. 주차는 세대당 1대.'),
        ],
      ),
    );
  }
}

class ImageGridSection extends StatelessWidget {
  const ImageGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[200],
          // 실제 이미지는 Image.network() 등으로 구현
        );
      },
    );
  }
}
