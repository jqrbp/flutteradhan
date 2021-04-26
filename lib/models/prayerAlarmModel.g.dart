// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayerAlarmModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerAlarmAdapter extends TypeAdapter<PrayerAlarm> {
  @override
  final int typeId = 2;

  @override
  PrayerAlarm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerAlarm(
      alarmIndex: fields[0] as int,
      alarmFlag: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerAlarm obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.alarmIndex)
      ..writeByte(1)
      ..write(obj.alarmFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerAlarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
