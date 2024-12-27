import 'package:flutter/material.dart';
import 'package:get_my_apt/core/utils/logger.dart';
import 'package:get_my_apt/screens/detail_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/apartment.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with LoggerMixin {
  // 아파트 목록을 저장하는 리스트
  List<Apartment> _apartments = [];
  // 데이터 로딩 상태를 표시하는 플래그
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApartments();
  }

  // Hive 데이터베이스에서 아파트 데이터를 불러오는 함수
  Future<void> _loadApartments() async {
    try {
      setState(() => _isLoading = true);

      // Hive 박스 열기
      final box = await Hive.openBox<Apartment>('apartments');
      logger.i('Hive 박스 열기 성공. 총 데이터 수: ${box.length}');

      setState(() {
        // 모든 데이터를 리스트로 변환 (reversed 제거)
        _apartments = box.values.toList();
        _isLoading = false;
      });

      logger.i('아파트 데이터 로드 완료: ${_apartments.length}개');
    } catch (e, stackTrace) {
      logger.e('아파트 데이터 로드 실패', error: e, stackTrace: stackTrace);
      setState(() => _isLoading = false);
    }
  }

  // 새로운 빈 아파트 객체를 생성하는 함수
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
      // 평가 관련 초기값 설정
      ratings: {'좋음': 0.0, '보통': 0.0, '나쁨': 0.0},
      ratingCounts: {'좋음': 0, '보통': 0, '나쁨': 0},
      evaluationAnswers: {},
    );
  }

  // 아파트 데이터를 삭제하는 함수
  Future<void> _deleteApartment(Apartment apartment) async {
    try {
      final box = await Hive.openBox<Apartment>('apartments');
      // storageKey를 사용하여 데이터 삭제
      await box.delete(apartment.storageKey);
      await _loadApartments();

      if (!mounted) return;
      // 삭제 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('매물이 삭제되었습니다')),
      );
    } catch (e, stackTrace) {
      logger.e('매물 삭제 실패', error: e, stackTrace: stackTrace);

      if (!mounted) return;
      // 삭제 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제 중 오류가 발생했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 아파트 구하기'),
      ),
      // 로딩 중이면 로딩 표시기를 보여주고, 아니면 탭 뷰를 표시
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // 상단 탭바 (리스트/지도 뷰 전환)
                  const TabBar(
                    tabs: [
                      Tab(text: '리스트로 보기'),
                      Tab(text: '지도로 보기'),
                    ],
                    labelColor: Colors.black,
                  ),
                  // 탭 내용
                  Expanded(
                    child: TabBarView(
                      children: [
                        // 리스트 뷰 - 당겨서 새로��침 가능
                        RefreshIndicator(
                          onRefresh: _loadApartments,
                          child: _apartments.isEmpty
                              ? const Center(child: Text('등록된 매물이 없습니다'))
                              : ListView.builder(
                                  reverse: false,
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                    // FAB 높이만큼 bottom padding 추가
                                    bottom: 80,
                                  ),
                                  itemCount: _apartments.length,
                                  itemBuilder: (context, index) {
                                    final apartment = _apartments[index];
                                    return Dismissible(
                                      key: Key(apartment.address),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('매물 삭제'),
                                              content: Text(
                                                  '${apartment.name}을(를) 삭제하시겠습니까?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) {
                                        _deleteApartment(apartment);
                                      },
                                      child: Card(
                                        elevation: 2,
                                        margin:
                                            const EdgeInsets.only(bottom: 1),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ApartmentDetailScreen(
                                                  apartment: apartment,
                                                  isNewApartment: false,
                                                ),
                                              ),
                                            );
                                            _loadApartments();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  apartment.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(apartment.address),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${apartment.price} / 관리비 ${apartment.maintenanceFee}',
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        // 지도 뷰 (미구현)
                        const Center(child: Text('지도 준비중')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // 하단 플로팅 버튼 - 새로운 매물 추가
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          onPressed: () async {
            // 새로운 매물 등록 화면으로 이동
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApartmentDetailScreen(
                  apartment: _createEmptyApartment(),
                  isNewApartment: true,
                ),
              ),
            );
            // 새로운 매물이 추가되었을 수 있으므로 목록 새로고침
            _loadApartments();
          },
          label: const Text('새로운 매물 체크'),
          icon: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
