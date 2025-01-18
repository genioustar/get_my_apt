import 'package:flutter/material.dart';
import 'package:get_my_apt/core/utils/logger.dart';
import 'package:get_my_apt/screens/detail_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/apartment.dart';
import '../services/evaluation_service.dart';

/// 아파트 매물 목록을 보여주는 첫 화면 위젯
///
/// 주요 기능:
/// - 등록된 아파트 매물 목록을 리스트 또는 지도로 표시
/// - 새로운 매물 등록 기능
/// - 매물 상세 정보 조회
/// - 매물 삭제 기능
/// - 당겨서 새로고침 기능
class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

/// FirstPage의 상태를 관리하는 State 클래스
///
/// LoggerMixin을 사용하여 로깅 기능을 포함
class _FirstPageState extends State<FirstPage> with LoggerMixin {
  // 아파트 목록을 저장하는 리스트
  // Hive 데이터베이스에서 로드한 아파트 정보들이 저장됨
  List<Apartment> _apartments = [];

  // 데이터 로딩 상태를 표시하는 플래그
  // true일 경우 로딩 인디케이터를 표시
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 아파트 데이터를 로드
    _loadApartments();
  }

  /// Hive 데이터베이스에서 아파트 데이터를 불러오는 함수
  ///
  /// 동작 과정:
  /// 1. 로딩 상태를 true로 설정
  /// 2. Hive 박스를 열어 아파트 데이터에 접근
  /// 3. 모든 아파트 데이터를 리스트로 변환하여 _apartments에 저장
  /// 4. 로딩 상태를 false로 변경
  ///
  /// 에러 처리:
  /// - 데이터 로드 실패 시 로그에 에러를 기록
  /// - 로딩 상태를 false로 변경하여 UI 업데이트
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

  /// 새로운 빈 아파트 객체를 생성하는 함수
  ///
  /// 동작 과정:
  /// 1. EvaluationService에서 평가 카테고리 목록을 가져옴
  /// 2. 모든 필드가 비어있는 새로운 Apartment 객체를 생성
  ///
  /// 반환값:
  /// - 빈 필드로 초기화된 새로운 Apartment 객체
  ///
  /// 참고:
  /// - 평가 답변은 EvaluationService를 통해 생성
  /// - 기본 평점과 평가 카운트는 0으로 초기화
  Apartment _createEmptyApartment() {
    // EvaluationService의 categories getter를 통해 카테고리 목록을 가져옵니다
    final categories = EvaluationService.categories?.keys.toList() ?? [];

    return Apartment(
      key: 'empty_apartment',
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
      checklist: categories, // 캐시된 카테고리 사용
      ratings: {'좋음': 0.0, '보통': 0.0, '나쁨': 0.0},
      ratingCounts: {'좋음': 0, '보통': 0, '나쁨': 0},
      evaluationAnswers: EvaluationService.createEmptyAnswers(),
    );
  }

  /// 아파트 데이터를 삭제하는 함수
  ///
  /// 매개변수:
  /// - [apartment]: 삭제할 아파트 객체
  ///
  /// 동작 과정:
  /// 1. Hive 박스를 열어 데이터베이스에 접근
  /// 2. storageKey를 사용하여 해당 아파트 정보를 삭제
  /// 3. 아파트 목록을 새로고침
  /// 4. 성공/실패 여부를 스낵바로 표시
  ///
  /// 에러 처리:
  /// - 삭제 실패 시 로그에 에러를 기록하고 실패 메시지를 표시
  /// - mounted 체크를 통해 위젯이 여전히 유효한지 확인
  Future<void> _deleteApartment(Apartment apartment) async {
    try {
      final box = await Hive.openBox<Apartment>('apartments');
      await box.delete(apartment.key);
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

  /// 화면 UI를 구성하는 build 메서드
  ///
  /// 주요 구성요소:
  /// - AppBar: 앱 상단 바
  /// - TabBar: 리스트/지도 뷰 전환 탭
  /// - TabBarView: 탭에 따른 컨텐츠 표시
  ///   - 리스트 뷰: 매물 목록을 카드 형태로 표시
  ///   - 지도 뷰: (미구현) 지도 상에 매물 위치 표시
  /// - FloatingActionButton: 새로운 매물 추가 버튼
  ///
  /// 특징:
  /// - 로딩 중일 때는 로딩 인디케이터 표시
  /// - 매물이 없을 때는 안내 메시지 표시
  /// - 매물 카드는 좌우 스와이프로 삭제 가능
  /// - 매물 카드 터치 시 상세 정보 화면으로 이동
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
                        // 리스트 뷰 - 당겨서 새로고침 가능
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
          label: const Text(
            '새로운 매물 체크',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
