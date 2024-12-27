import 'package:hive/hive.dart';

part 'apartment.g.dart';

// Hive 데이터베이스에서 사용할 모델 클래스입니다.
@HiveType(typeId: 0)
class Apartment extends HiveObject {
  // 각 필드에 HiveField 어노테이션을 추가하여 데이터베이스 저장 방식을 정의합니다.
  @HiveField(0)
  final String name; // 아파트 이름

  @HiveField(1)
  final String address; // 주소

  @HiveField(2)
  final String price;

  @HiveField(3)
  final String maintenanceFee;

  @HiveField(4)
  final String size;

  @HiveField(5)
  final String rooms;

  @HiveField(6)
  final String floor;

  @HiveField(7)
  final double rating;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final List<String> images;

  @HiveField(10)
  final List<String> checklist;

  @HiveField(11)
  final Map<String, double> ratings;

  @HiveField(12)
  final Map<String, int> ratingCounts;

  @HiveField(13)
  final Map<String, String> evaluationAnswers;

  // 생성자: 아파트 객체를 생성할 때 필요한 모든 정보를 받습니다.
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
    this.evaluationAnswers = const {},
  });

  // 기존 객체를 기반으로 새로운 객체를 생성하는 메서드
  Apartment copyWith({
    String? name,
    String? address,
    String? price,
    String? maintenanceFee,
    String? size,
    String? rooms,
    String? floor,
    double? rating,
    String? description,
    List<String>? images,
    List<String>? checklist,
    Map<String, double>? ratings,
    Map<String, int>? ratingCounts,
    Map<String, String>? evaluationAnswers,
  }) {
    return Apartment(
      name: name ?? this.name,
      address: address ?? this.address,
      price: price ?? this.price,
      maintenanceFee: maintenanceFee ?? this.maintenanceFee,
      size: size ?? this.size,
      rooms: rooms ?? this.rooms,
      floor: floor ?? this.floor,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      images: images ?? this.images,
      checklist: checklist ?? this.checklist,
      ratings: ratings ?? this.ratings,
      ratingCounts: ratingCounts ?? this.ratingCounts,
      evaluationAnswers: evaluationAnswers ?? this.evaluationAnswers,
    );
  }

  // 고유 키를 생성하는 getter 추가
  String get storageKey => '$name#$address';
}
