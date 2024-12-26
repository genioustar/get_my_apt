// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApartmentAdapter extends TypeAdapter<Apartment> {
  @override
  final int typeId = 0;

  @override
  Apartment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Apartment(
      name: fields[0] as String,
      address: fields[1] as String,
      price: fields[2] as String,
      maintenanceFee: fields[3] as String,
      size: fields[4] as String,
      rooms: fields[5] as String,
      floor: fields[6] as String,
      rating: fields[7] as double,
      description: fields[8] as String,
      images: (fields[9] as List).cast<String>(),
      checklist: (fields[10] as List).cast<String>(),
      ratings: (fields[11] as Map).cast<String, double>(),
      ratingCounts: (fields[12] as Map).cast<String, int>(),
      evaluationAnswers: (fields[13] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Apartment obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.maintenanceFee)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.rooms)
      ..writeByte(6)
      ..write(obj.floor)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.images)
      ..writeByte(10)
      ..write(obj.checklist)
      ..writeByte(11)
      ..write(obj.ratings)
      ..writeByte(12)
      ..write(obj.ratingCounts)
      ..writeByte(13)
      ..write(obj.evaluationAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApartmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
