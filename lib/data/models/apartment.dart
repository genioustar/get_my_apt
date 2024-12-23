/// 아파트 정보를 담는 모델 클래스
class Apartment {
  /// 아파트 이름 (예: "재건축 일동 우성아파트")
  final String name;

  /// 아파트 주소 (예: "서울 송파구 잠실동 101-1")
  final String address;

  /// 전세금액 (예: "7억")
  final String price;

  /// 월 관리비 (예: "350,000원")
  final String maintenanceFee;

  /// 평형 정보 (예: "42평(141m²)")
  final String size;

  /// 방과 욕실 개수 정보 (예: "4개, 화장실 2개")
  final String rooms;

  /// 층수 정보 (예: "현재 11층/전체 12층 중 2층")
  final String floor;

  /// 전체 평점 (0.0 ~ 5.0)
  final double rating;

  /// 상세 설명
  final String description;

  /// 아파트 이미지 URL 목록
  final List<String> images;

  /// 체크리스트 항목별 개수 맵
  /// key: 체크리스트 카테고리 (예: "전체", "실내", "친환", "주방" 등)
  /// value: 해당 카테고리의 체크 항목 개수
  final Map<String, int> checklist;

  /// 평가 점수 분포
  /// key: "좋음", "보통", "나쁨"
  /// value: 각 평가의 비율 (0.0 ~ 1.0)
  final Map<String, double> ratings;

  /// 평가 응답 수
  /// key: "좋음", "보통", "나쁨"
  /// value: 각 평가의 응답 수
  final Map<String, int> ratingCounts;

  /// 생성자
  Apartment({
    required this.name,
    required this.address,
    required this.price,
    required this.maintenanceFee,
    required this.size,
    required this.rooms,
    required this.floor,
    required this.rating,
    required this.description,
    required this.images,
    required this.checklist,
    required this.ratings,
    required this.ratingCounts,
  });
}
