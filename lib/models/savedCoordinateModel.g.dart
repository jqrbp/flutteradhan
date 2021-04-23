// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savedCoordinateModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedCoordinateAdapter extends TypeAdapter<SavedCoordinate> {
  @override
  final int typeId = 1;

  @override
  SavedCoordinate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedCoordinate(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SavedCoordinate obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCoordinateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
