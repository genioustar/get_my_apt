import 'package:flutter/material.dart';
import 'package:get_my_apt/core/utils/logger.dart';
import 'package:get_my_apt/features/widgets/apartment_info_section.dart';
import 'package:get_my_apt/features/widgets/checklist_section.dart';
import 'package:get_my_apt/features/widgets/rating_chart_section.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/apartment.dart';

/// 아파트 상세 정보를 보여주는 화면입니다.
class ApartmentDetailScreen extends StatefulWidget {
  final Apartment apartment; // 표시할 아파트 정보
  final bool isNewApartment; // 새로운 매물인지 여부

  const ApartmentDetailScreen({
    super.key,
    required this.apartment,
    this.isNewApartment = false,
  });

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen>
    with LoggerMixin {
  late Apartment _apartment; // 현재 표시중인 아파트 정보

  @override
  void initState() {
    super.initState();
    _apartment = widget.apartment;
  }

  // void _loadApartment() async {
  //   try {
  //     final box = await Hive.openBox<Apartment>('apartments');
  //     final apartment = box.get(_apartment.storageKey);

  //     if (mounted && apartment != null) {
  //       setState(() {
  //         _apartment = apartment;
  //       });
  //     }
  //     logger.i('로드된 아파트 데이터: ${apartment?.name ?? "없음"}');
  //   } catch (e, stackTrace) {
  //     logger.e('아파트 데이터 로드 실패', error: e, stackTrace: stackTrace);
  //   }
  // }

  /// 아파트 정보를 Hive에 저장하는 메서드
  Future<void> _saveApartment() async {
    if (!mounted) return;

    try {
      final box = await Hive.openBox<Apartment>('apartments');
      await box.put(_apartment.key, _apartment);
      logger.i('아파트 정보 저장 완료: ${_apartment.name}');

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

  void _onApartmentUpdated(Apartment newApartment) {
    setState(() {
      _apartment = newApartment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아파트 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ApartmentInfoSection.showRegistrationDialog(
                context,
                _apartment,
                _onApartmentUpdated,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApartmentInfoSection(
                apartment: _apartment,
                isNewApartment: widget.isNewApartment,
                onApartmentUpdated: _onApartmentUpdated,
              ),
              const EvaluationSection(),
              const ImageGridSection(),
              ChecklistSection(apartment: _apartment),
              RatingChartSection(apartment: _apartment),
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
        );
      },
    );
  }
}
