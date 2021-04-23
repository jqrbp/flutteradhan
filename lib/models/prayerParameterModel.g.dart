// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savedCoordinateModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerParameterAdapter extends TypeAdapter<PrayerParameter> {
  @override
  final int typeId = 0;

  @override
  PrayerParameter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerParameter(
      methodIndex: fields[0] as int,
      madhabIndex: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerParameter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.methodIndex)
      ..writeByte(1)
      ..write(obj.madhabIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerParameterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
