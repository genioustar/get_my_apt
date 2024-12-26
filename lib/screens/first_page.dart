import 'package:flutter/material.dart';
import 'package:get_my_apt/core/utils/logger.dart';
import 'package:get_my_apt/screens/detail_screen.dart';
import 'package:hive/hive.dart';

import '../data/models/apartment.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with LoggerMixin {
  bool _isLoading = true;
  List<Apartment> _recentApartments = [];
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 최근 본 아파트 목록 로드
      final box = await Hive.openBox<Apartment>('apartments');
      final recentApts = box.values.toList();

      setState(() {
        _recentApartments = recentApts;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      logger.e('데이터 로드 실패', error: e, stackTrace: stackTrace);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDetail(Apartment apartment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApartmentDetailScreen(apartment: apartment),
      ),
    );
  }

  Apartment _createEmptyApartment() {
    return Apartment(
      name: '',
      address: '',
      price: '',
      maintenanceFee: '',
      size: '',
      rooms: '',
      floor: '',
      rating: 0.0,
      description: '',
      images: [],
      checklist: [],
      ratings: {},
      ratingCounts: {},
      evaluationAnswers: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 아파트 구하기'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: '리스트로 보기'),
                      Tab(text: '지도로 보기'),
                    ],
                    labelColor: Colors.black,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // 리스트 뷰
                        ListView(
                          children: [
                            // 예시 아파트
                            _buildApartmentCard(_sampleApartment, true),
                            // 저장된 아파트들
                            ..._recentApartments
                                .map((apt) => _buildApartmentCard(apt, false)),
                          ],
                        ),
                        // 지도 뷰 (추후 구현)
                        const Center(child: Text('지도 준비중')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApartmentDetailScreen(
                  apartment: _createEmptyApartment(),
                  // isNewApartment: true,
                ),
              ),
            );
          },
          label: const Text(
            '새로운 매물 체크',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildApartmentCard(Apartment apartment, bool isSample) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _navigateToDetail(apartment),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                apartment.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${apartment.address}\n${apartment.price}'),
              trailing: Text(
                isSample ? '예시' : DateTime.now().toString().substring(0, 16),
                style: TextStyle(
                  color: isSample ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            if (apartment.evaluationAnswers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('좋음 ${apartment.ratings['좋음']! * 100}%'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
