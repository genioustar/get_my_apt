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
      key: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      price: fields[3] as String,
      maintenanceFee: fields[4] as String,
      size: fields[5] as String,
      rooms: fields[6] as String,
      floor: fields[7] as String,
      rating: fields[8] as double,
      description: fields[9] as String,
      images: (fields[10] as List).cast<String>(),
      checklist: (fields[11] as List).cast<String>(),
      ratings: (fields[12] as Map).cast<String, double>(),
      ratingCounts: (fields[13] as Map).cast<String, int>(),
      evaluationAnswers: (fields[14] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Apartment obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.maintenanceFee)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.rooms)
      ..writeByte(7)
      ..write(obj.floor)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.images)
      ..writeByte(11)
      ..write(obj.checklist)
      ..writeByte(12)
      ..write(obj.ratings)
      ..writeByte(13)
      ..write(obj.ratingCounts)
      ..writeByte(14)
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
