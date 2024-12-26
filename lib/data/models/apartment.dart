import 'package:hive/hive.dart';

part 'apartment.g.dart';

@HiveType(typeId: 0)
class Apartment extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String address;

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
}
