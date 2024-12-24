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
  final Map<String, int> checklist;

  @HiveField(11)
  final Map<String, double> ratings;

  @HiveField(12)
  final Map<String, int> ratingCounts;

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
